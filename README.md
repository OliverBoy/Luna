Luna
====

Club Penguin Server Emulator - AS2 Protocol

Tutorial for VPS: <a href="http://awptical.pw/index.php?/topic/5-how-to-make-an-as2-cpps-on-a-vps/">here.</a>
<br>
Tutorial for localhost: <a href="http://awptical.pw/index.php?/topic/6-how-to-make-an-as2-cpps-on-localhost/">here.</a>

![](https://i.imgur.com/rD2hLCu.png)
![](https://i.imgur.com/mp0LDld.png)
![](https://i.imgur.com/JuPHMPo.png)
![](https://i.imgur.com/JjfCxWD.png)
![](https://i.imgur.com/eI2HR3p.png)
![](https://i.imgur.com/C1qeesO.png)

### Requirements:
- PHP 5.5+
- Perl v5.12 till v5.18
- Apache2/Nginx
- Phpmyadmin/Adminer
- MySQL
- Internet Connection

### Required Perl modules
Perl Modules required but not installed by default.

To install use:

```
$ cpan
cpan[2]> install [MODULE]
cpan[2]> exit
```

- Module::Find
- Method::Signatures
- LWP::Simple
- XML::Simple
- Coro
- Data::Alias
- DBI
- Switch
- JSON
- Math::Round
- List::MoreUtils
- Data::RandomPerson

The following need to be installed with `force install` instead of `install`:
- WebService::UrbanDictionary
- DBD::mysql
