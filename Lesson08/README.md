<h1>Домашнее задание по ZFS</h1>

<h2>Задание 1. Определить алгоритм с наилучшим сжатием</h2>
<ul>
 <li>Определить, какие алгоритмы сжатия поддерживает zfs (gzip, zle, lzjb, lz4)</li>
 <li>Создать 4 файловых системы, на каждой применить свой алгоритм сжатия</li>
 <li>Для сжатия использовать либо текстовый файл, либо группу файлов</li>
</ul> 

Смотрим список всех дисков, которые есть в виртуальной машине:
[vagrant@zfs ~]$ lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0   40G  0 disk 
`-sda1   8:1    0   40G  0 part /
sdb      8:16   0  512M  0 disk 
sdc      8:32   0  512M  0 disk 
sdd      8:48   0  512M  0 disk 
sde      8:64   0  512M  0 disk 
sdf      8:80   0  512M  0 disk 
sdg      8:96   0  512M  0 disk 
sdh      8:112  0  512M  0 disk 
sdi      8:128  0  512M  0 disk 



Переходим в root:
[vagrant@zfs ~]$ sudo -i
[root@zfs ~]#

Создаем 4 двухдисковых пула в режиме RAID1 с файловыми системами otus1, otus2, otus3, otus4:
[root@zfs ~]# zpool create otus1 mirror /dev/sdb /dev/sdc
[root@zfs ~]# zpool create otus2 mirror /dev/sdd /dev/sde
[root@zfs ~]# zpool create otus3 mirror /dev/sdf /dev/sdg
[root@zfs ~]# zpool create otus4 mirror /dev/sdh /dev/sdi

Смотрим информацию о созданных пулах:
[root@zfs ~]# zpool list
NAME    SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
otus1   480M  91.5K   480M        -         -     0%     0%  1.00x    ONLINE  -
otus2   480M  91.5K   480M        -         -     0%     0%  1.00x    ONLINE  -
otus3   480M  91.5K   480M        -         -     0%     0%  1.00x    ONLINE  -
otus4   480M  91.5K   480M        -         -     0%     0%  1.00x    ONLINE  -

Добавим разные алгоритмы сжатия для файловых систем созданных пулов:
[root@zfs ~]# zfs set compression=lzjb otus1
[root@zfs ~]# zfs set compression=lz4 otus2
[root@zfs ~]# zfs set compression=gzip-9 otus3
[root@zfs ~]# zfs set compression=zle otus4

Проверим результат выполнения:
[root@zfs ~]# zfs get all | grep compression
otus1  compression           lzjb                   local
otus2  compression           lz4                    local
otus3  compression           gzip-9                 local
otus4  compression           zle                    local

Сжатие будем применяться только к тем файлам, которые будут созданы после включения сжатия.
Скачиваем один и тот же файл на каждую файловую систему:
[root@zfs ~]# for i in {1..4}; do wget -P /otus$i https://gutenberg.org/cache/epub/2600/pg2600.converter.log; done
--2024-03-24 15:53:06--  https://gutenberg.org/cache/epub/2600/pg2600.converter.log
Resolving gutenberg.org (gutenberg.org)... 152.19.134.47, 2610:28:3090:3000:0:bad:cafe:47
Connecting to gutenberg.org (gutenberg.org)|152.19.134.47|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 41025184 (39M) [text/plain]
Saving to: '/otus1/pg2600.converter.log'

87% [==========================================================================================================>                ] 35,877,459  2.25MB/s   in 29s    

2024-03-24 15:53:37 (1.17 MB/s) - Connection closed at byte 35877459. Retrying.

--2024-03-24 15:53:38--  (try: 2)  https://gutenberg.org/cache/epub/2600/pg2600.converter.log
Connecting to gutenberg.org (gutenberg.org)|152.19.134.47|:443... connected.
HTTP request sent, awaiting response... 206 Partial Content
Length: 41025184 (39M), 5147725 (4.9M) remaining [text/plain]
Saving to: '/otus1/pg2600.converter.log'

100%[+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++===============>] 41,025,184  3.24MB/s   in 1.5s   

2024-03-24 15:53:45 (3.24 MB/s) - '/otus1/pg2600.converter.log' saved [41025184/41025184]

--2024-03-24 15:53:45--  https://gutenberg.org/cache/epub/2600/pg2600.converter.log
Resolving gutenberg.org (gutenberg.org)... 152.19.134.47, 2610:28:3090:3000:0:bad:cafe:47
Connecting to gutenberg.org (gutenberg.org)|152.19.134.47|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 41025184 (39M) [text/plain]
Saving to: '/otus2/pg2600.converter.log'

100%[==========================================================================================================================>] 41,025,184  1.92MB/s   in 18s    

2024-03-24 15:54:04 (2.19 MB/s) - '/otus2/pg2600.converter.log' saved [41025184/41025184]

--2024-03-24 15:54:04--  https://gutenberg.org/cache/epub/2600/pg2600.converter.log
Resolving gutenberg.org (gutenberg.org)... 152.19.134.47, 2610:28:3090:3000:0:bad:cafe:47
Connecting to gutenberg.org (gutenberg.org)|152.19.134.47|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 41025184 (39M) [text/plain]
Saving to: '/otus3/pg2600.converter.log'

100%[==========================================================================================================================>] 41,025,184  2.26MB/s   in 17s    

2024-03-24 15:54:23 (2.33 MB/s) - '/otus3/pg2600.converter.log' saved [41025184/41025184]

--2024-03-24 15:54:23--  https://gutenberg.org/cache/epub/2600/pg2600.converter.log
Resolving gutenberg.org (gutenberg.org)... 152.19.134.47, 2610:28:3090:3000:0:bad:cafe:47
Connecting to gutenberg.org (gutenberg.org)|152.19.134.47|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 41025184 (39M) [text/plain]
Saving to: '/otus4/pg2600.converter.log'

100%[==========================================================================================================================>] 41,025,184   146KB/s   in 1m 40s 

2024-03-24 15:56:04 (400 KB/s) - '/otus4/pg2600.converter.log' saved [41025184/41025184]


Проверяем результаты скачивания:
[root@zfs ~]# ls -l /otus*
/otus1:
total 22069
-rw-r--r--. 1 root root 41025184 Mar  2 08:53 pg2600.converter.log

/otus2:
total 17995
-rw-r--r--. 1 root root 41025184 Mar  2 08:53 pg2600.converter.log

/otus3:
total 10960
-rw-r--r--. 1 root root 41025184 Mar  2 08:53 pg2600.converter.log

/otus4:
total 40091
-rw-r--r--. 1 root root 41025184 Mar  2 08:53 pg2600.converter.log


По значению total видим, что наимболее эффективным в этом случае является алгоритм, использующийся на файловой системе otus3 (gzip)
Посмотрим занимаемое файлом место на каждой из файловых систем:
[root@zfs ~]# zfs list
NAME    USED  AVAIL     REFER  MOUNTPOINT
otus1  21.7M   330M     21.6M  /otus1
otus2  17.7M   334M     17.6M  /otus2
otus3  10.8M   341M     10.7M  /otus3
otus4  39.3M   313M     39.2M  /otus4

Посмотрим степень сжатия:
[root@zfs ~]# zfs get all | grep compressratio | grep -v ref
otus1  compressratio         1.81x                  -
otus2  compressratio         2.22x                  -
otus3  compressratio         3.65x                  -
otus4  compressratio         1.00x                  -

Делаем вывод, что для нашего кейса самым эффективным алгоритмом сжатия является gzip-9







Задание 2. Определить настройки пула.
  С помощью команды zfs import собрать пул ZFS.
  Командами zfs определить настройки:
  - размер хранилища;
  - тип пула;
  - значение recordsize;
  - какое сжатие используется;
  - какая контрольная сумма используется.

Скачиваем архив в домашнюю папку:
[root@zfs ~]# wget -O archive.tar.gz --no-check-certificate 'https://drive.usercontent.google.com/download?id=1MvrcEp-WgAQe57aDEzxSRalPAwbNN1Bb&export=download'
--2024-03-24 16:13:43--  https://drive.usercontent.google.com/download?id=1MvrcEp-WgAQe57aDEzxSRalPAwbNN1Bb&export=download
Resolving drive.usercontent.google.com (drive.usercontent.google.com)... 142.250.178.129, 2a00:1450:4007:819::2001
Connecting to drive.usercontent.google.com (drive.usercontent.google.com)|142.250.178.129|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 7275140 (6.9M) [application/octet-stream]
Saving to: 'archive.tar.gz'

100%[==========================================================================================================================>] 7,275,140   3.26MB/s   in 2.1s   

2024-03-24 16:13:53 (3.26 MB/s) - 'archive.tar.gz' saved [7275140/7275140]


Распакуем скачанный архив:
[root@zfs ~]# tar -xzvf archive.tar.gz
zpoolexport/
zpoolexport/filea
zpoolexport/fileb

Проверяем возможность импорта каталога в пул:
[root@zfs ~]# zpool import -d zpoolexport/
   pool: otus
     id: 6554193320433390805
  state: ONLINE
 action: The pool can be imported using its name or numeric identifier.
 config:

	otus                         ONLINE
	  mirror-0                   ONLINE
	    /root/zpoolexport/filea  ONLINE
	    /root/zpoolexport/fileb  ONLINE


Импортируем пул:
[root@zfs ~]# zpool import -d zpoolexport/ otus

Проверяем статус импортированного пула:
[root@zfs ~]# zpool status
  pool: otus
 state: ONLINE
  scan: none requested
config:

	NAME                         STATE     READ WRITE CKSUM
	otus                         ONLINE       0     0     0
	  mirror-0                   ONLINE       0     0     0
	    /root/zpoolexport/filea  ONLINE       0     0     0
	    /root/zpoolexport/fileb  ONLINE       0     0     0

errors: No known data errors

Смотрим размер хранилища:
[root@zfs zpoolexport]# zfs get available otus
NAME  PROPERTY   VALUE  SOURCE
otus  available  350M   -

Смотрим тип пула:
[root@zfs zpoolexport]# zfs get readonly otus
NAME  PROPERTY  VALUE   SOURCE
otus  readonly  off     default
Видим, что пул имеет тип rw (чтение+запись)

Смотрим значение recordsize:
[root@zfs zpoolexport]# zfs get recordsize otus
NAME  PROPERTY    VALUE    SOURCE
otus  recordsize  128K     local

Смотрим тип сжатия:
[root@zfs zpoolexport]# zfs get compression otus
NAME  PROPERTY     VALUE     SOURCE
otus  compression  zle       local

Смотрим тип контрольной суммы:
[root@zfs zpoolexport]# zfs get checksum otus
NAME  PROPERTY  VALUE      SOURCE
otus  checksum  sha256     local







Задание 3. Работа со снапшотами:
    скопировать файл из удаленной директории;
    восстановить файл локально. zfs receive;
    найти зашифрованное сообщение в файле secret_message

Скачиваем файл:
[root@zfs zpoolexport]# --2024-03-24 16:37:26--  https://drive.usercontent.google.com/download?id=1wgxjih8YZ-cqLqaZVa0lA3h3Y029c3oI
Resolving drive.usercontent.google.com (drive.usercontent.google.com)... 142.250.178.129, 2a00:1450:4007:819::2001
Connecting to drive.usercontent.google.com (drive.usercontent.google.com)|142.250.178.129|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 5432736 (5.2M) [application/octet-stream]
Saving to: 'otus_task2.file'

100%[==========================================================================================================================>] 5,432,736   2.30MB/s   in 2.2s   

2024-03-24 16:37:31 (2.30 MB/s) - 'otus_task2.file' saved [5432736/5432736]


[1]+  Done                    wget -O otus_task2.file --no-check-certificate https://drive.usercontent.google.com/download?id=1wgxjih8YZ-cqLqaZVa0lA3h3Y029c3oI


Восстанавливаем файловую систему из снапшота:
[root@zfs zpoolexport]# zfs receive otus/test@today < otus_task2.file

Ищем файл с именем secret_message:
[root@zfs zpoolexport]# find /otus/test -name "secret_message"
/otus/test/task1/file_mess/secret_message

Смотрим содержимое найденного файла:
[root@zfs zpoolexport]# cat /otus/test/task1/file_mess/secret_message
https://otus.ru/lessons/linux-hl/


