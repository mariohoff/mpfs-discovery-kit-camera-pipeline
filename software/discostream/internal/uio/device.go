package uio

import (
	"fmt"
	"os"
	"strconv"
	"strings"
	"syscall"
	"unsafe"
)

type UioDevice struct {
	Name      string
	Path      string
	Size      int
	fd        int
	mmap      []byte
	DevicePtr unsafe.Pointer
}

var (
	numUioDevices = 32
	sysfsTemplate = "/sys/class/uio/uio%d/%s"
)

func NewUIODevice(idStr string) (*UioDevice, error) {
	idx, err := findDevice(idStr)
	if err != nil {
		return nil, err
	}

	uioDev := fmt.Sprintf("/dev/uio%d", idx)
	path := fmt.Sprintf(sysfsTemplate, idx, "maps/map0/size")
	sz, err := getMemSize(path, uioDev)
	if err != nil {
		return nil, err
	}

	fd, err := syscall.Open(uioDev, syscall.O_RDWR|syscall.O_SYNC, 0)
	if err != nil {
		return nil, fmt.Errorf("failed to open %s: %w", uioDev, err)
	}

	mmap, err := syscall.Mmap(fd, 0, sz, syscall.PROT_READ|syscall.PROT_WRITE, syscall.MAP_SHARED)
	if err != nil {
		return nil, fmt.Errorf("failed to mmap uio device '%s': %w", uioDev, err)
	}

	return &UioDevice{
		Name:      idStr,
		Path:      uioDev,
		Size:      sz,
		fd:        fd,
		mmap:      mmap,
		DevicePtr: unsafe.Pointer(&mmap[0]),
	}, nil
}

func findDevice(name string) (int, error) {
	for i := range numUioDevices {
		sysfsPath := fmt.Sprintf(sysfsTemplate, i, "name")
		buf, err := os.ReadFile(sysfsPath)
		if err != nil {
			return -1, fmt.Errorf("error reading uio name from '%s', err: %w", sysfsPath, err)
		}

		uioName := string(buf)
		uioName = strings.Trim(uioName, " \n\r\t")
		if strings.Compare(uioName, name) == 0 {
			return i, nil
		}
	}

	return -1, fmt.Errorf("UIO device '%s' not found", name)
}

func getMemSize(sysfsPath, uioDevice string) (int, error) {
	buf, err := os.ReadFile(sysfsPath)
	if err != nil {
		return -1, fmt.Errorf("error reading memory size for device '%s', err: %w", uioDevice, err)
	}

	valStr := strings.Trim(string(buf), " \n\r\t")
	val, err := strconv.ParseInt(valStr, 0, 0)
	if err != nil {
		return -1, fmt.Errorf("error converting size '%s' to integer: %w", string(buf), err)
	}

	return int(val), nil
}

func (u *UioDevice) Close() error {
	return syscall.Munmap(u.mmap)
}
