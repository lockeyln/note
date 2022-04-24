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
#### neofetch  
> 在终端中显示 Linux 系统信息

#### *git*
```
sudo apt install git
```

#### nodejs npm yam
##### *nodejs*
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
##### npm
#### pip
