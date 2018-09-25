# VPS 建站

---

```shell
# 首先修改 deb 源

vim /etc/apt/sources.list
​```
deb http://mirrors.163.com/debian/ jessie main non-free contrib
deb http://mirrors.163.com/debian/ jessie-updates main non-free contrib
deb http://mirrors.163.com/debian/ jessie-backports main non-free contrib
deb-src http://mirrors.163.com/debian/ jessie main non-free contrib
deb-src http://mirrors.163.com/debian/ jessie-updates main non-free contrib
deb-src http://mirrors.163.com/debian/ jessie-backports main non-free contrib
deb http://mirrors.163.com/debian-security/ jessie/updates main non-free contrib
deb-src http://mirrors.163.com/debian-security/ jessie/updates main non-free contrib

# deb cdrom:[Debian GNU/Linux 9.4.0 _Stretch_ - Official amd64 NETINST 20180310-11:21]/ stretch main

# deb cdrom:[Debian GNU/Linux 9.4.0 _Stretch_ - Official amd64 NETINST 20180310-11:21]/ stretch main

deb http://http.us.debian.org/debian/ stretch main
deb-src http://http.us.debian.org/debian/ stretch main

deb http://security.debian.org/debian-security stretch/updates main
deb-src http://security.debian.org/debian-security stretch/updates main

# stretch-updates, previously known as 'volatile'
deb http://http.us.debian.org/debian/ stretch-updates main
deb-src http://http.us.debian.org/debian/ stretch-updates main
​```
```



---



## 1. vps -- vultr -- 添加/配置 vps

**修改 `vimrc`**

`vim /etc/vim/vimrc`

```shell
:set encoding=utf-8
:set fileencodings=ucs-bom,utf-8,cp936
:set fileencoding=gb2312
:set termencoding=utf-8
:set nu
:set ts=4
:set expandtab
:%retab!
```

**设置时区**

`vim .profile`

```shell
TZ='Asia/Shanghai'; export TZ
```



## 2. 下载 `anaconda`

```shell
# anaconda
wget https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh
# wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-5.2.0-Linux-x86_64.sh

# miniconda
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
# wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh
```
  - 安装『略过』『路径: /root/anaconda3』
    `source .bashrc`

  - 创建虚拟环境
    `conda create -n test python=3.7`

  ​

## 3. 安装依赖

`apt install gcc python3-dev -y`



## 4 修改 `conda config` 通道为 `conda-forge` 来安装 uwsgi

**通过添加到您的频道可以实现`uwsgi`从`conda-forge`频道安装`conda-forge`：**

​	`conda config --add channels conda-forge`

**一旦`conda-forge`通道已经启用，`uwsgi`可以安装有：**

​	`conda install uwsgi`

  - 可以查找 uwsgi 在您平台可用的所有版本
`conda search uwsgi --channel conda-forge`
  - 关于 conda-forge
    conda-forge是一个由社区主导的可安装包的conda渠道。为了提供高质量的构建，该过程已经自动化到conda-forge GitHub组织中。conda-forge组织为每个可安装包包含一个存储库。这种储存库被称为原料。
    原料由conda配方（关于什么以及如何构建包装的说明）和使用免费可用的连续集成服务进行自动构建的必要配置组成。由于CircleCI，AppVeyor 和TravisCI提供的强大服务 ，可以分别为Linux，Windows和OSX 构建和上传可安装软件包到conda- forge Anaconda-Cloud渠道。
    为了管理持续集成和简化原料维护， 已经开发了conda-smithy。使用conda-forge.yml此存储库中的内容，可以重新呈现所有这些原料的支持文件（例如CI配置文件）conda smithy rerender。
    有关更多信息，请查看conda-forge文档。
  - ​

## 5 修改 $PATH, 安装 uwsgi, 配置 uwsgi 文件

