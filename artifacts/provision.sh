#!/usr/bin/env bash

apt update && apt upgrade -y

tar -xzvf /tmp/gopher.tar.gz -C /var/
apt install pygopherd -y
chown -R gopher:gopher /var/gopher

EIP=$1
echo "Public IP address: $EIP" # AWS elastic IP -- public IP address of the host
sed -i "s/# servername = gopher.example.com/servername = $EIP/" /etc/pygopherd/pygopherd.conf
systemctl restart pygopherd
