<h1>Домашнее задание по LVM</h1>
Описанные ниже действия выполнялись на Centos 7.5.1804, развернутой в VirtualBox с помощью Vagrant.
<h2>Что сделано</h2>
<ul>
 <li>Уменьшение тома под / до 8ГБ через создание временного тома</li>
 <li>Настройка монтирования в fstab</li>
 <li>Выделение тома под /var и настройка для него mirror-режима</li>
 <li>Выделение тома под /home</li>
 <li>Работа со снапшотами для /home:</li>
 <ul>
  <li>создание тома для снапшотов</li>
  <li>генерация файлов</li>
  <li>создание снапшота</li>
  <li>удаление части созданных файлов</li>
  <li>откат к снапшоту, проверка восстановления удаленных файлов</li>
 </ul> 
</ul> 
Лог выполненных действий находится в файле <a href="output.txt">output.txt</a>
