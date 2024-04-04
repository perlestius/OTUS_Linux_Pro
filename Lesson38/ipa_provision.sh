#Задаем часовой пояс
timedatectl set-timezone Europe/Moscow

#Устанавливаем crony
yum install -y chrony
#добавляем его в автозагрузку и запускаем
systemctl enable chronyd —now

#Останавливаем и выключаем файервол
systemctl stop firewalld
systemctl disable firewalld

#Останавливаем и отключаем Selinux
setenforce 0
sed -i 's/^SELINUX *=.*/SELINUX=disabled/g' /etc/selinux/config

#Добавляем DNS-запись для сервера
echo "192.168.57.10 ipa.otus.lan ipa" >> /etc/hosts

#Установим модуль DL1
yum install -y @idm:DL1

#Включаем IPv6 на loopback-интерфейсе (иначе получим ошибку "IPv6 stack is enabled in the kernel but there is no interface that has ::1 address assigned")
echo "net.ipv6.conf.lo.disable_ipv6 = 0" >> /etc/sysctl.conf
sysctl -p /etc/sysctl.d/99-sysctl.conf

#Устанавливаем и разворачиваем сервер FreeIPA с заданными параметрами
yum install -y ipa-server
ipa-server-install --unattended --hostname=ipa.otus.lan --domain=otus.lan --realm=OTUS.LAN --ds-password=12345678 --admin-password=12345678 --netbios-name=OTUS --no-ntp

#Добавляем пользователя в IPA
echo 12345678 | kinit admin
echo 123 | ipa user-add ipauser --first=John --last=Smith --password

