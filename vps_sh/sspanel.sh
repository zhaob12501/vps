#!/bin/bash

conda create -n ss python=3.6 -y

source ~/.bashrc

source activate ss

pip install --upgrade pip

pip install mysqlclient

git clone -b master https://github.com/Ehco1996/django-sspanel.git

cd django-sspanel

pwd
