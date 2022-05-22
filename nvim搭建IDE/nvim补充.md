#### 必备依赖
- [neovim](https://github.com/neovim/neovim) > 0.7 ：主角就是它
- [nerd font](https://www.nerdfonts.com/) ： 让 neovim 能够显示字体图标，需要额外配置终端显示字体，请自行 Google
- [node](https://nodejs.org/en/) ： 快速下载 LSP 服务器必备的工具
- [npm](https://www.npmjs.com/) ： 同上 ..  

#### 可选依赖( Manjaro Linux，通过 yay 可以下载到下面的依赖项)
```
-- neovim 与系统剪切板交互的必要插件
$ yay -S xsel
​
-- 语法树解析
$ yay -S tree-sitter
​
-- 模糊查找
$ yay -S fd
$ yay -S repgrep
​
-- Lua 代码格式化
$ yay -S stylua
```

#### 目录结构
```
$ tree ~/.config/nvim
.
├── ftplugin                      -- 目录，存放不同文件类型的差异化配置文件
├── snippets                      -- 目录，存放用户自定义的代码片段文件
├── lua                           -- 目录，neovim 配置主目录
│   ├── configure                 -- 目录，neovim 主配置目录
│   │   ├── dap                   -- 目录，存放 DAP 配置文件
│   │   ├── lsp                   -- 目录，存放 LSP 配置文件
│   │   ├── plugins               -- 目录，存放各个插件的配置文件
│   │   └── theme                 -- 目录，存放主题插件的定制化高亮文件
│   ├── core                      -- 目录，neovim 核心配置存放目录
│   │   ├── after                 -- 目录，存放辅助性功能运行文件
│   │   │   └── init.lua          -- 文件，after 模块的入口文件
│   │   ├── mapping.lua           -- 文件，用户自定制按键映射配置文件
│   │   ├── options.lua           -- 文件，用户自定制个性化配置文件
│   │   ├── plugins.lua           -- 文件，项目依赖插件主配置文件
│   │   └── setting.lua           -- 文件，neovim 预设配置文件
│   └── utils                     -- 目录，存放项目公用辅助性功能文件
│       ├── api                   -- 目录，存放用户自定义功能性函数文件
│       └── icons.lua             -- 文件，存放用户自定义图标
└── init.lua                      -- 文件，neovim 配置入口文件
```

#### 插件管理器packer
**简介**
packer 是一款由 Lua 语言编写的 neovim 插件管理器。

它最大的优点是支持结构化配置，能够以非常简单的办法实现延迟加载。

你可以 [主页](https://github.com/wbthomason/packer.nvim) 访问 packer 的 github 获得更多信息。  

**使用**  
> git clone --depth 1 https://github.com/wbthomason/packer.nvim\  
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim  
 
```
return require("packer").startup(function()
    -- 第一个插件
    use "wbthomason/packer.nvim"
​
    -- 第二个插件
    use {
            "askfiy/nvim-picgo",   -- 插件地址
            as = "picgo",          -- 给插件取别名
            opt = true,            -- 是否可选
            cmd = {"UploadImage"}, -- 执行以下命令时才会加载插件
            setup = function()     -- 插件加载前执行的代码
                print("before ..")
            end,
            config = function()    -- 插件加载完成后执行的代码
                print("load ..")
            end
    }
​
    -- 第三个插件
    use {
         "nvim-treesitter/nvim-treesitter",
         run = ":TSUpdate", -- 插件下载或更新后自动运行的代码
         commit = "96cdf2937491fbc", -- 使用体定提交记录的插件
    }
end)
```
##### 延迟加载  
packer 支持延迟加载插件，所谓延迟加载就是在特定的情况下才加载该插件。

这意味着使用 packer 管理 neovim 插件时，neovim 并不会因为插件数量的增多而变得臃肿不堪。

下面是一些延迟加载的例子，多个延迟加载的条件可以组合在一起，只有所有条件满足时才加载该插件：  

```
 use {
       "askfiy/test-plugin",
       -- 当 plugin1 和 plugin2 加载完成后才加载该插件
       after = {"plugin1", "plugin2"},
       -- 运行 :Test1 或 :Test2 时才加载该插件
       cmd = {"Test1", "Test2"},
       -- 打开 python 文件或 lua 文件时加载该插件
       ft = {"python", "lua"},
       -- 按下以下任意一个按键时才加载该插件
       keys = {"<leader>pt", "<leader>pr"},
       -- 当以下任意一个事件被触发时才加载该插件
       event = {"BufEnter" },
       -- 当执行以下任意一个函数时才加载该插件
       fn = {"test#fn1", "test#fn2"},
       -- 当使用 require 加载以下任意模块时才加载该插件
       module = {"test-plugin"},
    }
```
