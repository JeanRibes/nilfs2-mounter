umount: umount.go
	go build umount.go
mount: mount.go
	go build mount.go

all: umount mount
	sudo chown root:jean mount umount
	sudo chmod 6750 mount umount
clean:
	rm mount umount
