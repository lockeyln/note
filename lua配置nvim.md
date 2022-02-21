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