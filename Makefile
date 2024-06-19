all: mount umount
	sudo chown root:jean mount umount
	sudo chmod 6750 mount umount

main: main.go
	go build main.go
mount: main
	cp main mount	
umount: main
	mv main umount

clean:
	rm -f mount umount main
