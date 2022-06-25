### win10安装双系统

### [使用 Git Repo 方式管理 dotfiles](http://dotfiles.github.io/)
1. 创建一个裸git仓库（bare repo）  

这将是您的点文件受版本控制的地方。 一个纯仓库只是包含Git对象并没有跟踪文件的存储库。 它们通常 .git 位于常规存储库中，但仅此而已。 当创建仅用于存储的存储库时，请 使用nude 。
```
git init --bare $HOME/.dotfiles
```

2. 创建一个别名来管理您的点文件

```
echo alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME' >> ~/.bashrc
```  
该别名将创建一个 dot 命令别名（您可以根据需要命名）， 该别名将以 /usr/bin/git 某种方式 调用 并将其存储在 ~/.bashrc 文件中，因此每次打开Bash时都会被加载。  
- --git-dir=$HOME/.dotfiles/ ：无论您在何处调用该命令，它都将始终指向该特定目录。
- --work-tree=$HOME ：它将始终与该特定目录中的文件一起使用。  
因此，我们将版本控制文件的存储指向 $HOME/.dotfiles 该文件 ， 并且它所跟踪的文件将 $HOME 位于其中（因为所有dotfile都位于该文件中）。  

3. 隐藏未跟踪的文件  

因为我们不会提交其中的所有文件，所以 $HOME 我们不希望它显示未跟踪的文件。 这不是必须的，只是因为我们在运行时没有可见的所有未跟踪文件 dot status  
```
dot config --local status.showUntrackedFiles no
```
