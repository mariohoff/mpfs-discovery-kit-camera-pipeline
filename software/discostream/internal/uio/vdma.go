package uio

import (
	"context"
	"encoding/binary"
	"fmt"
	"log/slog"
	"syscall"
	"unsafe"
)

type VDMADevice struct {
	DestAddr  uint32
	IntEnable bool
	IntMask   uint8
	Dev       *UioDevice
}

const (
	vDMAResetBit     = (1 << 1)
	vDMAFifoFlushBit = (1 << 2)

	vDMAVersionReg   = 0x00
	vDMACtrlReg      = 0x04
	vDMAGlblIntReg   = 0x08
	vDMAIntStatusReg = 0x0c
	vDMAIntMaskReg   = 0x10
	vDMAFrameAddrReg = 0x1c
	vDMAFrameSizeReg = 0x24
)

func NewVDMADevice(destAddr uint32) (*VDMADevice, error) {
	dev, err := NewUIODevice(VDmaUioID)
	if err != nil {
		return nil, fmt.Errorf("error creating vDMA device. Is the UIO device present? err: %w", err)
	}

	vdev := &VDMADevice{
		DestAddr:  destAddr,
		IntEnable: false,
		IntMask:   0,
		Dev:       dev,
	}
	return vdev, nil
}

func (v *VDMADevice) getRegVal(regOffset uint32) uint32 {
	regPtr := (*uint32)(unsafe.Add(v.Dev.DevicePtr, uintptr(regOffset)))
	return *regPtr
}

func (v *VDMADevice) setRegVal(regOffset, val uint32) {
	regPtr := (*uint32)(unsafe.Add(v.Dev.DevicePtr, uintptr(regOffset)))
	*regPtr = val
}

func (v *VDMADevice) ClearInterrupt() {
	var enable uint32 = 1
	buf := make([]byte, 4)
	binary.Encode(buf, binary.LittleEndian, enable)
	syscall.Write(v.Dev.fd, buf)
}

/*
WaitForInterrupt - wait for uio interrupt and return interrupt count
*/
func (v *VDMADevice) WaitForInterrupt() (int, error) {
	irqCount := make([]byte, 4)
	n, err := syscall.Read(v.Dev.fd, irqCount)
	if err != nil {
		return -1, err
	}
	if n != 4 {
		return -2, fmt.Errorf("expected 4 bytes, but read %d", n)
	}

	cnt := binary.LittleEndian.Uint32(irqCount)

	return int(cnt), nil
}

func (v *VDMADevice) InterruptChan(ctx context.Context) <-chan int {
	out := make(chan int)

	go func() {
		defer close(out)
		irqCount := make([]byte, 4)

		for {
			// Check if context is cancelled before blocking on Read
			select {
			case <-ctx.Done():
				slog.Info("irq chan done received")
				return
			default:
				// syscall.Read blocks until the UIO interrupt triggers
				n, err := syscall.Read(v.Dev.fd, irqCount)
				if err != nil {
					slog.Error("irq read error: ", "err", err)
					return
				}
				if n == 4 {
					cnt := binary.LittleEndian.Uint32(irqCount)
					out <- int(cnt)
				}
			}
		}
	}()

	return out
}

func (v *VDMADevice) Reset() {
	v.setRegVal(vDMACtrlReg, vDMAResetBit)
}

func (v *VDMADevice) FlushFifo() {
	v.setRegVal(vDMACtrlReg, vDMAFifoFlushBit)
}

func (v *VDMADevice) GetVersion() uint32 {
	return v.getRegVal(vDMAVersionReg)
}

func (v *VDMADevice) SetCtrlReg(val uint32) {
	v.setRegVal(vDMACtrlReg, val)
}

func (v *VDMADevice) GetCtrlReg() uint32 {
	return v.getRegVal(vDMACtrlReg)
}

func (v *VDMADevice) SetGlblIntEnable(val uint32) {
	v.IntEnable = bool(val&0x1 == 1)
	v.setRegVal(vDMAGlblIntReg, val)
}

func (v *VDMADevice) GetGlblIntEnable() uint32 {
	return v.getRegVal(vDMAGlblIntReg)
}

func (v *VDMADevice) ClearIntStatus(val uint32) {
	v.IntMask = uint8(val & 0x1f)
	v.setRegVal(vDMAIntStatusReg, val)
}

func (v *VDMADevice) GetIntStatus() uint32 {
	return v.getRegVal(vDMAIntStatusReg)
}

func (v *VDMADevice) SetIntMask(val uint32) {
	v.IntMask = uint8(val & 0x1f)
	v.setRegVal(vDMAIntMaskReg, val)
}

func (v *VDMADevice) GetIntMask() uint32 {
	return v.getRegVal(vDMAIntMaskReg)
}

/*
SetDestAddr sets the destination address for the FIFO buffer.

Supports up to 38 bit addresses. Destination address gets shifted by 6 to
fit into the 32 bit register. Therefore the lower 6 bits are always zero
video_dma_ip_ug.pdf (DS50003651B, p.14)
*/
func (v *VDMADevice) SetDestAddr(addr uint64) {
	v.DestAddr = uint32(addr >> 6)
	v.setRegVal(vDMAFrameAddrReg, v.DestAddr)
}

func (v *VDMADevice) GetFrameSize() uint32 {
	return v.getRegVal(vDMAFrameSizeReg)
}

func (v *VDMADevice) Close() error {
	if v.Dev != nil {
		v.Reset()
	}
	return v.Dev.Close()
}
