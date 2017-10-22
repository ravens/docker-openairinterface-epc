# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/zesty64"

  config.vm.hostname = "virtualepc.research"


  config.vm.provision "shell", inline: <<-SHELL
	apt-get -qy update
	apt-get -qy install docker.io docker-compose
	apt-get -qy install linux-image-generic 
	adduser ubuntu docker
	cp -r /vagrant/* /root
	cd /root
	docker-compose build
	echo "You need to reboot this VM to have GTP module availability, before calling docker-compose up"
   SHELL

end
