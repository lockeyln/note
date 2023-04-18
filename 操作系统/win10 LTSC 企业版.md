### 安装微软商店
> wsreset -i

### 安装neovim
1. 下载和安装Neovim
可以从官方网站上下载最新版本的Neovim，并按照安装程序的提示进行安装。安装完成后，Neovim会默认安装到 C:\Program Files\Neovim 目录下。
或者使用以下命令
> winget install Neovim.Neovim

2. 配置环境变量
在开始配置之前，你需要将Neovim添加到系统环境变量中，以便可以在任何位置打开Neovim。为此，请按以下步骤操作：

- 打开Windows 10的“控制面板”
- 选择“系统和安全”
- 点击“系统”，然后点击“高级系统设置”
- 在弹出的窗口中，选择“环境变量”
- 在“系统变量”下方，点击“新建”
- 在“变量名”中输入“NVIM_HOME”，在“变量值”中输入Neovim的安装路径，例如“C:\Program Files\Neovim”
- 在“系统变量”中找到“Path”，点击“编辑”
- 在弹出的窗口中，点击“新建”，输入“%NVIM_HOME%”，然后点击“确定”保存更改。
