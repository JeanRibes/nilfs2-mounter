all: setup clean nilfs-mounter install

setup:
	sudo chmod u+s /usr/bin/mkcp
nilfs-mounter: main.go
	go build
install: nilfs-mounter
	sudo mv nilfs-mounter /usr/local/bin/nilfs-mounter
	sudo setcap cap_sys_admin=ep /usr/local/bin/nilfs-mounter
	sudo cp nilfs.sh /usr/local/bin/nilfs.sh
	sudo cp .applications/* /usr/local/share/applications
clean:
	rm -f main nilfs-mounter

uninstall:
	rm /usr/local/bin/nilfs-mounter
	rm /usr/local/bin/nilfs.sh
	rm /usr/local/share/applications/create-snapshot.desktop
	rm /usr/local/share/applications/mount-snapshot.desktop
	rm /usr/local/share/applications/unmount-snapshots.desktop
