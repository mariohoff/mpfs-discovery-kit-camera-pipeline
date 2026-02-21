package main

import (
	"fmt"
	"log"

	"discostream/internal/camera"
	"discostream/internal/camera/ov5647"
	"discostream/internal/uio"
	"discostream/internal/view"
)

const (
	OV5647I2CAddress = 0x36
	I2CBusNumber     = 0

	VDMADestAddr = 0xc800_0000
	H264HRes     = 640
	H264Vres     = 480
	H264Qfact    = 10
)

func main() {
	log.Println("Hello, World!")

	vdmaDev, err := uio.NewVDMADevice(VDMADestAddr)
	defer func() {
		err := vdmaDev.Close()
		if err != nil {
			panic(err)
		}
	}()
	if err != nil {
		panic(err)
	}
	fmt.Printf("vDMA device opened. Name: '%s', Size: '0x%08x'\n", vdmaDev.Dev.Name, vdmaDev.Dev.Size)

	h264Dev, err := uio.NewH264Device(H264HRes, H264Vres, H264Qfact)
	defer func() {
		err := h264Dev.Close()
		if err != nil {
			panic(err)
		}
	}()
	if err != nil {
		panic(err)
	}
	fmt.Printf("h264 device opened. Name: '%s', Size: '0x%08x'\n", h264Dev.Dev.Name, h264Dev.Dev.Size)

	cam := ov5647.New(OV5647I2CAddress, I2CBusNumber)
	defer cam.Close()

	mon, err := camera.New()
	if err != nil {
		panic(err)
	}
	defer mon.Close()

	server := view.NewServer(mon, cam, vdmaDev, h264Dev)

	server.Router.Run(":8080")
}
