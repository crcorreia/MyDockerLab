#!/bin/bash

# Run system updates
apt-get update
apt-get upgrade -y
apt autoremove -y

# Install curl
apt-get install -y curl

# Ask if the user wants to install Docker and Docker Compose 	Make docker start at boot
read -p "Do you want to install Docker? (y/n) " install_docker
if [[ $install_docker =~ ^[Yy]$ ]]; then
    sudo apt install docker.io docker-compose docker-doc
    sudo systemctl enable --now docker    
fi

# Ask if the user wants to Add user to docker
read -p "Do you want to Add user to docker? (y/n) " install_compose 
if [[ $install_compose =~ ^[Yy]$ ]]; then
	read -p "Enter the desired username: " username
 	if [[ -n "$username" ]]
	then
	   sudo /sbin/usermod -aG docker $username  --> logout --> groups
	fi	  	
	docker-compose -v
fi

# Ask if the user wants to install Portainer
read -p "Do you want to install Portainer? (y/n) " install_portainer
if [[ $install_portainer =~ ^[Yy]$ ]]; then
    docker volume create portainer_data
    docker run -d -p 8000:8000 -p 9443:9443 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
fi

# Ask if the user wants to install Coral TPU
read -p "Do you want to install CoralTPU? (y/n) " install_coraltpu
if [[ $install_coraltpu =~ ^[Yy]$ ]]; then

	read -p "Do you want to install PIP? (y/n) " install_pip
	if [[ $install_pip =~ ^[Yy]$ ]]; then		
		sudo apt install python3-pip
	fi
	
	read -p "Do you want to install wheel? (y/n) " install_wheel
	if [[ $install_wheel =~ ^[Yy]$ ]]; then		
		pip install wheel && pip install --force-reinstall https://github.com/leigh-johnson/Tensorflow-bin/releases/download/v2.2.0/tensorflow-2.2.0-cp37-cp37m-linux_armv7l.whl
	fi
	

	read -p "Do you want to install TPU? (y/n) " install_tpu
	if [[ $install_tpu =~ ^[Yy]$ ]]; then		
		echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | sudo tee /etc/apt/sources.list.d/coral-edgetpu.list
		sudo curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
	fi
	
	read -p "Do you want to install TPU runtime? (y/n) " install_runtime
	if [[ $install_tpu =~ ^[Yy]$ ]]; then		
		sudo apt-get install libedgetpu1-std
	fi

fi

# Ask if the user wants to create file structure for docker
read -p "Do you want to create file structure for docker? (y/n) " create_file_structure
if [[ $create_file_structure =~ ^[Yy]$ ]]; then
    sudo mkdir /opt/appdata
    sudo mkdir /opt/appdata/mosquitto
    sudo mkdir /opt/appdata/zigbee2mqtt
    sudo mkdir /opt/appdata/wireguard
    sudo mkdir /opt/appdata/duplicati
    sudo mkdir /opt/appdata/frigate
    sudo mkdir /home/cesar/frigate
    sudo mkdir /home/cesar/frigate/storage
    sudo mkdir /home/cesar/filebrowser
    sudo mkdir /opt/DockerCompose
    sudo mkdir /opt/DockerCompose/Network
    sudo mkdir /opt/DockerCompose/Tools
    sudo mkdir /opt/DockerCompose/SmartHome

    cp /MyDockerLab/ComposeFiles/NetWork/docker-compose.yml /opt/DockerCompose/Network/
    cp /MyDockerLab/ComposeFiles/Tools/docker-compose.yml /opt/DockerCompose/Tools/
    cp /MyDockerLab/ComposeFiles/SmartHome/docker-compose.yml /opt/DockerCompose/SmartHome/
fi

# Ask if the user wants to create docker containers
read -p "Do you want to create docker containers? (y/n) " create_containers
if [[ $create_containers =~ ^[Yy]$ ]]; then
   read -p "Do you want to run Network Compose? (y/n) " network
   if [[ $network =~ ^[Yy]$ ]]; then
     cd /opt/DockerCompose/Network
     docker-compose pull
     docker-compose up -d
     docker image prune -af
     docker volume prune -f
   fi
   read -p "Do you want to run Tools Compose? (y/n) " Tools
   if [[ $Tools =~ ^[Yy]$ ]]; then
    cd /opt/DockerCompose/Tools
    docker-compose pull
    docker-compose up -d
    docker image prune -af
    docker volume prune -f
   fi
   read -p "Do you want to run SmartHome Compose? (y/n) " SmartHome
   if [[ $SmartHome =~ ^[Yy]$ ]]; then
    cd /opt/DockerCompose/SmartHome
    docker-compose pull
    docker-compose up -d
    docker image prune -af
    docker volume prune -f
   fi
fi

# Ask if the user wants to create a new sudo user
read -p "Do you want to create a new sudo user? (y/n) " create_user
if [[ $create_user =~ ^[Yy]$ ]]; then
    read -p "Enter the desired username: " username
    while true; do
        read -s -p "Enter the password: " password
        echo
        read -s -p "Confirm the password: " password_confirm
        echo
        if [[ $password == $password_confirm ]]; then
            break
        else
            echo "Passwords do not match. Please try again."
        fi
    done
    useradd -m -s /bin/bash $username
    echo "$username:$password" | sudo chpasswd
    usermod -aG sudo,docker $username
    echo "User $username has been created and added to sudo and docker groups."
fi
