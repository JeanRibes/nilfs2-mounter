all: clean nmount
	sudo chown root:jean nmount
	sudo chmod 6750 nmount

nmount: main.go
	go build main.go
	mv main nmount

clean:
	rm -f main nmount nilfs-mounter
