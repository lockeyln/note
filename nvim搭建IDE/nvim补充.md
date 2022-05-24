#### 必备依赖
- [neovim](https://github.com/neovim/neovim) > 0.7 ：主角就是它
- [nerd font](https://www.nerdfonts.com/) ： 让 neovim 能够显示字体图标，需要额外配置终端显示字体，请自行 Google
- [node](https://nodejs.org/en/) ： 快速下载 LSP 服务器必备的工具
- [npm](https://www.npmjs.com/) ： 同上 ..  

#### 可选依赖( Manjaro Linux，通过 yay 可以下载到下面的依赖项)
```
-- neovim 与系统剪切板交互的必要插件
$ yay -S xsel

-- 语法树解析
$ yay -S tree-sitter

-- 模糊查找
$ yay -S fd
$ yay -S repgrep

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
##### 自动加载配置文件
packer 对每一个插件的加载都提供了 2 个 hooks，分别是 setup 和 config。

它们可以是函数：

```
use {
    "askfiy/test-plugin",
    setup = function()
        print("before ..")
        require("configure/plugins/nv_test-plugin").before()
    end,
    config = function()
        print("load ..")
        require("configure/plugins/nv_test-plugin").load()
    end
}
```

也可以是字符串：  

```
use {
    "askfiy/test-plugin",
    setup = "require('configure/plugins/nv_test-plugin').before()",
    config = "require('configure/plugins/nv_test-plugin').load()"
}
```

当插件很多时，你可能会看到下面这样的情形：
```
use {
    "askfiy/test-plugin1",
    setup = "require('configure/plugins/nv_test-plugin1').before()",
    config = "require('configure/plugins/nv_test-plugin1').load()"
}

use {
    "askfiy/test-plugin2",
    setup = "require('configure/plugins/nv_test-plugin2').before()",
    config = "require('configure/plugins/nv_test-plugin2').load()"
}

use {
    "askfiy/test-plugin3",
    setup = "require('configure/plugins/nv_test-plugin3').before()",
    config = "require('configure/plugins/nv_test-plugin3').load()"
}
```

##### Packer 的封装
每一个插件都需要使用 use，这很麻烦。我们可以对 packer 做一些封装。

伪代码如下所示：  

```
插件列表 = {
    ["插件地址"] = {
        延迟加载项目 ...
    },
    ["插件地址"] = {
        延迟加载项目 ...
    },
    ["插件地址"] = {
        延迟加载项目 ...
    },
}

循环插件列表的 key 和 value
    插件配置 = {插件key, value} 的合并
    判断是否在 lua/configure/plugins 中存在插件配置文件
    如果存在
        插件配置.setup = "插件配置文件中的 before 函数"
        插件配置.config = "插件配置文件中的 load 函数 和 after 函数"
    use(插件配置)
```
##### 插件的加载顺序
注意，在nvim中，有某些插件是由 viml 编写的。 而大部分所选定的插件都是由 Lua 编写的。

viml 插件编写的配置不需要在 hooks config 中处理，这样会造成一些 lazy load 的问题。

而是应该放在 hooks setup 中处理。

我们可以在插件配置中手动定义一个 key 来判断插件的类型。

```
插件列表 = {
    ["插件地址"] = {
        ptp = viml,   -- plugin type 的缩写
        延迟加载项目 ...
    },
    ["插件地址"] = {
        延迟加载项目 ...
    },
    ["插件地址"] = {
        延迟加载项目 ...
    },
}
```
伪代码也需要做出一些更改：  

```
循环插件列表的 key 和 value
    插件配置 = {插件key, value} 的合并
    判断是否在 lua/configure/plugins 中存在插件配置文件
    如果存在
        判断插件类型是否是 viml
           是：
                插件配置.setup = "插件配置文件中的 entrance 函数"
           不是：
               插件配置.setup = "插件配置文件中的 before 函数"
               插件配置.config = "插件配置文件中的 load 函数 和 after 函数"
    use(插件配置)
```

##### 插件配置文件
viml 编写的插件配置文件模板是：  

```
local M = {}

function M.entrance()
    配置选项
end

return M
```

Lua 编写的插件配置文件模板是：  

```
local M = {}

function M.before() end

function M.load()
    local ok, m = pcall(require, "m")
    if not ok then
        return
    end

    M.m = m
    M.m.setup({config})
end

function M.after() end

return M
```

#### plugins.lua
```
-- 先导入 options 用户设置文件，后面可能会用到
local options = require("core.options")
local path = require("utils.api.path")

local packer_install_tbl = {
    ["wbthomason/packer.nvim"] = {},
}

-- 检查是否下载了 Packer，如果没有则自动下载
Packer_bootstrap = (function()
    local packer_install_path = path.join(vim.fn.stdpath("data"), "site/pack/packer/start/packer.nvim")
    ---@diagnostic disable-next-line: missing-parameter
    if vim.fn.empty(vim.fn.glob(packer_install_path)) > 0 then
        local rtp_addition = string.format("%s/site/pack/*/start/*", vim.fn.stdpath("data"))
        vim.notify("Please wait ...\nInstalling packer package manager ...", "info", { title = "Packer" })
        if not string.find(vim.o.runtimepath, rtp_addition) then
            vim.o.runtimepath = string.format("%s,%s", rtp_addition, vim.o.runtimepath)
        end
        return vim.fn.system({
            "git",
            "clone",
            "--depth",
            "1",
            "https://github.com/wbthomason/packer.nvim",
            packer_install_path,
        })
    end
end)()

local packer = require("packer")

-- 如果你访问 github 太慢，可以替换成镜像源
packer.init({
    git = {
        -- For Chinese users, if the download is slow, you can switch to the github mirror source
        -- replace : https://hub.fastgit.xyz/%s
        default_url_format = "https://github.com/%s",
    },
})

packer.startup({
    function(use)
        for plug_name, plug_config in pairs(packer_install_tbl) do
            -- 定义新的插件配置文件，其实就是将 key 和 value 合并了
            local plug_options = vim.tbl_extend("force", { plug_name }, plug_config)

            -- 这里就是插件配置文件在磁盘中的路径，以 nv_ 开头，比如插件名称是 test_plugin
            -- 那么它的配置文件名称就是 nv_test_plugin.lua，注意是全小写的
            local plug_filename = plug_options.as or string.match(plug_name, "/([%w-_]+).?")
            local load_disk_path = path.join("configure", "plugins", string.format("nv_%s", plug_filename:lower()))
            local file_disk_path = path.join(vim.fn.stdpath("config"), "lua", string.format("%s.lua", load_disk_path))

            -- 查看磁盘中该文件是否存在
            if path.is_exists(file_disk_path) then
                -- 判断插件类型
                if plug_config.ptp == "viml" then
                    plug_options.setup = string.format("require('%s').entrance()", load_disk_path)
                else
                    plug_options.setup = string.format("require('%s').before()", load_disk_path)
                    plug_options.config = string.format(
                        [[
                        require('%s').load()
                        require('%s').after()
                        ]],
                        load_disk_path,
                        load_disk_path
                    )
                end
            end
            use(plug_options)
        end
        if Packer_bootstrap then
            -- 第一次打开 neovim 时自动下载插件
            packer.sync()
        end
    end,
    -- 使用浮动窗口预览 packer 中插件的下载信息
    config = { display = { open_fn = require("packer.util").float } },
})

-- 创建一个自动命令，如果该文件被更改，则重新生成编译文件
local packer_user_config = vim.api.nvim_create_augroup("packer_user_config", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "plugins.lua" },
    callback = function()
        vim.cmd("source <afile>")
        vim.cmd("PackerCompile")
        vim.pretty_print("Recompile plugins successify...")
    end,
    group = packer_user_config,
})

return packer
```
##### 安装第一个插件
在 plugins.lua 的 packer_install_tbl 表中添加以下代码，我将它归类到了代码编辑插件类中，该插件会在进入插入模式后加载：  
```
local packer_install_tbl = {
    ["wbthomason/packer.nvim"] = {},
     ----------- Code Editor -----------
    ["windwp/nvim-autopairs"] = { -- autocomplete parentheses
        event = { "InsertEnter" },
    },
}
```
在 configure/plugins 目录中新建 nvim-autopairs.lua 文件，填入以下配置： 
```
-- https://github.com/windwp/nvim-autopairs

local M = {}

function M.before() end

function M.load()
    local ok, m = pcall(require, "nvim-autopairs")
    if not ok then
        return
    end

    M.nvim_autopairs = m
    M.nvim_autopairs.setup()
end

function M.after() end

return M
```
--- 
#### LSP

- plenary.nvim 是 null-ls 以及其后面其它安装的某些插件的依赖插件。
- nvim-lspconfig 是 LSP 基础插件，我们需要通过该插件来配置 neovim 内置 LSP 客户端如何与 LSP 服务器端通信。
- null-ls 插件能够提供一些基于第三方工具的代码诊断、格式化等操作。诸如 eslint、prettier、pylint 等都可以通过该插件非常简单的进行配置并生效。
- nvim-lsp-installer 是一款自动下载 LSP 服务器的插件，通过它能够让我们免去一些 LSP 服务器繁琐的安装步骤。通常，它依赖 git、npm 等一些外部的包管理器命令。
- fidget.nvim 能够提示目前 LSP 服务器的工作状态。当我们打开一个文件时，LSP 服务器通常必须要分析完整个工作区域后才能正常工作，这需要花费一些时间来完成，而通过 fidget.nvim 插件我们可以很直观的看到 LSP 服务器还需多久才能做完准备工作。
- nvim-lightbulb 插件在 LSP 的代码操作可用时会在行号列中显示一个小灯泡.我们可以通过特定的函数调用代码操作。代码操作通常提供了一些 vsc 中快速修复的功能，如导入模块、忽略错误等等 ...

##### 流程

LSP 的配置比较繁琐，首先我们可以将整个配置分为 3 个步骤：
- 下载 LSP 服务器
- 配置 LSP 客户端如何与 LSP 服务端交互
- 启动 LSP 服务器

> nvim-lspconfig 将所有默认配置存放在了 ~/.local/share/nvim/site/pack/packer/start/lua/lspconfig/server_configurations 目录下，所以可以直接用以下命令查看到默认的 sumneko_lua 配置文件：  

```
local util = require 'lspconfig.util'

local root_files = {
  '.luarc.json',
  '.luacheckrc',
  '.stylua.toml',
  'selene.toml',
}
return {
  default_config = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_dir = function(fname)
      return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
    log_level = vim.lsp.protocol.MessageType.Warning,
    settings = { Lua = { telemetry = { enable = false } } },
  },
  docs = {
    default_config = {
      root_dir = [[root_pattern(".luarc.json", ".luacheckrc", ".stylua.toml", "selene.toml", ".git")]],
    },
  },
}
```
注意！当你自己的配置文件中没有上面这些选项时，它将使用上面所展示的默认选项。  
- cmd ： 这是一个 table，可以携带参数。必须确保 table 索引 1 处的命令是可执行的，如果不可执行，那么证明该 LSP 服务器是不能启动的。
- filetypes ： 当匹配到这些文件类型时，LSP 服务器才会进入准备启动的状态。
-　root_dir ： 每个 LSP 服务器都需要一个特定的文件确定根目录，当成功匹配到了 root_files 中的文件时，LSP 服务器将会以工作区模式启动，你可以自己添加、删除这其中的匹配文件
-　single_file_support ： 表明该 LSP 服务器是否支持以单文件模式启动，如果该 LSP 服务器不支持以单文件模式启动，则其只能在 filetypes 和 root_dir 中的文件被匹配时才会生效

单文件模式和工作区模式有何区别？　　

以 Python 举例，当以单文件模式启动 LSP 服务器时，LSP 服务器不能实时更新工作区状态，此时如果你创建了一个自定义模块并导入时，LSP 服务器其实是不会识别它的，这样开发者就会看见误报的警告信息。

而工作区模式是可以识别自定义模块的，简单概括来说，LSP 服务器以工作区模式启动效果肯定好于单文件模式启动。但问题是，工作区模式启动的条件有些苛刻，必须要匹配 root_dir 才行，所以这在某些情况下是一种弊端。

比如，我们只想快速的用 Python 写一个单文件的爬虫程序，如果没有单文件模式的支持，那么 LSP 服务器在没有匹配 root_dir 时是不会启动的，这代表我们不能获得代码智能分析提示，这非常让人郁闷。

有一些 LSP 服务器本身不支持单文件模式启动，比如 tsserver，对此我们可以将当前 neovim 所在目录确定为根目录，相关知识在本章节最后面会介绍到。

##### 配置
- 配置 nvim-lsp-installer 插件
- 循环所有已经配置的 LSP 服务器和配置文件
- 判断 LSP 服务器是否下载，若没下载则自动下载，若已下载则启动服务
- 绑定按键，将按键注册到当前缓冲区
