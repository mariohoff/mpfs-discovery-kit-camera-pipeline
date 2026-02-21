package ov5647

import (
	"fmt"
	"log"
	"time"

	"discostream/internal/port"

	"github.com/d2r2/go-i2c"
	"github.com/d2r2/go-logger"
)

func New(i2cAddr uint8, i2cBus int) port.Camera {
	cam := &Ov5647Camera{
		I2CAddr: i2cAddr,
		I2CBus:  i2cBus,
	}
	return cam
}

func (c *Ov5647Camera) Init() error {
	logger.ChangePackageLogLevel("i2c", logger.InfoLevel)

	i2c, err := i2c.NewI2C(c.I2CAddr, c.I2CBus)
	if err != nil {
		return fmt.Errorf("error while opening i2c device: %w", err)
	}

	c.i2cDev = i2c

	err = c.Reset()
	if err != nil {
		return fmt.Errorf("error during i2c reset sequence: %w", err)
	}
	time.Sleep(100 * time.Millisecond)
	err = c.InitSequence()
	if err != nil {
		return fmt.Errorf("error during i2c init sequence : %w", err)
	}

	return nil
}

func (c *Ov5647Camera) InitSequence() error {
	for _, cmd := range OV5647InitSequence {
		rh := byte((cmd.Register >> 8) & 0xff)
		rl := byte((cmd.Register >> 0) & 0xff)
		v := byte(cmd.Value)
		_, err := c.i2cDev.WriteBytes([]byte{rh, rl, v})
		if err != nil {
			return fmt.Errorf("error while writing value 0x%02x to register 0x%04x: %w", cmd.Value, cmd.Register, err)
		}
	}
	return nil
}

func (c *Ov5647Camera) Reset() error {
	for _, cmd := range OV5647ResetSequence {
		rh := byte((cmd.Register >> 8) & 0xff)
		rl := byte((cmd.Register >> 0) & 0xff)
		v := byte(cmd.Value)
		_, err := c.i2cDev.WriteBytes([]byte{rh, rl, v})
		if err != nil {
			return fmt.Errorf("error while writing value 0x%02x to register 0x%04x: %w", cmd.Value, cmd.Register, err)
		}
	}
	return nil
}

func (c *Ov5647Camera) DisableNightMode() error {
	nm := OV5647NightModeOff
	rh := byte((nm.Register >> 8) & 0xff)
	rl := byte((nm.Register >> 0) & 0xff)
	v := byte(nm.Value)
	_, err := c.i2cDev.WriteBytes([]byte{rh, rl, v})
	if err != nil {
		return fmt.Errorf("error while writing value 0x%02x to register 0x%04x: %w", nm.Value, nm.Register, err)
	}
	return nil
}

func (c *Ov5647Camera) EnableNightMode() error {
	nm := OV5647NightMode
	rh := byte((nm.Register >> 8) & 0xff)
	rl := byte((nm.Register >> 0) & 0xff)
	v := byte(nm.Value)
	_, err := c.i2cDev.WriteBytes([]byte{rh, rl, v})
	if err != nil {
		return fmt.Errorf("error while writing value 0x%02x to register 0x%04x: %w", nm.Value, nm.Register, err)
	}
	return nil
}

func (c *Ov5647Camera) ReadTestRegisters() error {
	buf := make([]byte, 1)

	for r, d := range OV5647CheckRegs {
		_, err := c.i2cDev.WriteBytes([]byte{byte((r >> 8) & 0xff), byte(r & 0xff)})
		if err != nil {
			return fmt.Errorf("error while writing restiger addres 0x%04x to bus: %w", r, err)
		}
		cnt, err := c.i2cDev.ReadBytes(buf)
		if err != nil {
			return fmt.Errorf("error while reading from i2c bus: %w", err)
		}
		if cnt > 0 {
			log.Printf("0x%02x - %s", buf[0], d)
		} else {
			return fmt.Errorf("read zero bytes for register 0x%04x: %w", r, err)
		}
	}
	return nil
}

func (c *Ov5647Camera) Close() error {
	if c.i2cDev != nil {
		c.Reset()
	}

	return c.i2cDev.Close()
}
