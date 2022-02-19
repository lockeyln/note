#### 安装nginx
```
yum install -y nginx
# 安装后记得放行防火墙端口
firewall-cmd --zone=public --add-port=80/tcp --permanent    #增加80端口
firewall-cmd --zone=public --add-port=3306/tcp --permanent    #增加3306端口，用于数据库
firewall-cmd --reload    #重载防火墙
firewall-cmd --query-port=80/tcp    #查看防火墙的80端口状态
```
```
出现firewallID is not running:
systemctl status firewalld查看firewalld状态，发现当前是dead状态，即防火墙未开启。
systemctl start firewalld开启防火墙，没有任何提示即开启成功。
```

#### 安装mariadb
```
yum install -y mariadb-server

systemctl start mariadb # 启动
 
systemctl status mariadb # 查看状态
 
systemctl  enable  mariadb # 开机启动
  
mysqladmin -uroot  password  'yourpassword' # 设置root账号密码
mysql_secure_installation  # 设置root账号密码

mysql -uroot -p  # root账号登陆mysql

mysql -umysql -p -h ipaddress(远程服务器地址) -P 3306 # 远程计算机连接服务器数据库
```

#### 安装php
```

```