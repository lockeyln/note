#### 查看磁盘空间：df -h(disk free)

#### PPA:Personal Package Archives(个人软件包文档)

> 虽然Ubuntu官方软件仓库尽可能囊括所有的开源软件，但仍有很多软件包由于各种原因不能进入官方软件仓库。<br>
 为了方便Ubuntu用户使用，[launchpad.net](https://launchpad.net/)提供了个人软件包集，即`PPA`，<br>
允许用户建立自己的软件仓库，通过Launchpad进行编译并发布为2进制软件包，作为`apt源供其他用户下载和更新

#### 添加PPA命令
> add-apt-repository ppa:<ppa_name> <br>
  sudo add-apt-repository ppa:user/ppa-name

#### 删除PPA源
> cd /etc/apt/sources.list.d <br>
  sudo rm ppa名

#### vim调用系统剪贴板
> 插入模式下shift+insert

#### ifconfig命令找不到
> apt install net-tools

#### git同步gitee
1. 配置git
> git config --global user.name "用户名" <br>
  git config --global  user.email "邮件"

2. 生成公钥
> ssh-keygen -t rsa -C "your email"

3. gitee添加公钥

4. 测试是否成功
> ssh -T git@gitee.com

5. 初始化本地库
> ​cd 项目文件夹  <br>
  git init  //初始化本地项目 <br>
​  git remote add origin <远程仓库地址> //添加远程仓库地址

6. 更新到远程仓库
> git add .    //指定更新内容    . 表示全部更新，test.txt 表示更新指定文件 <br>
  git commit -m "更新说明"       //添加提交更新说明 <br>
  git push origin master        //执行更新操作

#### 修改git配置
> 使用 git config -e --global

#### Yarn

> Yarn是由Facebook、Google、Exponent 和 Tilde 联合推出了一个新的JS包管理工具 ，Yarn是为了弥补npm 的一些缺陷而出现的。


#### PGP
> PGP（Pretty Good Privacy）就是这样一个用来帮助提高安全性的技术。PGP最常用来给电子邮件进行加密、解密以及提供签名，以提高电子邮件交流的安全性。

#### GPG
> GnuPG（简称GPG）是PGP标准的一个免费实现，无论是类UNIX平台还是Windows平台，都可以使用他。GPG能够帮助我们为文件生成签名、管理密码以及验证签名等。<br>
  加密的一个简单但又实用的任务就是发送加密电子邮件。多年来，为电子邮件进行加密的标准一直是PGP（Pretty Good Privacy）。<br>
  程序员Phil Zimmermann特别为电子邮件的保密编写的PGP。它是商业软件，不能自由使用。<br>
  作为PGP的替代，如今已经有一个开放源代码的类似产品可供使用。GPG（Gnu Privacy Guard），它不包含专利算法，能够无限制的用于商业应用。<br>
  ubuntu 20.04默认安装GPG



#### 浏览器能访问github，nvim下载不了插件

> git config --global http.sslverify false <br>
  git config --global https.sslverify false

#### which 命令
> 查看该命令的可执行文件的位置

#### 三种删除软件方式
1. remove  卸载软件包，删除软件包而保留软件的配置文件 
2. autoremove   卸载所有自动安装且不再使用的软件包（连带依赖包一起删）
3. purge   卸载并清除软件包的配置


#### 字体安装
> 字体安装目录 /usr/share/fonts  <br>
cd /usr/share/fonts/ #字体存放目录 <br>
sudo mkfontscale # 生成核心字体信息 <br>
sudo mkfontdir # 生成字体文件夹 <br>
sudo fc-cache -fv # 刷新系统字体缓存 <br>
