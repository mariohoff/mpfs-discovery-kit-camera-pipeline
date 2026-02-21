package view

import (
	"context"
	"fmt"
	"log/slog"
	"net/http"
	"sync"
	"time"

	"discostream/internal/camera"
	"discostream/internal/dma"
	"discostream/internal/port"
	"discostream/internal/uio"

	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
)

const (
	ViewPath = "templates/"

	CamHresIn = 1280
	CamVresIn = 960

	VDMADestAddr = 0xc800_0000
)

var (
	h264Hres  uint32 = 640
	h264Vres  uint32 = 480
	h264QFact uint32 = 10
)

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool { return true },
}

var (
	clients      = make(map[*websocket.Conn]bool)
	clientsMutex sync.Mutex
)

var framePool = sync.Pool{
	New: func() any {
		// Allocate a slice large enough to hold a typical H.264 frame.
		// 512KB is usually overkill for 320x240, which is safe.
		return make([]byte, 512*1024)
	},
}

type Server struct {
	Router  *gin.Engine
	Monitor *camera.CameraMonitor
	Camera  port.Camera
	VDMA    *uio.VDMADevice
	H264    *uio.H264Device
	dmaBuf  *dma.DMABuffer

	counter    int
	isRunning  bool
	stopWorker context.CancelFunc
	mu         sync.Mutex

	stopCaptureWorker context.CancelFunc
	captureRunning    bool
	captureMu         sync.Mutex
}

func NewServer(mon *camera.CameraMonitor, cam port.Camera, vdma *uio.VDMADevice, h264 *uio.H264Device) *Server {
	dmaBuf, err := dma.New(VDMADestAddr, int(h264.HRes*h264.VRes*2), &framePool)
	if err != nil {
		panic(err)
	}

	s := &Server{
		Monitor: mon,
		Camera:  cam,
		VDMA:    vdma,
		H264:    h264,
		dmaBuf:  dmaBuf,
	}
	h264Hres = (h264.HRes)
	h264Vres = (h264.VRes)
	h264QFact = (h264.QFact)

	s.H264.Reset()
	s.H264.SetQFactor(h264.QFact)
	s.H264.SetPFrameCount(0x10)
	s.H264.SetHres(h264.HRes)
	s.H264.SetVres(h264.VRes)

	s.VDMA.Reset()
	s.VDMA.SetCtrlReg(0)
	s.VDMA.SetGlblIntEnable(0)
	s.VDMA.SetIntMask(0x1)
	s.VDMA.SetDestAddr(VDMADestAddr)

	r := s.SetupRouter()
	s.Router = r

	return s
}

func (s *Server) startTimer() {
	s.mu.Lock()
	defer s.mu.Unlock()

	if s.isRunning {
		return
	}

	ctx, cancel := context.WithCancel(context.Background())
	s.stopWorker = cancel
	s.isRunning = true

	go func(ctx context.Context) {
		ticker := time.NewTicker(1 * time.Second)
		defer ticker.Stop()

		for {
			select {
			case <-ctx.Done():
				return
			case <-ticker.C:
				s.mu.Lock()
				s.counter++
				s.mu.Unlock()
			}
		}
	}(ctx)
}

func (s *Server) stopTimer() {
	s.mu.Lock()
	defer s.mu.Unlock()

	if s.stopWorker != nil {
		s.stopWorker()
		s.isRunning = false
	}
}

