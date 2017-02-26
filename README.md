Luna
====

Club Penguin Server Emulator - AS2 Protocol

Project has been discontinued but you can get support <a href="https://github.com/OliverBoy/Luna/issues">here.</a>

![](https://i.imgur.com/rD2hLCu.png)
![](https://i.imgur.com/mp0LDld.png)
![](https://i.imgur.com/JuPHMPo.png)
![](https://i.imgur.com/JjfCxWD.png)
![](https://i.imgur.com/eI2HR3p.png)
![](https://i.imgur.com/C1qeesO.png)

### Requirements:
<ul>
 <li> PHP 5.5+</li>
 <li> Perl v5.12 till v5.18</li>
 <li> Apache2/Nginx</li>
 <li> Phpmyadmin/Adminer</li>
 <li> MySQL</li>
 <li> Internet Connection</li>
</ul>

### Instructions:
<ul>
 <li> Install PHP and setup a webserver - <a href="http://www.wikihow.com/Install-XAMPP-for-Windows">Windows</a>/<a href="https://www.rosehosting.com/blog/how-to-install-lamp-linux-apache-mysql-php-and-phpmyadmin-on-a-debian-8-vps/">Linux</a></li>
 <li> Install all the Perl modules from the modules list</a></li>
 <ul>
 <li>  First install <b>CPAN</b> and after that type: <code>reload cpan</code> and then continue installing the other modules</li>
 <li> If some modules fail to install or refuse to install then install those particular modules manually, click <a href="http://www.thegeekstuff.com/2008/09/how-to-install-perl-modules-manually-and-using-cpan-command/">here</a> to know how to do manual installation of modules or use <code>force install</code> to install them</li>
 <li> If you are still not able to install the modules by yourself, you can create an issue but do not create an issue if you did not try the above</li>
 </ul>
 <li> Setup an AS2 Media Server</li>
 <li> Import the <a href="https://github.com/OliverBoy/Luna/blob/master/SQL/Database.sql">SQL</a> using <b>Phpmyadmin/Adminer</b></li>
 <li> Create an account through the database</li>
 <li> Edit <a href="https://github.com/OliverBoy/Luna/blob/master/Configuration/Config.pl">Config.pl</a></li>
 <li> Execute <a href="https://github.com/OliverBoy/Luna/blob/master/Run.pm">Run.pm</a></li>
</ul>

### Modules: 
<ul>
 <li> CPAN</li>
 <li> Method::Signatures</li>
 <li> Digest::MD5</li>
 <li> XML::Simple</li>
 <li> LWP::Simple</li>
 <li> Data::Alias</li>
 <li> Cwd</li>
 <li> JSON</li>
 <li> Coro</li>
 <li> DBI</li>
 <li> DBD::mysql</li>
 <li> Module::Find</li>
 <li> List::Util</li>
 <li> Math::Round</li>
 <li> Switch</li>
 <li> File::Fetch</li>
</ul>

### Windows Setup: 

https://aureus.pw/topic/167-luna-how-to-create-a-cpps-on-localhost/

### Linux VPS and PC Setup:

<details>

To setup Luna on a VPS is very easy, since most of the VPS's come with <b>Ubuntu 14</b>, I will be using <b>Ubuntu</b> here:


First you got to setup <a href="http://howtoubuntu.org/how-to-install-lamp-on-ubuntu">LAMP</a>


Please also execute these commands after installing LAMP:


```
echo "ServerName localhost" | sudo tee /etc/apache2/conf-available/fqdn.conf
sudo a2enconf fqdn
sudo apt-get install php5-mysql
sudo apt-get install libmysqlclient-dev
sudo apt-get install libxml-parser-perl
sudo service apache2 restart
```


Then after you have done that, check the version of Perl your server comes bundled with, so open up your terminal and execute this command:


```
perl -v
```


These days your servers comes bundled with <b>Perl 5.20+</b> which is not compatible with Luna yet. So what do you got to do? Simple! Use <b>perlbrew</b>!


So open up your terminal again and run these commands:


```
sudo cpan App::perlbrew
perlbrew init
```


There we go, <b>perlbrew</b> is installed! Now lets install <b>Perl 5.14</b> and use that as the default version of Perl by running these commands:


```
perlbrew install perl-5.14.4
perlbrew switch perl-5.14.4
```


and you're done. Now before we proceed any further, lets make sure you have an updated server. So run these commands:


```
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
sudo apt-get install build-essential
sudo apt-get install patch
```


Now lets start installing the required modules for Luna, please note that some modules in the list are already pre-installed so watch what you do.


First lets initiate <b>CPAN</b>, run this command:


```
cpan
```


If you get any prompts, type <b>y</b>(yes) and hit the <b>enter</b> key on your keyboard.


Now lets first update <b>CPAN</b> by executing these commands:


```
install CPAN
reload CPAN
```


Now using the modules list go ahead and install each of those modules except <b>CPAN</b> since we already updated it. Usually after installing a module, it will display a status to let you know if it is installed or not so please be aware of it.


After you have done that, download <a href="https://github.com/OliverBoy/Luna/archive/master.zip">Luna</a> and unzip it and store it somewhere in your server.


Now lets import the SQL onto Phpmyadmin:


<ul>
  <li>Go to <b>http://yourserverip/phpmyadmin</b> and login using your MySQL username and password</li>
  <li>Go to the <b>Import</b> tab</li>
  <li>Click <b>Browse</b>, locate Luna's SQL file, click <b>Open</b>, and then click <b>Go</b></li>
</ul>


Now go back to Luna's directory and open <b>/Configuration/Config.pl</b> and edit your information and save it.


Last but not the least, pull up your terminal and using the ```cd``` command, navigate to Luna's directory and execute this command:


```
perl Run.pm
```


Now you should have Luna successfully running, if you want to keep Luna running 24/7 you can use <a href="https://www.howtoforge.com/linux_screen">Screen </a> or <a href="http://www.cyberciti.biz/tips/nohup-execute-commands-after-you-exit-from-a-shell-prompt.html">nohup</a>.

</details>
