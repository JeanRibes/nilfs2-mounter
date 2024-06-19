package main

import (
	"fmt"
	"io"
	"log"
	"os"
	"os/exec"
	"syscall"
)

func main() {
	fmt.Printf("%#v\n", os.Args[1:])
	fmt.Println("umount")

	path := os.Args[1]

	if err := syscall.Setuid(0); err != nil {
		log.Fatal(err)
	}

	cmd := exec.Command("umount", "-t", "nilfs2", path)
	out, _ := cmd.StdoutPipe()
	oerr, _ := cmd.StderrPipe()
	go io.Copy(os.Stdout, out)
	go io.Copy(os.Stdout, oerr)
	if err := cmd.Run(); err != nil {
		log.Fatal(err)
	}
}
