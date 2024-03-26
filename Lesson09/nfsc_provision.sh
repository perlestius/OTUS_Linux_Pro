#устанавливаем утилиты nfs
yum install -y nfs-utils
#включаем firewall
systemctl enable firewalld --now
#добавляем информацию о монтировании папки в /etc/fstab
echo "192.168.50.10:/srv/share/ /mnt nfs vers=3,proto=udp,noauto,x-systemd.automount 0 0" >> /etc/fstab
#перезапускаем службы для применения изменений
systemctl daemon-reload
systemctl restart remote-fs.target
#mount | grep mnt

