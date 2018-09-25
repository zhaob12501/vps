# 开始建站

```python
# 创建虚拟环境
conda create -n ss python=3.6 -y

# 运行虚拟环境
. activate ss

# 更新pip
pip install --upgrade pip

# 安装 mysqlclient
pip install mysqlclient

git clone -b master https://github.com/Ehco1996/django-sspanel.git

cd django-sspanel

pwd

# 安装缺少的依赖
pip install raven pendulum django_bulk_update