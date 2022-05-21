由于升级ubuntu 22.04 lts失败无法进系统，只能重装系统作此记录  

[TOC]

## 分区方案(只有swap和/是必须分区的)
| 分区名 | 分区类型 | 用于 | 挂载点 | 大小 |
| -- | ---- | -- | ---- | ---- |
| efi(efi分区) | 主分区 | Ext4日志文件系统 | /efi | 1G |
| boot(引导分区) | 主分区 | Ext4日志文件系统 | /boot | 1G |
| swap(交换分区) | 逻辑分区 | 交换空间 | 无 | 内存大小 |
| /(根目录) | 主分区 | Ext4日志文件系统 | / | 40G |
| home | 主分区 | Ext4日志文件系统 | /home |100G |
| usr | 逻辑分区  | Ext4日志文件系统 | /usr |50G |

## 软件篇
| 工具名 | 功能 | 
| -- | ---- | 
| git | 版本控制 |
| curl | 通过url传输数据　|
| Qv2ray | 科学上网 |
| kitty | 终端仿真器 |

#### neofetch  
> 在终端中显示 Linux 系统信息


#### nodejs npm yarn
1.将二进制存档解压缩到您要安装 Node 的任何目录，我使用/usr/local/lib/nodejs
```
下载tar.xz格式nodejs
sudo mkdir -p /usr/local/lib/nodejs
sudo tar -xJvf node-$VERSION-$DISTRO.tar.xz -C /usr/local/lib/nodejs
```
２. 设置环境变量 
```
打开~/.bashrc添加行
export PATH=/usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin:$PATH
```
3. 使生效
```
source .bashrc
```
##### 安装yarn  
启用 Yarn 官方软件源，导入 GPG key，并且安装软件包
```
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
```

#### pip3
```
sudo apt install python3-pip
```
---
#### nvim
> appimage格式需要FUSE(Filesystem in Userspace用户态文件系统)　　　
##### 安装fuse　
```
sudo apt install fuse libfuse2
sudo modprobe fuse
sudo groupadd fuse
```
##### 如果不想安装 FUSE，可以挂载或提取AppImage的方法运行
1. 提取
```
要提取 AppImage 的内容，只需使用--appimage-extract
````
2. 挂载
```
sudo mount -o loop Some.AppImage /mnt
/mnt/AppRun
```
---
#### kitty终端
[kitty配置主页](https://sw.kovidgoyal.net/kitty/conf/#)
| 按键 | 功能 | 
| -- | ---- | 
| ctrl+shift+f2 | 打开配置文件 |
| Ctrl+Shift+(-/+) | 调整大小 |

---
[章鱼猫](https://octodex.github.com/)  

[Linux工具快速教程](https://linuxtools-rst.readthedocs.io/zh_CN/latest/)

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
sudo mkfontscale # 生成核心字体信息，用来控制字体旋转缩放 <br>
sudo mkfontdir # 生成字体文件夹，用来控制字体粗斜体产生 <br>
sudo fc-cache -fv # 刷新系统字体缓存，让系统认识认识该字体 <br>


#### appimage
> AppImage的核心思想是一个应用程序 = 一个文件 。每个AppImage都包含应用程序以及应用程序运行所需的所有文件。  
换句话说，除了操作系统本身的基础组件，Appimage不需要依赖包即可运行。

#### ./ 和 . 之间有什么区别
.  表示执行的意思，就是执行这个文件  
./ 表示执行当前目录下的某个文件，就比如当前目录有一个脚本a.sh，那么./a.sh就表示执行它  
.  当前工作目录  
./ 也是当前工作目录，不过一般这种写法后面都跟一个脚本文件 用来执行脚本
> 把程序复制、移动或链接到/bin/或/usr/bin/下才可以运行，因为参数默认从pwd下找，但运行的程序只会在PATH中找，并不包括当前目录，所以要用./

#### 终端提示xx个软件包未被升级解决办法
> sudo apt dist-upgrade

#### 安装alacritty
1. 安装rust 
```
curl https://sh.rustup.rs -sSf | sh   
```
2. 安装依赖 
```
sudo apt install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
```
3. 下载源代码 
```
git clone https://github.com/alacritty/alacritty.git
cd alacritty
cargo build --release
```
4. 创建Desktop Entry
```
sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database
```
5. 安装手册页
```
sudo mkdir -p /usr/local/share/man/man1
gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
gzip -c extra/alacritty-msg.man | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null
```
6. 对于zsh
```
mkdir -p ${ZDOTDIR:-~}/.zsh_functions
echo 'fpath+=${ZDOTDIR:-~}/.zsh_functions' >> ${ZDOTDIR:-~}/.zshrc

