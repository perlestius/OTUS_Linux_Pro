#!/bin/bash

echo "---=== Creating VM... ===---"
vagrant up

echo "---=== Preparing staging/hosts file for ansible... ===---"
echo "[web]" > ./staging/hosts
vagrant ssh-config | grep -E "(Port|IdentityFile)" | tr '\n' ' ' | awk '{sub("  Port ","nginx ansible_host=127.0.0.1 ansible_port=")}1' $1 | awk '{sub("  IdentityFile ","ansible_private_key_file=")}1' $1 >> ./staging/hosts

echo "---=== Configuring VM's NGINX via ansible... ===---"
ansible-playbook nginx.yml

echo "---=== Searching for URL... ===---"
vagrant ssh -c "ip addr" | grep brd | grep inet | tail -n1 | awk '{gsub(/\/.* metric .*/,":8080");}1' | awk '{gsub(/inet /,"NGINX is probably here: http://");}1'
