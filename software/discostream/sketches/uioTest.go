package main

import (
	"fmt"

	"discostream/internal/uio"
)

const (
	vdmaUioID = "vdma-controller@60020000"
	h264UioID = "h264-encoder@60000000"
)

func main() {
	vdmaDev, err := uio.NewUIODevice(vdmaUioID)
	defer vdmaDev.Close()
	if err != nil {
		panic(err)
	}
	fmt.Printf("vDMA device opened. Name: '%s', Size: '0x%08x'\n", vdmaDev.Name, vdmaDev.Size)

	h264Dev, err := uio.NewUIODevice(h264UioID)
	defer h264Dev.Close()
	if err != nil {
		panic(err)
	}
	fmt.Printf("h264 device opened. Name: '%s', Size: '0x%08x'\n", h264Dev.Name, h264Dev.Size)
}