cp extra/completions/_alacritty ${ZDOTDIR:-~}/.zsh_functions/_alacritty
```
---

#### 安装fcitx5
- 最小安装  
为使用 Fcitx 5，需要安装三部分基本内容：  
1. Fcitx 5 主程序
2. 中文输入法引擎
3. 图形界面相关
```
sudo apt install fcitx5 \
fcitx5-chinese-addons \
fcitx5-frontend-gtk3 fcitx5-frontend-gtk2 \
fcitx5-frontend-qt5 kde-config-fcitx5
```
- 安装中文词库
在 GitHub 打开 [维基百科中文拼音词库](https://github.com/felixonmars/fcitx5-pinyin-zhwiki) 的 [Releases](https://github.com/felixonmars/fcitx5-pinyin-zhwiki/releases) 界面，下载最新版的 .dict 文件。按照 README 的指导，将其复制到 ~/.local/share/fcitx5/pinyin/dictionaries/ 文件夹下即可。
```
# 下载词库文件
wget https://github.com/felixonmars/fcitx5-pinyin-zhwiki/releases/download/0.2.4/zhwiki-20220416.dict
# 创建存储目录
mkdir ~/.local/share/fcitx5/pinyin/dictionaries/
# 移动词库文件至该目录
mv zhwiki-20220416.dict ~/.local/share/fcitx5/pinyin/dictionaries/
```
- 配置  
设置为默认输入法  
> 使用 im-config 工具可以配置首选输入法，在任意命令行输入：  im-config

- 环境变量
需要为桌面会话设置环境变量，即将以下配置项写入某一配置文件中：  
```
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
```
如果使用 Bash 作为 shell，则建议写入至 ~/.bash_profile ，这样只对当前用户生效，而不影响其他用户。另一个可以写入此配置的文件为系统级的 /etc/profile 。  

- 开机自启动

安装 Fcitx 5 后并没有自动添加到开机自启动中，每次开机后需要手动在应用程序中找到并启动，非常繁琐。  
解决方案非常简单，在 Tweaks（sudo apt install gnome-tweaks）中将 Fcitx 5 添加到「开机启动程序」列表中即可。

- Fcitx 配置
Fcitx 5 提供了一个基于 Qt 的强大易用的 GUI 配置工具，可以对输入法功能进行配置。有多种启动该配置工具的方法：  
1. 在应用程序列表中打开「Fcitx 配置」
2. 在 Fcitx 托盘上右键打开「设置」
3. 命令行命令 fcitx5-configtool  
根据个人偏好进行设置即可。需要注意的是「输入法」标签页下，应将「键盘 - 英语」放在首位，拼音（或其他中文输入法）放在后面的位置。  

- 自定义主题
Fcitx 5 默认的外观比较朴素，用户可以根据喜好使用自定义主题。  
第一种方式为使用 [经典用户界面](https://fcitx-im.org/wiki/Theme_Customization/zh-cn#%E7%BB%8F%E5%85%B8%E7%94%A8%E6%88%B7%E7%95%8C%E9%9D%A2),可以在 [gitHub 搜索主题](https://github.com/search?q=fcitx5+theme&type=Repositories) 然后在 Fcitx5 configtool —— 「附加组件」 —— 「经典用户界面」中设置即可。  

第二种方式为使用 [Kim面板](https://fcitx-im.org/wiki/Theme_Customization/zh-cn#kim%E9%9D%A2%E6%9D%BF)，一种基于 DBus 接口的用户界面。此处安装了 [Input Method Panel](https://extensions.gnome.org/extension/261/kimpanel/) 这个 GNOME 扩展，黑色的风格与正在使用的 GNOME 主题 Orchis-dark 非常搭配。  
![效果图](https://pic2.zhimg.com/v2-e1b24f4d83cd0be5da2a6a9d69f042f5_r.jpg)  

- 卸载 iBus 影响 Fcitx 5 正常使用
> sudo apt remove ibus  

卸载了 iBus，但重启（使生效）之后发现 Fcitx 5 受到了影响。具体表现为：除在终端中之外，其他输入场景无法切换至中文输入。使用 apt 装回 iBus，再次重启即又恢复正常。  
检查包依赖关系，卸载 ibus 包后会自动移除 ibus-data、ibus-gtk4、python3-ibus-1.0 三个包，似乎都只是与 iBus 紧密联系的。暂为不解之谜。
