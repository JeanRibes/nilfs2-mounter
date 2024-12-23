package main

import (
	"fmt"
	"log"
	"os"
	"strconv"
	"syscall"
)

func main() {
	if os.Args[1] == "snapshot" {
		dev := os.Args[2]
		n, err := OpenNilfs(dev, NILFS_OPEN_RDWR|NILFS_OPEN_GCLK)
		if err != nil {
			log.Fatal(err)
		}
		cno, err := n.Sync()
		if err != nil {
			log.Fatal(err)
		}
		if err := n.ChangeCpmode(cno, SNAPSHOT); err != nil {
			log.Fatal(err)
		}
		n.Close()
		return
	}

	if os.Args[1] == "mount" {
		device := os.Args[2]
		path := os.Args[3]
		if len(os.Args) == 5 {

			checkpoint := os.Args[4]

			cp, err := strconv.ParseInt(checkpoint, 10, 64)
			if err != nil {
				log.Fatal(err)
			}
			if err := syscall.Mount(device, path, "nilfs2", syscall.MS_RDONLY|syscall.MS_NOATIME|syscall.MS_ASYNC, fmt.Sprintf("discard,cp=%d", cp)); err != nil {
				log.Fatal(err)
			}
		} else {
			if err := syscall.Mount(device, path, "nilfs2", syscall.MS_NOATIME|syscall.MS_ASYNC, "discard"); err != nil {
				log.Fatal(err)
			}
		}
		return
	}

	if os.Args[1] == "umount" {
		for _, path := range os.Args[2:] {
			log.Println("unmount", path)
			if err := syscall.Unmount(path, syscall.MNT_DETACH); err != nil {
				log.Print(err)
			}
		}
		return
	}
	fmt.Println("Error: no action")
	fmt.Println(`Usage:
 nilfs2-mounter snapshot
 nilfs2-mounter mount <device> <path> <checkpoint>
 nilfs2-mounter umount <path1> [path2 ...]
 `)
	os.Exit(2)
}
