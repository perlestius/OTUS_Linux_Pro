<h1>Vagrant-стенд для NFS</h1>
<ul>
 <li>vagrant up должен поднимать 2 виртуалки: сервер и клиент;</li>
 <li>на сервер должна быть расшарена директория;</li>
 <li>на клиента она должна автоматически монтироваться при старте (fstab или autofs);</li>
 <li>в шаре должна быть папка upload с правами на запись;</li>
 <li>требования для NFS: NFSv3 по UDP, включенный firewall.</li>
</ul>

<h2>Особенности решения</h2>
В репозитории находится Vagrant-файл для развертывания двух ВМ: сервера и клиента NFS на CentOS 7. После развертывания на ВМ автоматически запускаются скрипты nfss_provision.sh и nfsc_provision.sh для конфигурирования сервера и клиента соответственно. Для запуска стенда переходим в каталог с файлом Vagrantfile и выполняем команду:
<code>vagrant up</code>
После развертывания обеих ВМ открываем две консоли, с помощью которых будем выполнять проверки, описанные ниже.
В первой консоли подключаемся к ВМ с nfs-сервером (далее будем называть ее консоль сервера):
<code>
vagrant ssh nfss
</code>
Во второй консоли подключаемся к ВМ с nfs-клиентом (далее будем называть ее консоль клиента):
<code>
vagrant ssh nfsc
</code>

<h2>Начальная проверка</h2>
В консоли сервера создаем тестовый файл в nfs-каталоге:
<code>
[vagrant@nfss ~]$ touch /srv/share/upload/check_file
</code>

В консоли клиента проверяем наличие созданного тестового файла:
<code>
[vagrant@nfsc ~]$ ls -l /mnt/upload/
total 0
-rw-rw-r--. 1 vagrant vagrant 0 Mar 26 19:51 check_file
</code>

В консоли клиента создаем второй тестовый файл:
<code>
[vagrant@nfsc ~]$ touch /mnt/upload/client_file
</code>

В консоли сервера проверяем наличие второго тестового файла:
<code>
[vagrant@nfss ~]$ ls -l /srv/share/upload/
total 0
-rw-rw-r--. 1 vagrant vagrant 0 Mar 26 19:51 check_file
-rw-rw-r--. 1 vagrant vagrant 0 Mar 26 20:03 client_file
</code>

<h2>Проверка клиента после перезагрузки</h2>
В консоли клиента отправляем команду на перезагрузку ВМ:
<code>
[vagrant@nfsc ~]$ sudo reboot
Connection to 127.0.0.1 closed by remote host.
</code>
Ждем несколько минут, пока перезагрузится ВМ с клиентом, и вновь подключаемся к ней из консоли клиента:
<code>
vagrant ssh nfsc
</code>

После подключения к ВМ в консоли клиента проверяем наличие ранее созданных тестовых файлов:
<code>
[vagrant@nfsc ~]$ ls -l /mnt/upload/
total 0
-rw-rw-r--. 1 vagrant vagrant 0 Mar 26 19:51 check_file
-rw-rw-r--. 1 vagrant vagrant 0 Mar 26 20:03 client_file
</code>

