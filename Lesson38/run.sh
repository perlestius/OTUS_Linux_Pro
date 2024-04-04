#!/bin/bash
echo "Создаем ВМ..."
vagrant up
echo "Настраиваем IPA-клиенты через ansible..."
cd ./ansible
ansible-playbook host_provision.yml
cd ..
echo "Веб-интерфейс FreeIPA: https://ipa.otus.lan/ipa/ui/"
echo "Пароль для веб-интерфейса: 12345678"
echo "Для доступа к веб-интерфейсу добавьте в файл /etc/hosts своей машины эту строку:"
echo "192.168.57.10	ipa.otus.lan"
echo
echo "Проверяем подключение к первому IPA-клиенту"
echo "Начальный пароль 123, его надо сменить на новый"
ssh 192.168.57.11 -l ipauser@OTUS.LAN
echo "Проверяем подключение к второму IPA-клиенту под тем же пользователем"
ssh 192.168.57.12 -l ipauser@OTUS.LAN

