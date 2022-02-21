抄录于知乎用户askfiy的文章  
LSP 以及 DAP 的加持，目前 neovim 的编码体验已经不输于 vscode 了。
##### 配置步骤
- 基本配置
- 美化配置
- 编辑配置
- 功能配置
- LSP配置
- DAP配置
- 其他配置

##### 准备工作：外部依赖
- neovim（至少大于 0.5 版本）
- python3 以及 pip3
- gcc 以及 g++ （用于 nvim-treesitter 的依赖安装）
- nerd font（正确显示图标）
- node 以及 npm（用于 LSP 服务，可选）
- fd 以及 ripgrep （用于 telescope 模糊查找）
- sed （用于 nvim-spectre 的全局字符串替换）

##### 配置目录
```
├── init.lua                        # 配置入口文件
├── ftplugin/                       # 存放不同文件类型的缩进规则文件
├── lint/                           # 存放各种语言的代码检查规范配置文件，如 pylint 等
├── lua/
│   ├── basic/                      # 存放基本配置项文件
│   │   ├── config.lua              # 用户自定义配置的文件
│   │   ├── keybinds.lua            # 键位绑定的文件
│   │   ├── plugins.lua             # 依赖插件的文件
│   │   └── settings.lua            # neovim 基本配置项的文件
│   ├── conf/                       # 存放插件相关配置文件
│   ├── dap/                        # 存放 DAP 相关配置文件
│   └── lsp/                        # 存放 LSP 相关配置文件
└── snippet/                        # 存放代码片段相关文件
```
---
##### 安装neovim
```
下载
cd ~
wget https://github.com/neovim/neovim/releases/download/v0.6.1/nvim-linux64.tar.gz
安装
sudo tar -xvf ~/nvim-linux64.tar.gz -C /usr/local/
将 neovim 添加至环境变量
vi ~/.bashrc
export PATH=/usr/local/nvim-linux64/bin:$PATH
刷新配置
source ~/.bashrc
```
##### 创建目录
```
mkdir -p ~/.config/nvim/{ftplugin,lint,lua,snippet}
mkdir -p ~/.config/nvim/lua/{basic,conf,dap,lsp}
touch ~/.config/nvim/init.lua
touch ~/.config/nvim/lua/basic/config.lua
touch ~/.config/nvim/lua/basic/keybinds.lua
touch ~/.config/nvim/lua/basic/plugins.lua
touch ~/.config/nvim/lua/basic/settings.lua
```

##### init.lua
```
-- 加载配置项  
require("basic.settings")
require("basic.keybinds")
require("basic.config")
require("basic.plugins")
```
若想让 neovim 共享系统剪切板，还需要下载一个插件
> sudo apt install xsel

### 基础配置
#####  lua/basic/settings.lua 
```
-- 设定各种文本的字符编码
vim.o.encoding = "utf-8"
-- 设定在无操作时，交换文件刷写到磁盘的等待毫秒数（默认为 4000）
vim.o.updatetime = 100
-- 设定等待按键时长的毫秒数
vim.o.timeoutlen = 500
-- 是否在屏幕最后一行显示命令
vim.o.showcmd = true
-- 是否允许缓冲区未保存时就切换
vim.o.hidden = true
-- 是否开启 xterm 兼容的终端 24 位色彩支持
vim.o.termguicolors = true
-- 是否高亮当前文本行
vim.o.cursorline = true
-- 是否开启语法高亮
vim.o.syntax = "enable"
-- 是否显示绝对行号
vim.o.number = true
-- 是否显示相对行号
vim.o.relativenumber = true
-- 设定光标上下两侧最少保留的屏幕行数
vim.o.scrolloff = 10
-- 是否支持鼠标操作
vim.o.mouse = "a"
-- 是否启用系统剪切板
vim.o.clipboard = "unnamedplus"
-- 是否开启备份文件
vim.o.backup = false
-- 是否开启交换文件
vim.o.swapfile = false
-- 是否特殊显示空格等字符
vim.o.list = true
-- 是否开启自动缩进
vim.o.autoindent = true
-- 设定自动缩进的策略为 plugin
vim.o.filetype = "plugin"
-- 是否开启高亮搜索
vim.o.hlsearch = true
-- 是否在插入括号时短暂跳转到另一半括号上
vim.o.showmatch = true
-- 是否开启命令行补全
vim.o.wildmenu = true
-- 是否在搜索时忽略大小写
vim.o.ignorecase = true
-- 是否开启在搜索时如果有大写字母，则关闭忽略大小写的选项
vim.o.smartcase = true
-- 是否开启单词拼写检查
vim.o.spell = true
-- 设定单词拼写检查的语言
vim.o.spelllang = "en_us,cjk"
-- 是否开启代码折叠
vim.o.foldenable = true
-- 指定代码折叠的策略是按照缩进进行的
vim.o.foldmethod = "indent"
-- 指定代码折叠的最高层级为 100
vim.o.foldlevel = 100
```
