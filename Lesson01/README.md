<h2>КРАТКАЯ ИНСТРУКЦИЯ</h2>
<ol>
 <li>Копируем файл Vagrantfile в папку на своей машине</li>
 <li>Устанавливаем VPN-соединение, чтобы скачать образ из Vagrant Cloud
 <br><img src="https://habrastorage.org/webt/50/qf/do/50qfdoq1qh8sketwbe5p7f-h1jy.png" alt="Loading picture..."/></b>
 </li>
 <li>В консоли переходим в папку, куда был скопирован Vagrantfile, и запускаем команду на развертывание ВМ:<br><code><b>vagrant up</b></code>
 <br><img src="https://habrastorage.org/webt/jx/ww/ni/jxwwniiwtqhb3xiuldy_g1zrkb0.png" alt="Loading picture..."/></b>
 </li> 
 <li>Ждем, когда ВМ запустится, и подключаемся к ней по ssh:<br><code><b>vagrant ssh</b></code>
 <br><img src="https://habrastorage.org/webt/yu/89/rt/yu89rttspwemtxh-ctim2cwzgta.png" alt="Loading picture..."/></b>
 </li>
 <li>Проверяем версию ядра ОС на ВМ (должно быть 6.6.1-1.el8.elrepo.x86_64):<br><code><b>uname -r</b></code>
 <br><img src="https://habrastorage.org/webt/2c/av/bi/2cavbidc8cfz7ww68hadovsd4ie.png" alt="Loading picture..."/></b>
 </li>  
 <li>Отключаемся от ВМ:<br><code><b>exit</b></code></li>
 <li>Удаляем ВМ:<br><code><b>vagrant destroy --force</b></code>
 <br><img src="https://habrastorage.org/webt/lq/bw/c1/lqbwc1shu57lsfe-dmdch6rn5ck.png" alt="Loading picture..."/></b>
 </li>
</ol>
<h2>ИЗВЕСТНЫЕ ПРОБЛЕМЫ</h2>
<img src="https://habrastorage.org/webt/0j/o-/ai/0jo-aiy2lusmfwuycptxz-cib5y.png" alt="Loading picture..."/>
При развертывании ВМ на этапе "Setting hostname" выдается ошибка:
<br><code><b>The following SSH command responded with a non-zero exit status.
Vagrant assumes that this means the command failed!
</b></code>
Наверное, это нехорошо, но сеть вроде работет, Яндекс пингуется. :)