<h2>Проверка сервера после перезагрузки</h2>
В консоли сервера отправляем команду на перезагрузку ВМ:
<code>
[vagrant@nfss ~]$ sudo reboot
Connection to 127.0.0.1 closed by remote host.
</code>
Ждем несколько минут, пока перезагрузится ВМ с сервером, и вновь подключаемся к ней из консоли сервера:
<code>
vagrant ssh nfss
</code>
После подключения к ВМ в консоли сервера проверям наличие ранее созданных тестовых файлов:
<code>
[vagrant@nfss ~]$ ls -l /srv/share/upload/
total 0
-rw-rw-r--. 1 vagrant vagrant 0 Mar 26 19:51 check_file
-rw-rw-r--. 1 vagrant vagrant 0 Mar 26 20:03 client_file
</code>
В консоли сервера проверяем состояние службы NFS:
<code>
[vagrant@nfss ~]$ systemctl status nfs
● nfs-server.service - NFS server and services
   Loaded: loaded (/usr/lib/systemd/system/nfs-server.service; enabled; vendor preset: disabled)
  Drop-In: /run/systemd/generator/nfs-server.service.d
           └─order-with-mounts.conf
   Active: active (exited) since Tue 2024-03-26 20:19:27 UTC; 3min 37s ago
  Process: 822 ExecStartPost=/bin/sh -c if systemctl -q is-active gssproxy; then systemctl reload gssproxy ; fi (code=exited, status=0/SUCCESS)
  Process: 798 ExecStart=/usr/sbin/rpc.nfsd $RPCNFSDARGS (code=exited, status=0/SUCCESS)
  Process: 794 ExecStartPre=/usr/sbin/exportfs -r (code=exited, status=0/SUCCESS)
 Main PID: 798 (code=exited, status=0/SUCCESS)
   CGroup: /system.slice/nfs-server.service
</code>
В консоли сервера проверяем состояние службы файервола:
<code>
[vagrant@nfss ~]$ systemctl status firewalld
● firewalld.service - firewalld - dynamic firewall daemon
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; enabled; vendor preset: enabled)
   Active: active (running) since Tue 2024-03-26 20:19:21 UTC; 5min ago
     Docs: man:firewalld(1)
 Main PID: 407 (firewalld)
   CGroup: /system.slice/firewalld.service
           └─407 /usr/bin/python2 -Es /usr/sbin/firewalld --nofork --nopid
</code>  
В консоли сервера проверяем экспорты:
<code>
[vagrant@nfss ~]$ sudo exportfs -s
/srv/share  192.168.50.11/32(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,root_squash,no_all_squash)
</code>
В консоли сервера проверяем состояние RPC:
<code>
[vagrant@nfss ~]$ showmount -a 192.168.50.10
All mount points on 192.168.50.10:
192.168.50.11:/srv/share
</code>


Финальная проверка клиента
<code>
В консоли клиента отправляем команду на перезагрузку ВМ:
[vagrant@nfsc ~]$ sudo reboot
Connection to 127.0.0.1 closed by remote host.
</code>
Ждем несколько минут, пока перезагрузится ВМ с клиентом, и вновь подключаемся к ней из консоли клиента:
<code>
vagrant ssh nfsc
</code>
После подключения к ВМ в консоли клиента проверяем наличие ранее созданных тестовых файлов:
<code>
[vagrant@nfsc ~]$ ls -l /mnt/upload/
total 0
-rw-rw-r--. 1 vagrant vagrant 0 Mar 26 19:51 check_file
-rw-rw-r--. 1 vagrant vagrant 0 Mar 26 20:03 client_file
</code>
В консоли клиента проверяем состояние RPC:
<code>
[vagrant@nfsc ~]$ showmount -a 192.168.50.10
All mount points on 192.168.50.10:
192.168.50.11:/srv/share
</code>
В консоли клиента проверяем статус монтирования:
<code>
[vagrant@nfsc ~]$ mount | grep share
192.168.50.10:/srv/share/ on /mnt type nfs (rw,relatime,vers=3,rsize=32768,wsize=32768,namlen=255,hard,proto=udp,timeo=11,retrans=3,sec=sys,mountaddr=192.168.50.10,mountvers=3,mountport=20048,mountproto=udp,local_lock=none,addr=192.168.50.10)
</code>
В консоли клиента создаем третий тестовый файл:
<code>
[vagrant@nfsc ~]$ touch /mnt/upload/final_check
</code>
В консоли сервера проверяем наличие третьего тестового файла:
<code>
[vagrant@nfss ~]$ ls -l /srv/share/upload/
total 0
-rw-rw-r--. 1 vagrant vagrant 0 Mar 26 19:51 check_file
-rw-rw-r--. 1 vagrant vagrant 0 Mar 26 20:03 client_file
-rw-rw-r--. 1 vagrant vagrant 0 Mar 26 20:50 final_check
</code>
