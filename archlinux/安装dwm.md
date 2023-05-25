### 安装和启动

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

sudo pacman -S archlinux-wallpaper #下载一个壁纸包(可选)下载的壁纸在/usr/share/backgrounds/archlinux/
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

3. 设置dwm启动项

/usr/share/xsessions目录下新建dwm.desktop

```
[Desktop Entry]
Encoding=UTF-8
Name=dwm
Comment=Dynamic Window Manager
Exec=/usr/local/bin/dwm
Icon=
Type=Application
```
4. 配置xinintrc  

- 将默认配置copy至家目录  

```
cp /etc/X11/xinit/xinitrc ~/.xinitrc
```

- 修改xinitrc配置  

```
#注释掉最后5行，并添加exec dwm
#twm &
#xclock -geometry 50x50-1+1 &
#xterm -geometry 80x50+494+51 &
#xterm -geometry 80x20+494-0 &
#exec xterm -geometry 80x66+0+0 -name login

#xrandr修改屏幕分辨率
xrandr --output 显示器接口名 --mode 1920x1080 --rate 60.00 
#设置桌面壁纸
feh --bg-fill --randomize /usr/share/backgrounds/archlinux/* 
#启动dwm
exec dwm 
```

退出当前用户登录状态来到登录界面。左下角(其他发行版可能在其他位置)出现了选项，选择dwm后输入密码登录。

---

### 认识dwm

```
    +------+----------------------------------+--------+
    | tags | title                            | status +
    +------+---------------------+------------+--------+
    |                            |                     |
    |                            |                     |
    |                            |                     |
    |                            |                     |
    |          master            |        stack        |
    |                            |                     |
    |                            |                     |
    |                            |                     |
    |                            |                     |
    +----------------------------+---------------------+
```

dwm的区域分为如上几块，上面是状态栏，包括tags、title以及status；屏幕主要区域分为master与stack区域新打开的窗口会占据master，
之前的窗口以栈的方式上下排列在stack区。

**dwm环境下的快捷键**

| Keybinding | Action |
| --- | --- |
| SHIFT+ALT+ENTER | 打开st |
| SHIFT+ALT+q | 退出dwm，回到login manager |
| ALT+p | 打开dmenu，之后可以输入软件名比如firefox来启动软件 |
| ALT+j/k | 切换打开的多个window |
| SHIFT+ALT+n(1-9) | 移动当前window至tag n(默认9个tags) |
| SHIFT+ALT+c | 关闭当前window |
| ALT+ENTER | 切换某当前window为master window |
| ALT+m/t | 切换当前window为全屏/切换回来 |
| ALT+n(1-9) | 进入tag n |
| CTRL+SHIFT+PageUp/PageDown | 放大/缩小字号 |
| ALT+b| toggle status bar |

### 其他设置  

dwm下鼠标几乎变得没有作用，在桌面环境中的点击音量按钮调节系统音量等操作变得不再可行，
geek们的做法是使用命令行工具，下面是一些具体场景下的一种可行操作方式。

#### 浏览图片

命令行安装sxiv（Simple X Image Viewer），进入图片所在文件夹，输入：sxiv *，可以使用鼠标点击左右切换当前展示图片。

#### 设置壁纸   

命令行安装xwallpaper，确定希望设置的图片路径，比如~/.config/wall.png  

```
xwallpaper --zoom ~/.config/wall.png
或  
feh --bg-fill --randomize /usr/share/backgrounds/archlinux/*
```  

#### 修改分辨率

1. 查看可用的显示器接口名和屏幕分辨率  

```
xrandr -q
```

**注意：如果使用xrandr -q查看的结果中没有符合自己显示的分辨率就需要自己创建一个**  

```
# 创建一个分辨率
命令：cvt 1920 1080 60
回显：xrandr --newmode ....
# 用xrandr将回显添加到显示器上
xrandr --addmode 显示器名称 "1920x1080_60.00"
# 修改分辨率
xrandr --output 显示器名称 --mode '分辨率'
```

2. 设置分辨率  

```
xrandr --output 显示器接口名 --mode 1920x1080 --rate 60.00
```

