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
	fmt.Printf("%#v\n", os.Args)

	var cmd *exec.Cmd
	if os.Args[1] == "mount" {
		checkpoint := os.Args[2]
		device := os.Args[3]
		path := os.Args[4]

		cp, err := strconv.ParseInt(checkpoint, 10, 64)
		if err != nil {
			log.Fatal(err)
		}
		if err := syscall.Setuid(0); err != nil {
			log.Fatal(err)
		}

		cmd = exec.Command("mount", "-t", "nilfs2", "-o", fmt.Sprintf("noatime,users,discard,nogc,ro,cp=%d", cp), device, path)
	} else {

		path := os.Args[2]
		cmd = exec.Command("umount", "-t", "nilfs2", path)
	}
	out, _ := cmd.StdoutPipe()
	oerr, _ := cmd.StderrPipe()
	go io.Copy(os.Stdout, out)
	go io.Copy(os.Stdout, oerr)
	if err := cmd.Run(); err != nil {
		log.Fatal(err)
	}
}