func (s *Server) startCapture() {
	s.captureMu.Lock()
	defer s.captureMu.Unlock()

	if s.captureRunning {
		return
	}

	ctx, cancel := context.WithCancel(context.Background())
	s.stopCaptureWorker = cancel
	s.captureRunning = true

	s.H264.Reset()
	s.VDMA.Reset()
	time.Sleep(10 * time.Millisecond)
	s.H264.SetQFactor(s.H264.QFact)
	s.H264.SetPFrameCount(0x10)
	s.H264.SetHres(s.H264.HRes)
	s.H264.SetVres(s.H264.VRes)

	s.VDMA.SetCtrlReg(0)
	s.VDMA.SetGlblIntEnable(0x1)
	s.VDMA.SetIntMask(0x1)
	s.VDMA.SetDestAddr(VDMADestAddr)

	s.H264.SetCtrlReg(0x1) // h264 enable
	s.VDMA.SetCtrlReg(0x1) // vDMA enable
	slog.Info("starting frame capture")

	s.VDMA.ClearInterrupt()
	irqSource := s.VDMA.InterruptChan(ctx)

	var firstFrameReceived bool = false

	// have enough space available
	imgChan := make(chan []byte, 3)

	go func(ctx context.Context, iChan chan []byte) {
		for !firstFrameReceived {
			time.Sleep(100 * time.Millisecond)
		}

		for {
			select {
			case <-ctx.Done():
				return
			case img := <-iChan:
				clientsMutex.Lock()
				for client := range clients {
					if err := client.WriteMessage(websocket.BinaryMessage, img); err != nil {
						client.Close()
						delete(clients, client)
					}
				}
				clientsMutex.Unlock()

				// framePool.Put(img[:cap(img)])
				framePool.Put(img)
			}
		}
	}(ctx, imgChan)

	go func(ctx context.Context, iChan chan []byte) {
		for {
			s.captureMu.Lock()
			s.VDMA.SetDestAddr(VDMADestAddr)
			s.captureMu.Unlock()
			select {
			case <-ctx.Done():
				return
			case <-irqSource:
				s.captureMu.Lock()

				intStatus := s.VDMA.GetIntStatus()
				if intStatus == 0 {
					// This is a ghost interrupt (falling edge).
					// Unmask the UIO at the OS level and go back to waiting.
					s.VDMA.ClearIntStatus(0x1f)
					s.VDMA.ClearInterrupt()
					s.captureMu.Unlock()
					continue
				}

				s.VDMA.SetIntMask(0x0)
				s.VDMA.ClearIntStatus(0x1f)
				_ = s.VDMA.GetIntStatus() // dummy read to force AXI to finish

				sz := s.VDMA.GetFrameSize()
				img := s.dmaBuf.ReadFrame(int(sz))
				select {
				case iChan <- img:
				default:
					slog.Warn("Network buffer full, dropped frame")
				}

				s.VDMA.SetIntMask(0x1)
				s.VDMA.ClearInterrupt()
				if !firstFrameReceived {
					firstFrameReceived = true
				}
				s.captureMu.Unlock()
			}
		}
	}(ctx, imgChan)
}

func (s *Server) stopCapture() {
	s.captureMu.Lock()
	defer s.captureMu.Unlock()

	slog.Info("stopping frame capture")
	if s.stopCaptureWorker != nil {
		s.stopCaptureWorker()
		s.captureRunning = false
		// clear devices
		s.VDMA.SetCtrlReg(0x0)
		s.H264.SetCtrlReg(0x0)
		s.VDMA.SetGlblIntEnable(0x0)
		s.VDMA.ClearInterrupt()
	}
}