3. 写入xinitrc配置

#### 音量调节  

命令行安装pulseaudio，下列命令是几种对音量可能会做的操作：  

| Command | Action |
| --- | --- |
| pactl set-sink-volume 0 +20% | 音量增加20% |
| pactl set-sink-volume 0 -20% | 音量减少20% |
| pactl set-sink-mute 0 toggle | 静音切换 |
| pactl get-sink-volume 0 | 获取当前音量值 |  

#### 截图 

命令行安装scrot，打开dmenu输入scrotv即可对当前桌面截图保存在当前文件夹。

若想截图特定窗口，可以加-s参数后用鼠标点击想要的窗口。其他具体指令的使用说明见scrot文档。  

#### 简单配置st

st的实现只有2000多行C代码，自身的功能非常有限，以至于各种用户“习以为常”的能力它都没有，包括复制/粘贴、滚动等功能都是默认不支持的，毕竟"simple"。  

**suckless的软件不提供配置文件，所有配置项均在其源码config.def.h中，修改后需要运行sudo cp config.def.h config.h && sudo make clean install重新编译安装。**  

在~/st/config.def.h的ShortCut中新增两行：  

```
{ MODKEY, XK_c, clipcopy,  {.i=0}},
{ MODKEY, XK_v, clippaste, {.i=0}},
```
重新安装，即可以在st中使用SHIFT+CTRL+c/v来实现复制/粘贴功能。

#### emoji

st自然也不支持emoji的显示，比如ohmyarch的README.md中有🤣，运行cat README.md会导致st直接crash掉，这里需要一个特定的依赖来解决此问题：  

```
yay -S libxft-bgra
```

#### 透明化

设置了漂亮的壁纸后将终端做一定程度的透明化是一种视觉上的享受。

命令行安装picom，配置文件写于~/.config/picom/picom.conf  

```
opacity-rule = [
"90:class_g = 'st-256color'"
];
wintypes:
{
normal = { blur-background = true; };
splash = { blur-background = false; };
};
# Fading
fading = false;
fade-in-step = 0.07;
fade-out-step = 0.07;
```
然而st自身的源码不支持透明显示，suckless提供了一些patches来增强它的功能，类似于其他软件中的插件。    

复制alpha patch diff至st源码目录内，运行patch < st-alpha-0.8.2.diff后依然是重新编译安装。然后运行picom -b即可实现透明效果。  

除了alpha外，suckless还提供了其他许多的[patches](https://st.suckless.org/patches/)来扩充功能。  

#### dmenu的想象力

在path下的可执行文件均可被dmenu找到并运行，用户可以自行编写shell脚本置于/usr/local/bin文件夹下由dmenu执行。  

比如实现一个关机/重启选项的简单例子：  

```
choices="shutdown\nreboot"

chosen=$(echo -e "$choices" | dmenu -i -p "Operation:")

case "$chosen" in
    shutdown) shutdown;;
    reboot) reboot;;
esac
```
将该文件保存为sysop.sh置于PATH路径中，即可在dmenu中选择sysop这个选项并进行下一步选择。
这个脚本本身没有太多实际意义，然而有了这样的机制，其实可以实现非常非常多的功能，比如调节音量、浏览切换壁纸、快速打开浏览器标签页等等，笔者认为其定制能力与想象力要比MacOS下的Alfred要更为丰富。

#### dwm状态栏 

默认的dwm状态栏非常朴素，status部分只显示了dwm-6.2，“没毛病老哥”们提供了一个基础的改变status显示内容的机制，比如想要把dwm-6.2改变为hello world那么需要运行：  

```
xsetroot -name "hello world"
```

suckless官网列出了一些他人配置好的[dwm状态栏列表](https://dwm.suckless.org/status_monitor/)，可以参考选用。   

### 其他用户的配置参考

- [ohmyarch](https://github.com/guerbai/ohmyarch)
- [DistroTube](https://gitlab.com/users/dwt1/projects)
- [Luke Smith](https://github.com/LukeSmithxyz)
- [TheNiceBoy](https://github.com/theniceboy)
