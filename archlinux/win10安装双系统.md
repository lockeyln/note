### win10安装双系统
1. 利用iwctl进行无线网络
2. 利用fdisk或cfdisk分区，mkfs格式化，mkdir创建目录,mount分区挂载到目录(如果双系统将原系统efi挂载到/mnt/boot)
3. 选择镜像源
4. 安装基本系统
5. 生成fstab文件
6. 切换新系统：arch-chroot /mnt
7. 设置时间和区域
8. 设置系统语言 生成本地语言信息
9. 写入hostname
10. 修改hosts
11. passwd
12. 安装基本软件
13. 安装微指令
14. 安装多重引导启动器 grub，部署 grub