func (s *Server) SetupRouter() *gin.Engine {
	router := gin.Default()
	router.LoadHTMLGlob(ViewPath + "*")

	router.GET("/start", func(c *gin.Context) {
		s.startCapture()
		c.JSON(200, gin.H{"status": "started"})
	})

	router.GET("/stop", func(c *gin.Context) {
		s.stopCapture()
		c.JSON(200, gin.H{"status": "stopped"})
	})

	// Data Route
	router.GET("/status", func(c *gin.Context) {
		s.mu.Lock()
		defer s.mu.Unlock()
		c.JSON(200, gin.H{
			"active": s.captureRunning,
		})
	})

	router.GET("/", func(c *gin.Context) {
		c.HTML(http.StatusOK, "index.html", gin.H{"Title": "Hello, Gin!"})
	})

	router.GET("/stream/enable", func(c *gin.Context) {
		slog.Info("Enabling h264 stream")
		s.VDMA.SetGlblIntEnable(0x1)
		s.H264.SetCtrlReg(0x1)
		s.VDMA.SetCtrlReg(0x1)
		c.String(http.StatusOK, "Stream enabled")
	})

	router.GET("/stream/disable", func(c *gin.Context) {
		slog.Info("Disabling h264 stream")
		s.VDMA.SetGlblIntEnable(0x0)
		s.VDMA.SetCtrlReg(0x0)
		s.H264.SetCtrlReg(0x0)
		// flush fifo
		slog.Info("flushing FIFO")
		s.VDMA.SetCtrlReg(0x4)
		c.String(http.StatusOK, "Stream disabled")
	})

	router.GET("/camera/isenabled", func(c *gin.Context) {
		c.HTML(http.StatusOK, "enable.tmpl", gin.H{"Enabled": s.Monitor.IsEnabled(), "GPIO": s.Monitor.GPIO()})
	})

	router.GET("/camera/enable", func(c *gin.Context) {
		slog.Info("Enabling camera")
		s.Monitor.Enable()
		s.Monitor.SetGPIO(1)
		slog.Info("Enable state:", "enable", s.Monitor.IsEnabled(), "gpio", s.Monitor.GPIO())
		c.HTML(http.StatusOK, "enable.tmpl", gin.H{"Enabled": s.Monitor.IsEnabled(), "GPIO": s.Monitor.GPIO()})
	})

	router.GET("/camera/disable", func(c *gin.Context) {
		slog.Info("Disabling camera")
		s.Monitor.Disable()
		s.Monitor.SetGPIO(0)
		slog.Info("Enable state:", "enable", s.Monitor.IsEnabled(), "gpio", s.Monitor.GPIO())
		c.HTML(http.StatusOK, "enable.tmpl", gin.H{"Enabled": s.Monitor.IsEnabled(), "GPIO": s.Monitor.GPIO()})
	})

	router.GET("/camera/state", func(c *gin.Context) {
		if s.Monitor.IsEnabled() {
			state, err := s.Monitor.GetState()
			if err != nil {
				c.String(http.StatusInternalServerError, "error when fetching camera state", gin.H{"Error": err})
			}
			slog.Info("camera state:", "state", state)
			c.HTML(http.StatusOK, "state.tmpl", gin.H{"State": state})
		} else {
			c.String(http.StatusOK, "<b>Monitor not enabled</b>")
		}
	})

	router.GET("/ws", func(c *gin.Context) {
		conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
		if err != nil {
			return
		}
		clientsMutex.Lock()
		clients[conn] = true
		clientsMutex.Unlock()
		s.H264.ForceIFrame()
		slog.Info("new browser connected")
	})

	router.GET("/camera/init", func(c *gin.Context) {
		slog.Info("sending init sequence")
		s.Monitor.ResetCamera()
		err := s.Camera.Init()
		if err != nil {
			c.String(http.StatusInternalServerError, "error during camera init", gin.H{"Error": err})
		}
		slog.Info(fmt.Sprintf("Set resolution to %dx%d in and %dx%d out", CamHresIn, CamVresIn, h264Hres, h264Vres))
		s.Monitor.SetScalerResIn(CamHresIn, CamVresIn)
		s.Monitor.SetScalerResOut(h264Hres, h264Vres)
		slog.Info("Setting bayer format to BGGR")
		s.Monitor.SetBayerFormat(camera.BayerBGGR)
		slog.Info("init done. Waiting a short time for state change")
		time.Sleep(100 * time.Millisecond)

		state, err := s.Monitor.GetState()
		if err != nil {
			c.String(http.StatusInternalServerError, "error when fetching camera state", gin.H{"Error": err})
		}
		slog.Info("camera state:", "state", state)
		// c.String(http.StatusOK, "camera init done")
		c.HTML(http.StatusOK, "state.tmpl", gin.H{"State": state})
	})
	router.GET("/camera/reset", func(c *gin.Context) {
		s.Monitor.ResetCamera()
		c.String(http.StatusOK, "reset done")
	})

	return router
}
