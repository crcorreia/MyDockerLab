## Install Using Root

To install the newest versions of sudo (optional depending on which script you use), curl, Docker, and docker compose, simply ssh into your server, then clone this repository with: 

```
git clone https://github.com/crcorreia/MyDockerLab.git
```
If you don't have git installed, you can run:
```
apt install git
```

Change into the new directory:
```
cd MyDockerLab

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
2. Install curl
```
apt-get install -y curl
```

3. Install Docker & Docker Compose
```
sudo apt install docker.io docker-compose docker-doc
sudo systemctl enable --now docker

```
- Downloads the Docker installation script using curl.
- Executes the Docker installation script using sudo sh.

4. Add user to docker print compose version
```
sudo /sbin/usermod -aG docker $username  --> logout --> groups
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

    cp /ComposeFiles/NetWork/docker-compose.yml /opt/DockerCompose/Network/
    cp /ComposeFiles/Tools/docker-compose.yml /opt/DockerCompose/Tools/
    cp /ComposeFiles/SmartHome/docker-compose.yml /opt/DockerCompose/SmartHome/
```
9. Create containers
```
    cd /opt/DockerCompose/Network
    docker-compose pull
    docker-compose up -d
    docker image prune -af
    docker volume prune -f
 
    cd /opt/DockerCompose/Tools
    docker-compose pull
    docker-compose up -d
    docker image prune -af
    docker volume prune -f

    cd /opt/DockerCompose/SmartHome
    docker-compose pull
    docker-compose up -d
    docker image prune -af
    docker volume prune -f
 
```
10. Ask if the user wants to create a new sudo user
    
Please note that this script assumes a Debian-based Linux distribution. If you are using a different distribution, adjustments may be needed. Additionally, it's essential to review and understand scripts before executing them, especially when using sudo commands from the internet.
