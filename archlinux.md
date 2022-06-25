### win10安装双系统

### [使用 Git Repo 方式管理 dotfiles](http://dotfiles.github.io/)
#### 初始化
1. 创建 Git Bare Repository 

这将是您的点文件受版本控制的地方。 一个纯仓库只是包含Git对象并没有跟踪文件的存储库。 它们通常 .git 位于常规存储库中，但仅此而已。 当创建仅用于存储的存储库时，请 使用nude 。
```
git init --bare $HOME/.dotfiles
```

2. 创建 alias，方便执行操作

```
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME' 
echo "alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.bashrc
```  
该别名将创建一个 dot 命令别名（您可以根据需要命名）， 该别名将以 /usr/bin/git 某种方式 调用 并将其存储在 ~/.bashrc 文件中，因此每次打开Bash时都会被加载。  
- --git-dir=$HOME/.dotfiles/ ：无论您在何处调用该命令，它都将始终指向该特定目录。
- --work-tree=$HOME ：它将始终与该特定目录中的文件一起使用。  
因此，我们将版本控制文件的存储指向 $HOME/.dotfiles 该文件 ， 并且它所跟踪的文件将 $HOME 位于其中（因为所有dotfile都位于该文件中）。  

3. 不显示工作区（$HOME）未跟踪的文件 

因为我们不会提交其中的所有文件，所以 $HOME 我们不希望它显示未跟踪的文件。 这不是必须的，只是因为我们在运行时没有可见的所有未跟踪文件 dot status  
```
dot config --local status.showUntrackedFiles no
```
获取未跟踪文件的列表  
```
dot status --untracked-files=normal
```
#### 使用
1. 添加提交
```
dot add .gitconfig
dot commit -m Add .gitconfig
dot add .vimrc
dot commit -m Add .vimrc
dot add .bashrc
dot commit -m Add .bashrc
```
2. 配置远程仓库  
```
dot remote add origin git@github.com:username/reponame.git
```
3. 推送 commit 到远程仓库，同时将远程仓库与本地的 master 分支关联
- 关联以后，推送 commit 就只需要输入 dot push
```
dot push -u origin master
```  
有可能出现 ssh: connect to host github.com port 22: Connection refused 问题
.ssh 目录下创建 config 文件，编辑内容为  

```
Host github.com
Hostname ssh.github.com
Port 443
```
#### 在新系统上恢复 Dotfiles  
```
git clone --bare git@github.com:username/reponame.git $HOME/.dot
alias dot="git --git-dir=$HOME/.dot --work-tree=$HOME"
dot config --local status.showUntrackedFiles no
```  
这一步可能会提示 「error: The following untracked working tree files would be overwritten by checkout:」，  
按照 git 的说明移动或删除这些文件就行dot checkout
