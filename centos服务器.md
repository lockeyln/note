#### putty复制粘贴
```
复制： 选中内容，ctrl + 鼠标右键。
粘贴： ctrl + shift + insert 或 鼠标中键
```

#### dnf包管理器安装（取代yum）
```
yum install epel-release  # 安装DNF之前必须先安装并启用epel-release依赖
yum install dnf   # 使用 epel-release 依赖中的 YUM 命令来安装 DNF 包
```

#### 安装nginx
```
dnf -y install http://nginx.org/packages/centos/8/x86_64/RPMS/nginx-1.18.0-2.el8.ngx.x86_64.rpm
# 安装后记得放行防火墙端口
firewall-cmd --zone=public --add-port=80/tcp --permanent    #增加80端口
firewall-cmd --zone=public --add-port=3306/tcp --permanent    #增加3306端口，用于数据库
firewall-cmd --reload    #重载防火墙
firewall-cmd --query-port=80/tcp    #查看防火墙的80端口状态
```
```
出现firewallID is not running:
systemctl status firewalld     # 查看firewalld状态，发现当前是dead状态，即防火墙未开启。
systemctl start firewalld      # 开启防火墙，没有任何提示即开启成功。
```

#### 安装mariadb
```
dnf install -y mariadb-server

systemctl start mariadb # 启动
 
systemctl status mariadb # 查看状态
 
systemctl  enable  mariadb # 开机启动
  
mysqladmin -uroot  password  'yourpassword' # 设置root账号密码
或
mysql_secure_installation  # 设置root账号密码

mysql -uroot -p  # root账号登陆mysql

mysql -umysql -p -h ipaddress(远程服务器地址) -P 3306 # 远程计算机连接服务器数据库
```

#### 安装php
```
dnf install php

dnf install php php-curl php-dom php-exif php-fileinfo php-fpm php-gd php-hash php-json php-mbstring php-mysqli php-openssl php-pcre php-xml libsodium

```

#### 向服务器传输文件  
PuTTY安装目录下的pscp.exe文件拷贝到/Windows/System32/目录下，在cmd控制台执行命令
```
pscp -r 要传输的文件路径 ubuntu账户名@ubuntu服务器地址：文件在ubuntu服务器的存放位置
```
> pscp -r F:\BaiduNetdiskDownload\xxx root@服务器地址:/home/download