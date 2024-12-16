all: setup clean nilfs2-mounter install

setup:
	sudo chmod u+s /usr/bin/mkcp
nilfs2-mounter: main.go
	go build
install: nilfs2-mounter
	sudo mv nilfs2-mounter /usr/local/bin/nilfs2-mounter
	sudo setcap cap_sys_admin=ep /usr/local/bin/nilfs2-mounter
	sudo cp nilfs2.sh /usr/local/bin/nilfs2.sh
	sudo cp .applications/* /usr/local/share/applications
clean:
	rm -f main nilfs2-mounter

uninstall:
	rm /usr/local/bin/nilfs2-mounter
	rm /usr/local/bin/nilfs2.sh
	rm /usr/local/share/applications/create-snapshot.desktop
	rm /usr/local/share/applications/mount-snapshot.desktop
	rm /usr/local/share/applications/unmount-snapshots.desktop
