package main

/*
#cgo CFLAGS: -I/usr/include
#cgo LDFLAGS: -lnilfs

#include <nilfs.h>
*/
import "C"

import (
	"fmt"
	"unsafe"
)

// Define Go types corresponding to C structs from nilfs.h
type Nilfs struct {
	c *C.struct_nilfs
}

type NilfsCno C.nilfs_cno_t

const NILFS_OPEN_RDWR = 0x0008
const NILFS_OPEN_GCLK = 0x1000

const (
	CHECKPOINT = iota
	SNAPSHOT
)

func OpenNilfs(dev string, flags int) (*Nilfs, error) {
	cdev := C.CString(dev)
	defer C.free(unsafe.Pointer(cdev))
	cnilfs := C.nilfs_open(cdev, nil, C.int(flags))
	if cnilfs == nil {
		return nil, fmt.Errorf("nilfs_open failed")
	}
	return &Nilfs{c: cnilfs}, nil
}
func (n *Nilfs) Close() {
	C.nilfs_close(n.c)
}
func (n *Nilfs) Sync() (NilfsCno, error) {
	var cno C.nilfs_cno_t
	ret := C.nilfs_sync(n.c, &cno)
	if ret < 0 {
		return 0, fmt.Errorf("nilf_sync failed")
	}
	return NilfsCno(cno), nil
}
func (n *Nilfs) ChangeCpmode(cno NilfsCno, mode int) error {
	ret := C.nilfs_change_cpmode(n.c, C.nilfs_cno_t(cno), C.int(mode))
	if ret < 0 {
		return fmt.Errorf("nilfs_change_cpmode failed")
	}
	return nil
}
