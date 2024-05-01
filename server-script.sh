#! /bin/bash

# sudo yum install java-1.8.0-openjdk-devel -y
sudo yum install git -y
sudo yum install docker -y
sudo systemctl start docker
# sudo yum install maven -y

if [ -d "addressbook" ]
then
   echo "repo is already cloned and exists"
   cd /home/ec2-user/addressbook
   git checkout docker
   git pull origin docker
else
   git clone https://github.com/srinigg/addressbook.git
   cd /home/ec2-user/addressbook
   git checkout docker
fi

# mvn package
sudo docker build -t $1:$2 /home/ec2-user/addressbook
