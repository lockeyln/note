窗口管理器是管理桌面上各种窗口的组件，主要功能有：窗口堆叠方式，窗口移动规则等。多数人接触到的是堆叠式窗口管理器，一个窗口可以叠放在其他窗口之上，调整窗口的主要方式是鼠标。
而dwm（Dynamic Window Manager）是suckless开发的一个动态窗口管理器，可以自定义不同窗口的出现规则如平铺或者堆叠，它调整窗口的主要方式是键盘。  

dwm也必须有最基本的软件支撑，推荐安装下面的软件：

| 软件名称 | 软件说明 |
| --- | --- |
| dwm | 动态窗口管理器，suckless开发 |
| demu | 应用程序选择器，suckless开发 |
| st | 终端模拟器，suckless开发 |
| feh | 壁纸设置程序 |
| pcmanfm | 文件管理系统 |
| fcitx5 | 	输入法 |

1. 安装xorg协议及必要软件

```
sudo pacman -S xorg xorg-xinit 
sudo pacman -S feh udisks2 udiskie pcmanfm git
systemctl enable udisks2   #自动启动udisks2服务，可以使得文件管理系统(pcmanfm)能够自动识别U盘
```

2. 安装dwm，st，dmenu

```
mkdir ~/suckless
cd ~/suckless
git clone https://git.suckless.com/dmenu
git clone https://git.suckless.com/st
git clone https://git.suckless.com/dwm
```

suckless软件的一个特点是只提供源码，需要用户自己使用编译安装。某些更轻量级的发行版可能会没有make命令，需要先手动安装相关依赖。  

```
cd ~/suckless/st
sudo make clean install

cd ~/suckless/dmenu
sudo make clean install

cd ~/suckless/dwm
sudo make clean install
```
**st是dwm环境下的默认终端，dmenu是dwm下的程序启动器，进入dwm之前需要先安装st或dmenu，否则会在dwm中寸步难行。**

打开终端输入dwm启动。会遭遇dwm: another window manager is already running  

这是由于当前处在KDE的wm已经在运行，无法打开dwm。这里需要为dwm编写启动选项，使得在登录时(login manager，Linux的一个软件)启动dwm而不启动KDE桌面环境。

**/usr/share/xsessions目录下新建dwm.desktop

```
[Desktop Entry]
Encoding=UTF-8
Name=dwm
Comment=Dynamic Window Manager
Exec=/usr/local/bin/dwm
Icon=
Type=Application
```

退出当前用户登录状态来到登录界面。左下角(其他发行版可能在其他位置)出现了选项，选择dwm后输入密码登录。
