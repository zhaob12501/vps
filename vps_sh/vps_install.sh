#!/bin/bash

echo '
:set encoding=utf-8
:set fileencodings=ucs-bom,utf-8,cp936
:set fileencoding=gb2312
:set termencoding=utf-8
:set nu
:set ts=4
:set expandtab
:%retab!' >> /etc/vim/vimrc

echo "TZ='Asia/Shanghai'; export TZ" >> ~/.profile

apt-get update -y
apt-get --fix-broken install -y
apt-get upgrade -y
apt-get install libnuma1 -y

# 安装前置依赖
apt-get install libpcre3 libpcre3-dev openssl libssl-dev libperl-dev -y
apt-get install -y gcc python3-dev git 
apt-get install -y nginx tree


if [ -f "/opt/Miniconda3-latest-Linux-x86_64.sh" ]; then
    /opt/Miniconda3-latest-Linux-x86_64.sh
elif [ -f "/opt/Anaconda3-5.2.0-Linux-x86_64.sh" ]; then
    /opt/Anaconda3-5.2.0-Linux-x86_64.sh
elif wget -P /opt/ https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && chmod +x /opt/Miniconda3-latest-Linux-x86_64.sh; then
    /opt/Miniconda3-latest-Linux-x86_64.sh
elif wget -P /opt/ https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh && chmod +x /opt/Miniconda3-latest-Linux-x86_64.sh; then
    /opt/Miniconda3-latest-Linux-x86_64.sh
elif wget -P /opt/ https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh && chmod +x /opt/Anaconda3-5.2.0-Linux-x86_64.sh; then
    /opt/Anaconda3-5.2.0-Linux-x86_64.sh
elif wget -P /opt/ https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-5.2.0-Linux-x86_64.sh && chmod +x /opt/Anaconda3-5.2.0-Linux-x86_64.sh; then
    /opt/Anaconda3-5.2.0-Linux-x86_64.sh
else echo "miniconda and anaconda install is all fail ..."
fi


