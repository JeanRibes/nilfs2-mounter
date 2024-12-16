all: setup clean nilfs2-mounter install

setup:
	sudo chmod u+s /usr/bin/mkcp
nilfs2-mounter: main.go
	go build
install: nilfs2-mounter
	sudo mv nilfs2-mounter /usr/bin/nilfs2-mounter
	sudo setcap cap_sys_admin=ep /usr/bin/nilfs2-mounter
	sudo cp nilfs2.sh /usr/bin/nilfs2.sh
	chmod 755 .applications/*.desktop
	sudo cp .applications/*.desktop /usr/share/applications
clean:
	rm -f main nilfs2-mounter
	rm -fr nilfs2-mounter-1.0

uninstall:
	rm /usr/bin/nilfs2-mounter
	rm /usr/bin/nilfs2.sh
	rm /usr/share/applications/create-snapshot.desktop
	rm /usr/share/applications/mount-snapshot.desktop
	rm /usr/share/applications/unmount-snapshots.desktop
tar:
	git archive --output=${HOME}/rpmbuild/SOURCES/nilfs2-mounter-1.0.tar.gz --prefix=nilfs2-mounter-1.0/ HEAD
rpm: tar
	rpmbuild -bb nilfs2-mounter.spec
