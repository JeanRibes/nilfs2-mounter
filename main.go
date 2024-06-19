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
		checkpoint := os.Args[2]
		device := os.Args[3]
		path := os.Args[4]

		cp, err := strconv.ParseInt(checkpoint, 10, 64)
		if err != nil {
			log.Fatal(err)
		}

		//if err := mount.Mount(device, path, "nilfs2", fmt.Sprintf("noatime,discard,ro,cp=%d", cp)); err != nil {
		if err := unix.Mount(device, path, "nilfs2", unix.MS_RDONLY|unix.MS_NOATIME, fmt.Sprintf("discard,cp=%d", cp)); err != nil {
			log.Fatal(err)
		}
	} else {

		path := os.Args[2]
		unix.Unmount(path, unix.MNT_DETACH)
	}
}
