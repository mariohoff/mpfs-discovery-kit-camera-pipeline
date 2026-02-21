package camera

import (
	"fmt"
	"syscall"
	"unsafe"
)

type CameraMonitor struct {
	enabled     bool
	gpio        int
	monitorPtr  unsafe.Pointer
	monitorMmap []byte
}

type CameraState struct {
	Frames       uint32 `json:"frames"`
	Lines        uint32 `json:"lines"`
	LinePixel    uint32 `json:"line_pixel"`
	FPS          uint32 `json:"fps"`
	Pixel        uint32 `json:"pixel"`
	HResIn       uint32 `json:"hres_in"`
	VResIn       uint32 `json:"vres_in"`
	HResOut      uint32 `json:"hres_out"`
	VResOut      uint32 `json:"vres_out"`
	HScale       uint32 `json:"hscale"`
	VScale       uint32 `json:"vscale"`
	Errors       uint32 `json:"errors"`
	IntCount     uint32 `json:"int_count"`
	IntPerSecond uint32 `json:"int_per_s"`
}

func New() (*CameraMonitor, error) {
	fd, err := syscall.Open("/dev/mem", syscall.O_RDWR|syscall.O_SYNC, 0)
	if err != nil {
		return nil, fmt.Errorf("failed to open /dev/mem: %v", err)
	}

	monMmap, err := syscall.Mmap(fd, int64(CameraMonitorAPB), CameraMonitorSize,
		syscall.PROT_READ|syscall.PROT_WRITE, syscall.MAP_SHARED)
	if err != nil {
		return nil, fmt.Errorf("failed to mmap Camera module: %v", err)
	}

	mon := &CameraMonitor{
		enabled:     false,
		gpio:        0,
		monitorPtr:  unsafe.Pointer(&monMmap[0]),
		monitorMmap: monMmap,
	}
	return mon, nil
}

func (c *CameraMonitor) getRegVal(regOffset uint32) uint32 {
	regPtr := (*uint32)(unsafe.Add(c.monitorPtr, uintptr(regOffset)))
	return *regPtr
}

func (c *CameraMonitor) setRegVal(regOffset, val uint32) {
	regPtr := (*uint32)(unsafe.Add(c.monitorPtr, uintptr(regOffset)))
	*regPtr = val
}

func (c *CameraMonitor) GetState() (*CameraState, error) {
	if !c.enabled {
		return nil, fmt.Errorf("camera not enabled. enabled: %v, gpio: %v", c.enabled, c.gpio)
	}

	state := &CameraState{}
	state.Frames = c.FrameCount()
	state.Lines = c.LineCount()
	state.LinePixel = c.LinePixelCount()
	state.FPS = c.FPS()
	state.HResIn, state.VResIn = c.GetScalerResIn()
	state.HResOut, state.VResOut = c.GetScalerResOut()
	state.HScale, state.VScale = c.GetScalerFactors()
	state.Errors = c.ErrorCount()
	state.IntCount = c.GetIntCount()
	state.IntPerSecond = c.GetIntPerSecond()

	return state, nil
}

func (c *CameraMonitor) IsEnabled() bool {
	return c.enabled
}

func (c *CameraMonitor) GPIO() int {
	return c.gpio
}

func (c *CameraMonitor) SetScalerResIn(hres, vres uint32) {
	c.setRegVal(CameraHresIn, hres)
	c.setRegVal(CameraVresIn, vres)
}

func (c *CameraMonitor) SetScalerResOut(hres, vres uint32) {
	hIn, vIn := c.GetScalerResIn()
	hfact := ((hIn - 1) * 1024) / hres
	vfact := ((vIn - 1) * 1024) / vres
	c.setRegVal(CameraHresOut, hres)
	c.setRegVal(CameraVresOut, vres)
	c.setRegVal(CameraHfact, hfact)
	c.setRegVal(CameraVfact, vfact)
}

func (c *CameraMonitor) GetScalerResIn() (uint32, uint32) {
	return c.getRegVal(CameraHresIn), c.getRegVal(CameraVresIn)
}

func (c *CameraMonitor) GetScalerResOut() (uint32, uint32) {
	return c.getRegVal(CameraHresOut), c.getRegVal(CameraVresOut)
}

func (c *CameraMonitor) GetScalerFactors() (uint32, uint32) {
	return c.getRegVal(CameraHfact), c.getRegVal(CameraVfact)
}

func (c *CameraMonitor) GetBayerFormat() uint32 {
	return c.getRegVal(CameraBayerFormatReg)
}

func (c *CameraMonitor) SetBayerFormat(format uint32) {
	c.setRegVal(CameraBayerFormatReg, format)
}

func (c *CameraMonitor) ResetCamera() {
	c.setRegVal(CameraReset, 1)
}

func (c *CameraMonitor) FPS() uint32 {
	return c.getRegVal(CameraFPS)
}

func (c *CameraMonitor) FrameCount() uint32 {
	cnt := (*uint32)(unsafe.Add(c.monitorPtr, uintptr(CameraFrameCount)))
	return *cnt
}

func (c *CameraMonitor) LineCount() uint32 {
	cnt := (*uint32)(unsafe.Add(c.monitorPtr, uintptr(CameraLineCount)))
	return *cnt
}

func (c *CameraMonitor) LinePixelCount() uint32 {
	cnt := (*uint32)(unsafe.Add(c.monitorPtr, uintptr(CameraLinePixelCount)))
	return *cnt
}

func (c *CameraMonitor) PixelCount() uint32 {
	cnt := (*uint32)(unsafe.Add(c.monitorPtr, uintptr(CameraPixelCount)))
	return *cnt
}

func (c *CameraMonitor) GetIntCount() uint32 {
	return c.getRegVal(CameraIntCount)
}

func (c *CameraMonitor) GetIntPerSecond() uint32 {
	return c.getRegVal(CameraIntPerS)
}

func (c *CameraMonitor) ErrorCount() uint32 {
	return c.getRegVal(CameraErrorCount)
}

func (m *CameraMonitor) SetGPIO(val uint8) {
	camCtrl := (*uint32)(unsafe.Add(m.monitorPtr, uintptr(CameraCtrlReg)))
	if val&0x1 == 1 {
		*camCtrl |= GPIOBit
	} else {
		*camCtrl &= ^uint32(GPIOBit)
	}
	m.gpio = int(val & 0x1)
}

func (m *CameraMonitor) Disable() {
	camEn := (*uint32)(unsafe.Add(m.monitorPtr, uintptr(CameraCtrlReg)))
	*camEn &= ^(uint32(EnableBit))
	m.enabled = false
}

func (m *CameraMonitor) Enable() {
	camEn := (*uint32)(unsafe.Add(m.monitorPtr, uintptr(CameraCtrlReg)))
	*camEn |= EnableBit
	m.enabled = true
}

func (c *CameraMonitor) Close() error {
	c.SetGPIO(0)
	c.Disable()
	return syscall.Munmap(c.monitorMmap)
}
