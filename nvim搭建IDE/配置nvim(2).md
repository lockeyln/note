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

##### 输入法设置  
如果使用的是fcitx框架直接可以自己写一个函数让 neovim 在退出插入模式时切换到英文输入法。
打开 lua/basic/config.lua
```
-- 自动切换输入法（Fcitx 框架）
vim.g.FcitxToggleInput = function()
    local input_status = tonumber(vim.fn.system("fcitx-remote"))
    if input_status == 2 then
        vim.fn.system("fcitx-remote -c")
    end
end
​
vim.cmd("autocmd InsertLeave * call FcitxToggleInput()")
```
如果是 Windows 或者 Mac 平台，可以搜索 [im-select](https://github.com/daipeihust/im-select) 并安装配置。

##### ftplugin 配置
不同类型的文件有不同的缩进规则，比如在 Python 中缩进是 4 个空格，而在 Golang 中是 1 个 tab。  
基础设置时，在 lua/basic/settings.lua 中配置了这样的一个选项
```
-- 自动缩进的策略为 plugin
vim.o.filetype = "plugin"
```
接下来需要在 ~/.config/nvim/ftplugin 目录中新建不同语言的缩进规则文件  
然后根据语言的缩进规则来书写不同的内容，以 go.lua 为例：
```
-- 是否将 tab 替换为 space
vim.bo.expandtab = false
-- 换行或 >> << 缩进时的 space 数量    
vim.bo.shiftwidth = 4    
-- 一个 tab 占用几个 space    
vim.bo.tabstop = 4    
-- tab 和 space 的混合，和上面 2 个设置成相同即可    
vim.bo.softtabstop = 4   
```
同理，在 Lua 中的缩进规则是 4 个空格，那么 lua.lua 文件的内容就是下面这样：
```
vim.bo.expandtab = true                     
vim.bo.shiftwidth = 4
vim.bo.tabstop = 4                     
vim.bo.softtabstop = 4 
-- 取消自动注释，当前行是 -- 注释时，按下 CR 或者 o 默认会自动注释下一行，所以这里取消了
vim.opt_local.formatoptions = vim.opt_local.formatoptions - {"c", "r", "o"}
```
除此之外，我们也可以为不同语言设置不同的空格以及回车样式，但是要确保 lua/basic/settings.lua 中的 list 配置项是打开的：
```
-- 是否特殊显示空格等字符
vim.o.list = true
```
比如让 Golang 中的空格表现为 ⋅，回车表现为 ↴，那么就可以在 go.lua 中加入下面 2 行代码：
```
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")
```