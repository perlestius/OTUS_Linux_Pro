#!/bin/bash

#Обнуляем суперблоки (на случай, если какие-то диски уже были в массивах)
mdadm --zero-superblock --force /dev/sd{b,c,d,e,f}

#Создаём новый RAID-массив
mdadm --create --verbose /dev/md0 -l 6 -n 5 /dev/sd{b,c,d,e,f}

#Сохраняем конфигурацию на постоянной основе в ОС
mkdir /etc/mdadm
echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
