## Install Using Root

To install the newest versions of sudo (optional depending on which script you use), curl, Docker, and docker compose, simply ssh into your server, then clone this repository with: 

```
git clone https://github.com/crcorreia/MYLINUXINSTAL.git
```
If you don't have git installed, you can run:
```
apt install git
```

Change into the new directory:
```
cd MYLINUXINSTAL
```

Make the file executable:
```
chmod +x fullinstall.sh
```

Execute the file:
```
./fullinstall.sh
```


The Bash Script Explained
===

This shell script appears to automate the installation of Docker , Docker Compose and a series of containers that serve as the basis for my home laboratory  on a Linux system. 
Here's a breakdown of what each section of the script does:
1. Run system updates:

```
apt-get update
apt-get upgrade -y
apt autoremove -y

```
2. Install curl & sudo
```
apt-get install -y curl
apt-get install -y sudo

```

3. Install Docker
```
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

```
- Downloads the Docker installation script using curl.
- Executes the Docker installation script using sudo sh.

4. Install Docker Compose:
```
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo docker-compose -v

```

- Retrieves the latest Docker Compose version from GitHub API.
- Downloads Docker Compose binary using ```curl``` and installs it in ```/usr/local/bin/```.
- Sets executable permissions for Docker Compose.
- Downloads Bash completion script for Docker Compose.
- Prints a success message.
- Displays the installed Docker Compose version.

5. Install Portainer
```
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9443:9443 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

```
7. Install Coral TPU
```
sudo apt install python3-pip
pip install wheel && pip install --force-reinstall https://github.com/leigh-johnson/Tensorflow-bin/releases/download/v2.2.0/tensorflow-2.2.0-cp37-cp37m-linux_armv7l.whl
echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | sudo tee /etc/apt/sources.list.d/coral-edgetpu.list
sudo curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get install libedgetpu1-std
```
8. create file structure for docker & copy files
```
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

    cp [/MYLINUXINSTAL/ComposeFiles/NetWork/docker-compose.yml] [/opt/DockerCompose/Network/]
    cp [/MYLINUXINSTAL/ComposeFiles/Tools/docker-compose.yml] [/opt/DockerCompose/Tools/]
    cp [/MYLINUXINSTAL/ComposeFiles/SmartHome/docker-compose.yml] [/opt/DockerCompose/SmartHome/]
```
9. Create containers
```
    cd /opt/DockerCompose/Network
    sudo docker compose pull
    sudo docker compose up -d
    sudo docker image prune -af
    sudo docker volume prune -f
    sleep 5
    cd /opt/DockerCompose/Tools
    sudo docker compose pull
    sudo docker compose up -d
    sudo docker image prune -af
    sudo docker volume prune -f
    sleep 5
    cd /opt/DockerCompose/SmartHome
    sudo docker compose pull
    sudo docker compose up -d
    sudo docker image prune -af
    sudo docker volume prune -f
    sleep 5
```
10. Ask if the user wants to create a new sudo user
    
Please note that this script assumes a Debian-based Linux distribution. If you are using a different distribution, adjustments may be needed. Additionally, it's essential to review and understand scripts before executing them, especially when using sudo commands from the internet.
