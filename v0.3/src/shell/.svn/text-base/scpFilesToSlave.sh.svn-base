#!/bin/bash

# [Check root]
if [ $USER != "root" ]; then
    echo "Please change root to execute it !"
    exit
fi

# [Variables Setup]
# ex. slave_root_password='crawlzilla'
# ex. slave_ips='192.168.0.1  192.168.0.2  192.168.0.3'
slave_root_password=''
slave_ips=''

if [ -z "$slave_root_password" ]; then
    echo "Please setup [slave_root_password] in '$0'"
    exit 2
fi

if [ -z "$slave_ips" ]; then
    echo "Please setup [slave_ips] in '$0'"
    exit 2
fi

# [Main]
# generate root ssh key
ssh-keygen -t rsa -f ~/.ssh/id_rsa -P ""
if [ -f "~/.ssh/authorized_keys" ]; then
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
else
    cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys
fi

# copy to slaves
for ip in $slave_ips
do
    expect -c "spawn scp -o StrictHostKeyChecking=no -r /root/.ssh root@${ip}:~
    set timeout 1
    expect \"*:\"
    send "$slave_root_password\r"
    expect eof"
done

# 
for node in $slave_ips;
  do
    scp /home/crawler/crawlzilla/source/slave_deploy.sh /root
  done

