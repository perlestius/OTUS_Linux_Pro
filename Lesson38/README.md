<h1>LDAP</h1>
<ul>
 <li>Установить FreeIPA</li>
 <li>Написать Ansible playbook для конфигурации клиента</li>
 <li>Настроить аутентификацию по SSH-ключам*</li>
 <li>Firewall должен быть включен на сервере и на клиенте*</li>
</ul> 
Статус "Принято" ставится при выполнении основных требований.
Задания со звездочками выполняются по желанию (в этом решении НЕ реализовано).

<h2>Описание решения</h2>
Для запуска стенда потребуется 6ГБ свободной RAM: по 2ГБ на каждую ВМ.
Переходим в каталог с загруженными файлами и запускаем скрипт развертывания стенда:
<code>
bash run.sh
</code>
В течение ~15 мин должны развернуться 3 ВМ: IPA-сервер и два его клиента.
IP-адрес сервера: 192.168.57.10, IP-адреса клиентов: 192.168.57.11, 192.168.57.12.
</br>
Пароль администратора для IPA-сервера будет <b>12345678</b>. На IPA-сервере будет создан пользователь <b>ipauser@OTUS.LAN</b> с паролем <b>123</b>.
После развертывания будет предложено залогиниться под пользователем ipauser@OTUS.LAN сначала на первый клиент, потом на второй.
</br>
В случае возникновения ошибки "REMOTE HOST IDENTIFICATION HAS CHANGED!" надо удалить файл ~/.ssh/known_hosts на той машине, с которой выполняется подключение, и повторить попытку.
</br>
Для доступа к веб-интерфейсу сервера надо на машине, с которой будем к нему обращаться, добавить запись в файл /etc/hosts:
<code>
192.168.57.10	ipa.otus.lan
</code>
