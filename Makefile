all: clean nmount
#sudo chown root:jean nmount
#sudo chmod 6750 nmount

nmount: main.go
	go build main.go
	mv main ~/.local/bin/nmount
	sudo setcap cap_sys_admin=ep ~/.local/bin/nmount

clean:
	rm -f main nmount nilfs-mounter
