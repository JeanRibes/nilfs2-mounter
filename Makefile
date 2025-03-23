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
	git clean -fX .
uninstall:
	rm /usr/bin/nilfs2-mounter
	rm /usr/bin/nilfs2.sh
	rm /usr/share/applications/create-snapshot.desktop
	rm /usr/share/applications/mount-snapshot.desktop
	rm /usr/share/applications/unmount-snapshots.desktop

rpm:
	rpmdev-setuptree
	git archive --output=./nilfs2-mounter-`git rev-parse HEAD`.tar.gz --prefix=nilfs2-mounter-`git rev-parse HEAD`/ HEAD
	mv nilfs2-mounter-`git rev-parse HEAD`.tar.gz ~/rpmbuild/SOURCES
	rpmbuild -ba main.spec
	@echo ========================
	@echo check ~/rpmbuild/RPMS
	@echo
	ls ~/rpmbuild/RPMS/*
	ln -s ~/rpmbuild/RPMS/x86_64/nilfs2-mounter-`git describe --tags --exact-match --dirty|grep -v dirty|grep v||git rev-parse HEAD`-`git rev-parse --short HEAD`.x86_64.rpm .

dev-fedora:
	rpmdev-setuptree
	git archive --output=./nilfs2-mounter-`git rev-parse HEAD`.tar.gz --prefix=nilfs2-mounter-`git rev-parse HEAD`/ HEAD
	fedpkg local
	sudo dnf install --allow-downgrade ./x86_64/nilfs2-mounter-`git rev-parse HEAD`-`git rev-parse --short HEAD`.x86_64.rpm
