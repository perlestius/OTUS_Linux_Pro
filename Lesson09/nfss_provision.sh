#устанавливаем утилиты nfs
yum install -y nfs-utils
#включаем firewall
systemctl enable firewalld --now
#разрешаем в firewall доступ к сервисам NFS
firewall-cmd --add-service="nfs3" --add-service="rpc-bind" --add-service="mountd" --permanent 
firewall-cmd --reload
#включаем nfs на сервере
systemctl enable nfs --now
#проверяем порты
#ss -tnplu
#создаем папку для обмена и настраиваем для нее права
mkdir -p /srv/share/upload
chown -R nfsnobody:nfsnobody /srv/share
chmod 0777 /srv/share/upload
#добавляем в файл /etc/exports запись, которая позволит экспортировать ранее созданную директорию на nfs-клиента
echo "/srv/share 192.168.50.11/32(rw,sync,root_squash)" >> /etc/exports
#экспортируем ранее созданную директорию
exportfs -r
#проверяем состояние экспорта
exportfs -s