```shell
# echo $PATH  『安装 conda 时选择添加环境变量, 可跳过这步』
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
# export PATH=/root/anaconda3/envs/test/bin:$PATH
# 根据具体情况而定「关闭终端失效」
# 永久修改 PATH
vim .bashrc

conda install uwsgi

# 运行 uwsgi 文件
uwsgi -ini *.ini
​```
[uwsgi]

chdir           = /srv/ssite
# Django的wsgi文件
module          = ssite.wsgi
# Python虚拟环境的路径
home            = 			#/root/anaconda/envs/ssite

# 进程相关的设置
# 主进程
master          = true
# 最大数量的工作进程
processes       = 10
# socket文件路径，绝对路径
socket          = /tmp/ssite.sock
# 设置socket的权限
chmod-socket    = 666
# 退出的时候是否清理环境
vacuum          = true
# 运行状态, 保存至 ./uwsgi/uwsgi.status
stats           = %(chdir)/uwsgi/uwsgi.status
# 主进程 ID, 保存至 ./uwsgi/uwsgi.pid
pidfile         = %(chdir)/uwsgi/uwsgi.pid
​```
```

## 6 安装 Django

```python
# Django settings 设置
LANGUAGE_CODE = 'zh-hans'
TIME_ZONE = 'Asia/Shanghai'
```



## 7 创建项目 `/srv/`

  - django-admin startproject ssite

    ​

## 8 安装 nginx 以及编写 nginx 配置文件：

**安装:**

`apt install nginx`

**配置:**

在`/etc/nginx/conf.d`目录下，新建一个文件，叫做`ssite.conf`，然后将以下代码粘贴进去：

```nginx
upstream ssite {
    server unix:///tmp/ssite.sock;
}

# 配置服务器
server {
    # 监听的端口号
    listen      80;
    # 域名
    server_name 45.77.238.57;
    charset     utf-8;

    # 最大的文件上传尺寸
    client_max_body_size 75M;

    # 静态文件访问的url
    location /static {
        # 静态文件地址
        alias /srv/static;
    }

    # 最后，发送所有非静态文件请求到django服务器
    location / {
        uwsgi_pass  ssite;
        # uwsgi_params文件地址
        include     /etc/nginx/uwsgi_params;
    }
}
```

写完配置文件后，为了测试配置文件是否设置成功，运行命令：`service nginx configtest`，如果不报错，说明成功。
每次修改完了配置文件，都要记得运行`service nginx restart`。



## 9 安装 `MySql`

> 安装 mysql 5.7 需要 RAM > 1G

```shell
# ===========================================================
# ========================可忽略==============================
# ===========================================================
# 卸载 mysql | MariaDB
# 彻底卸载软件
# 删除软件及其配置文件
apt-get --purge remove mysql-server mysql-client -y
# 删除没用的依赖包
apt-get autoremove mysql-server mysql-client -y
# 此时dpkg的列表中有“rc”状态的软件包，可以执行如下命令做最后清理：
dpkg -l |grep ^rc|awk '{print $2}' | xargs dpkg -P
# ===========================================================
```



### debian-mysql5.7安装与卸载『正确版本』

<https://juejin.im/post/5a4335c5518825094862cc5a>

1.下载myslq安装包

```shell
$ cd /usr/local/src

$ wget --no-check-certificate https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-server_5.7.20-1debian7_amd64.deb-bundle.tar
```

2.解压安装包

```
如果不是在root下需要加上权限
$ sudo chmod +x mysql-server_5.7.20-1debian7_amd64.deb-bundle.tar

如果在root下直接解压
$ tar vxf mysql-server_5.7.20-1debian7_amd64.deb-bundle.tar

ls查看：解压之后的目录:如下
复制代码
```

