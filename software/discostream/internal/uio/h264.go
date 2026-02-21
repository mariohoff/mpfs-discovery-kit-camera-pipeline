package uio

import (
	"fmt"
	"unsafe"
)

const (
	h264VersionReg = 0x00
	h264CtrlReg    = 0x04
	h264TypeReg    = 0x08
	h264QfactReg   = 0x0c
	h264YuvFormat  = 0x10
	h264PCntReg    = 0x14
	h264HresReg    = 0x18
	h264VresReg    = 0x1c
	h264IforceReg  = 0x24
	h264LineGapReg = 0x28
)

type H264Device struct {
	QFact uint32
	HRes  uint32
	VRes  uint32
	Dev   *UioDevice
}

func NewH264Device(hres, vres, qfact uint32) (*H264Device, error) {
	dev, err := NewUIODevice(H264UioID)
	if err != nil {
		return nil, fmt.Errorf("error creating H264 device. Is the UIO device present? err: %w", err)
	}

	hdev := &H264Device{
		QFact: qfact,
		HRes:  hres,
		VRes:  vres,
		Dev:   dev,
	}

	return hdev, nil
}

func (h *H264Device) getRegVal(regOffset uint32) uint32 {
	regPtr := (*uint32)(unsafe.Add(h.Dev.DevicePtr, uintptr(regOffset)))
	return *regPtr
}

func (h *H264Device) setRegVal(regOffset, val uint32) {
	regPtr := (*uint32)(unsafe.Add(h.Dev.DevicePtr, uintptr(regOffset)))
	*regPtr = val
}

func (h *H264Device) Reset() {
	h.setRegVal(h264CtrlReg, 0x02)
}

func (h *H264Device) GetVersion() uint32 {
	return h.getRegVal(h264VersionReg)
}

func (h *H264Device) SetCtrlReg(val uint32) {
	h.setRegVal(h264CtrlReg, val&0x03)
}

func (h *H264Device) GetCtrlReg() uint32 {
	return h.getRegVal(h264CtrlReg)
}

func (h *H264Device) GetIPType() uint32 {
	return h.getRegVal(h264TypeReg)
}

func (h *H264Device) SetQFactor(val uint32) {
	h.QFact = val
	h.setRegVal(h264QfactReg, val)
}

func (h *H264Device) GetQFactor() uint32 {
	return h.getRegVal(h264QfactReg)
}

func (h *H264Device) GetFormat() uint32 {
	return h.getRegVal(h264YuvFormat)
}

func (h *H264Device) SetPFrameCount(val uint32) {
	h.setRegVal(h264PCntReg, val)
}

func (h *H264Device) GetPFrameCount() uint32 {
	return h.getRegVal(h264PCntReg)
}

func (h *H264Device) SetHres(val uint32) {
	h.HRes = val
	h.setRegVal(h264HresReg, val)
}

func (h *H264Device) SetVres(val uint32) {
	h.VRes = val
	h.setRegVal(h264VresReg, val)
}

func (h *H264Device) ForceIFrame() {
	h.setRegVal(h264IforceReg, 1)
}

func (h *H264Device) SetLineGap(val uint32) {
	h.setRegVal(h264LineGapReg, val)
}

func (h *H264Device) Close() error {
	if h.Dev != nil {
		h.Reset()
	}
	return h.Dev.Close()
}
