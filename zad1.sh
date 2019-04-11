#!/bin/bash

data=$(date +%d%m%y'_'%H%M)
mkdir -p Inw$data
cd Inw$data

cut -d: -f1 /etc/passwd > users
cut -d: -f1 /etc/group | sort > group
sudo iptables -L -v -t mangle > firewall
sudo netstat -ltp --numeric-ports > services
ps -aux | less > processes
