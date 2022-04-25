由于升级ubuntu 22.04 lts失败无法进系统，只能重装系统作此记录
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
