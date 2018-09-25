# virtualBox 安装 ubuntu

## 1 安装教程

[基于VirtualBox虚拟机安装 Ubuntu Server](https://www.jianshu.com/p/e2792198353e, '基于VirtualBox虚拟机安装 Ubuntu Server')

## 2 安装 ssh-server 并能 ssh root 登录

```shell
$ # === server ===
$ sudo apt-get install openssh-server
$ sudo passwd 	# 修改 root 密码
$ su 	        # 切换 root 
$ # 此时无法直接 ssh root 连接
$ # 新版本里面sshd_config里面有了限制
$ vim /etc/ssh/sshd_config

# Authentication:
LoginGraceTime 120
#PermitRootLogin without-password    #找到这里，把它注释
PermitRootLogin yes                  #改为yes  然后重启ssh
StrictModes yes
:wq

$ service ssh restart
$ #Tips：这里注意/etc/init.d/ssh restart 用这个方式重启是不成功的。
$
$ # 此时，成功使用 root 连接 ssh
```

## 3 修改 ubuntu 的 apt 源（云服务器不需要修改）：

```shell
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse
```

