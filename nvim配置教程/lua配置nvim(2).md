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
##### 键位设置
```
-- leader 键设置为空格                                    
vim.g.mapleader = " "    
    
-- 默认的键位设置函数太长了，所以这里将它们重新引用一下
vim.keybinds = {    
    gmap = vim.api.nvim_set_keymap,    
    bmap = vim.api.nvim_buf_set_keymap,    
    dgmap = vim.api.nvim_del_keymap,    
    dbmap = vim.api.nvim_buf_del_keymap,    
    opts = {noremap = true, silent = true}    
}    
    
-- 插入模下 jj 退出插入模式    
vim.keybinds.gmap("i", "jj", "<Esc>", vim.keybinds.opts)    
    
-- 用 H 和 L 代替 ^ 与 $    
vim.keybinds.gmap("n", "H", "^", vim.keybinds.opts)    
vim.keybinds.gmap("v", "H", "^", vim.keybinds.opts)    
vim.keybinds.gmap("n", "L", "$", vim.keybinds.opts)    
vim.keybinds.gmap("v", "L", "$", vim.keybinds.opts)    
    
-- 将 C-u 和 C-d 调整为上下滑动 10 行而不是半页    
vim.keybinds.gmap("n", "<C-u>", "10k", vim.keybinds.opts)    
vim.keybinds.gmap("n", "<C-d>", "10j", vim.keybinds.opts)    
    
-- 插入模式下的上下左右移动    
vim.keybinds.gmap("i", "<A-k>", "<up>", vim.keybinds.opts)    
vim.keybinds.gmap("i", "<A-j>", "<down>", vim.keybinds.opts)    
vim.keybinds.gmap("i", "<A-h>", "<left>", vim.keybinds.opts)    
vim.keybinds.gmap("i", "<A-l>", "<right>", vim.keybinds.opts)    
    
-- 修改分屏大小    
vim.keybinds.gmap("n", "<C-up>", "<cmd>res +1<CR>", vim.keybinds.opts)    
vim.keybinds.gmap("n", "<C-down>", "<cmd>res -1<CR>", vim.keybinds.opts)    
vim.keybinds.gmap("n", "<C-left>", "<cmd>vertical resize-1<CR>", vim.keybinds.opts)    
vim.keybinds.gmap("n", "<C-right>", "<cmd>vertical resize+1<CR>", vim.keybinds.opts)    
    
-- 正常模式下按 ESC 取消高亮显示    
vim.keybinds.gmap("n", "<ESC>", ":nohlsearch<CR>", vim.keybinds.opts)    
    
-- 通过 leader cs 切换拼写检查    
vim.keybinds.gmap("n", "<leader>cs", "<cmd>set spell!<CR>", vim.keybinds.opts)   
```