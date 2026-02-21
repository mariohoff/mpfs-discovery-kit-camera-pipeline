package camera

const (
	CameraMonitorAPB  = 0x4000_0000
	CameraMonitorSize = 0x1000 // 4k

	CameraCtrlReg        = 0x04
	CameraFrameCount     = 0x08
	CameraLineCount      = 0x0c
	CameraLinePixelCount = 0x10
	CameraPixelCount     = 0x14
	CameraFPS            = 0x18
	CameraErrorCount     = 0x1c
	// 0x1c
	CameraReset          = 0x20
	CameraBayerFormatReg = 0x30

	CameraIntCount = 0x60
	CameraIntPerS  = 0x64
	//
	CameraHresIn  = 0x40
	CameraVresIn  = 0x44
	CameraHresOut = 0x48
	CameraVresOut = 0x4c
	CameraHfact   = 0x50
	CameraVfact   = 0x54

	EnableBit = (1 << 0)
	GPIOBit   = (1 << 1)

	BayerRGGB = 0x0
	BayerGRBG = 0x1
	BayerGBRG = 0x2
	BayerBGGR = 0x3
)