![img](https://user-gold-cdn.xitu.io/2017/12/27/160968d0f53618d9?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

3.更新依赖源及安装libaio1依赖

```shell
$ apt-get --fix-broken install -y
$ apt-get update -y
$ apt-get upgrade -y
$ apt-get install libnuma1 -y
复制代码
```

4.开始安装（需要按照顺序）

```shell
$ dpkg -i mysql-common_5.7.20-1debian7_amd64.deb
$ dpkg-preconfigure mysql-community-server_5.7.20-1debian7_amd64.deb

执行后会出现设置数据库root的密码。
复制代码
```

5.继续安装

```shell
$ dpkg -i libmysqlclient20_5.7.20-1debian7_amd64.deb 
$ dpkg -i libmysqlclient-dev_5.7.20-1debian7_amd64.deb
$ dpkg -i libmysqld-dev_5.7.20-1debian7_amd64.deb 
$ dpkg -i mysql-community-client_5.7.20-1debian7_amd64.deb 
$ dpkg -i mysql-client_5.7.20-1debian7_amd64.deb 
$ dpkg -i mysql-common_5.7.20-1debian7_amd64.deb
复制代码
```

6.安装依赖包

```shell
$ apt-get -f install -y
$ apt-get -f install libmecab2 -y
复制代码
```

7.安装mysql－server

```shell
$ dpkg -i mysql-community-server_5.7.20-1debian7_amd64.deb 
$ dpkg -i mysql-server_5.7.20-1debian7_amd64.deb

*如果出现mysql－server依赖报错～以上两句命令顺序调换执行一次～再重复第5步骤再执行第7步。
复制代码
```

8.安装成功后检查

```shell
$ mysql -u root -p
输入刚刚设置的密码.出现下图表示mysql已经安装成功了！
复制代码
```

![img](https://user-gold-cdn.xitu.io/2017/12/27/160968fe8aa46f65?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

9.配置远程连接(其他电脑连接所在mysql服务器)

```
show databases;
use mysql;
update user set host='%' where user='root';
复制代码
```

10.修改/etc/mysql/mysql.conf.d下的mysqld.cnf

```
$ cd /etc/mysql/mysql.conf.d
$ vim mysqld.cnf
注释本地连接着一行
bind-address = 127.0.0.1 改成 # bind-address = 127.0.0.1 
复制代码
```

11.重启mysql：

```
$ service mysql restart
复制代码
```

卸载

```
$ apt-get --purge remove mysql-server
$ apt-get --purge remove mysql-client
$ apt-get --purge remove mysql-common

最后再通过下面的命令清理残余
$ apt-get autoremove
$ apt-get autoclean
$ rm /etc/mysql/ -R
$ rm /var/lib/mysql/ -R
```

```mysql
# Mysql 关于编码问题

# MySQL的“utf8”实际上不是真正的UTF-8。
# “utf8”只支持每个字符最多三个字节，而真正的UTF-8是每个字符最多四个字节。
# MySQL一直没有修复这个bug，他们在2010年发布了一个叫作“utf8mb4”的字符集，绕过了这个问题。
#　当然，他们并没有对新的字符集广而告之（可能是因为这个bug让他们觉得很尴尬），以致于现在网络上仍然在建议开发者使用“utf8”，但这些建议都是错误的。

# 简单概括如下：
# MySQL的“utf8mb4”是真正的“UTF-8”。
# MySQL的“utf8”是一种“专属的编码”，它能够编码的Unicode字符并不多

mysql>SET NAMES 'utf8mb4';
Query OK, 0 rows affected (0.00 sec)

mysql>SHOW VARIABLES LIKE 'character_set_%';
+--------------------------+----------------------------+
| Variable_name            | Value                      |
+--------------------------+----------------------------+
| character_set_client     | utf8mb4                    |
| character_set_connection | utf8mb4                    |
| character_set_database   | latin1                     |
| character_set_filesystem | binary                     |
| character_set_results    | utf8mb4                    |
| character_set_server     | latin1                     |
| character_set_system     | utf8                       |
| character_sets_dir       | /usr/share/mysql/charsets/ |
+--------------------------+----------------------------+

mysql> CREATE DATABASE `sspanel` CHARACTER SET utf8mb4 COLLATE  utf8mb4_unicode_ci;
```

