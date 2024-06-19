package main

import (
	"fmt"
	"io"
	"log"
	"os"
	"os/exec"
	"strconv"
	"syscall"
)

func main() {
	fmt.Printf("%#v\n", os.Args[1:])
	fmt.Println("vim-go")

	checkpoint := os.Args[1]
	device := os.Args[2]
	path := os.Args[3]

	cp, err := strconv.ParseInt(checkpoint, 10, 64)
	if err != nil {
		log.Fatal(err)
	}
	if err := syscall.Setuid(0); err != nil {
		log.Fatal(err)
	}

	cmd := exec.Command("mount", "-t", "nilfs2", "-o", fmt.Sprintf("noatime,users,discard,nogc,ro,cp=%d", cp), device, path)
	out, _ := cmd.StdoutPipe()
	oerr, _ := cmd.StderrPipe()
	go io.Copy(os.Stdout, out)
	go io.Copy(os.Stdout, oerr)
	if err := cmd.Run(); err != nil {
		log.Fatal(err)
	}
}
