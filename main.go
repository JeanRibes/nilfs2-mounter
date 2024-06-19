package main

import (
	"fmt"
	"log"
	"os"
	"strconv"

	//"golang.org/x/sys/unix"
	unix "syscall"
)

func main() {
	/*if err := syscall.Setuid(0); err != nil {
		log.Fatal(err)
	}*/
	if os.Args[1] == "mount" {
		device := os.Args[2]
		path := os.Args[3]
		if len(os.Args) == 5 {

			checkpoint := os.Args[4]

			cp, err := strconv.ParseInt(checkpoint, 10, 64)
			if err != nil {
				log.Fatal(err)
			}
			if err := unix.Mount(device, path, "nilfs2", unix.MS_RDONLY|unix.MS_NOATIME, fmt.Sprintf("discard,cp=%d", cp)); err != nil {
				log.Fatal(err)
			}
		} else {
			if err := unix.Mount(device, path, "nilfs2", unix.MS_NOATIME, "discard"); err != nil {
				log.Fatal(err)
			}
		}

	} else {

		path := os.Args[2]
		var err error = nil
		for err == nil {
			err = unix.Unmount(path, unix.MNT_DETACH)
		}
	}
}
