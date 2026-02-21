package dma

import (
	"fmt"
	"sync"
	"syscall"
	"unsafe"
)

type DMABuffer struct {
	memFd     int
	mmap      []byte
	MmapPtr   unsafe.Pointer
	framePool *sync.Pool
}

func New(dmaAddr, maxFrameSize int, framePool *sync.Pool) (*DMABuffer, error) {
	fd, err := syscall.Open("/dev/mem", syscall.O_RDWR|syscall.O_SYNC, 0)
	if err != nil {
		return nil, fmt.Errorf("failed to open /dev/mem: %v", err)
	}

	mmap, err := syscall.Mmap(fd, int64(dmaAddr), maxFrameSize, syscall.PROT_READ, syscall.MAP_SHARED)
	if err != nil {
		return nil, fmt.Errorf("failed to mmap DMA buffer: %v", err)
	}

	dmabuf := &DMABuffer{
		memFd:     fd,
		mmap:      mmap,
		MmapPtr:   unsafe.Pointer(&mmap[0]),
		framePool: framePool,
	}
	return dmabuf, nil
}

func (d *DMABuffer) ReadFrame(frameSize int) []byte {
	// old school copy
	// frame := make([]byte, frameSize)
	// copy(frame, d.mmap)

	// use pool instead
	buffer := d.framePool.Get().([]byte)
	frame := buffer[:frameSize]
	copy(frame, d.mmap[:frameSize])

	return frame
}

func (d *DMABuffer) Close() error {
	return syscall.Munmap(d.mmap)
}
