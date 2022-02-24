##### LSP
LSP协议包括
- 代码补全
- 跳转定义
- 查看引用
- 悬浮信息
- 代码格式化
- 代码重构
- 工作区诊断  

不同的语言有不同的语言服务器，要想获得上述功能我们需要启用一个语言服务器， 然后在编码时让语言服务器诊断我们正在编辑的代码并给出合适的建议。  
- 配置语言服务器
- 下载语言服务器
- 启动语言服务器
- 开始愉快编码  

LSP 安装
目前 neovim 圈有 2 大 LSP 生态系统:
- coc
- neovim 内置 LSP

需要3个插件
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)：提供 LSP 基础服务
- [nvim-lsp-installer](https://github.com/williamboman/nvim-lsp-installer)：提供语言服务器的自动下载功能，你只需要先将语言服务器配置好直接就能自动下载和使用
- [lspsaga](https://github.com/tami5/lspsaga.nvim)：默认 LSP 的一些样式并不好看，通过该插件可以让 LSP 给出的一些提示、建议等都变的美观

```
-- LSP 基础服务
use {
    "neovim/nvim-lspconfig",
    config = function()
        require("conf.nvim-lspconfig")
    end
}
                                           
-- 自动安装 LSP
use {
    "williamboman/nvim-lsp-installer",
    config = function()
        require("conf.nvim-lsp-installer")
    end
}                                          
                                           
-- LSP UI 美化
use {
    "tami5/lspsaga.nvim",
    config = function()
        require("conf.lspsaga")
    end
}
```
首先是 lspconfig，他能够修改一些默认的代码诊断样式，在 lua/conf/ 目录下新建 nvim-lspconfig.lua 文件
```
-- https://github.com/neovim/nvim-lspconfig
-- 更多样式定制，参见：https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
​
-- 诊断样式定制
vim.diagnostic.config(
    {
        -- 诊断的虚拟文本
        virtual_text = {
            -- 显示的前缀，可选项：'●', '▎', 'x'
            -- 默认是一个小方块，不是很好看，所以这里改了
            prefix = "●",
            -- 是否总是显示前缀？是的
            source = "always"
        },
        float = {
            -- 是否显示诊断来源？是的
            source = "always"
        },
        -- 在插入模式下是否显示诊断？不要
        update_in_insert = false
    }
)
```
###### nvim-lspconfig配置
然后我们来书写 LSP 语言服务器的配置，参考：
- [查询语言可用的服务器名称](https://github.com/williamboman/nvim-lsp-installer#available-lsps)
- [查询该语言服务器的默认配置项目](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md)

> 以lua为例：通过查询得知lua服务器名称为sumneko_lua，在 lua/lsp/ 目录中新建一个sumneko_lua.lua文件，再查询默认配置项目
```
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
​
return {
    -- 比如这里修改成了中文提示信息，具体语言服务器是否支持中文提示还需要查看该语言服务器的配置项
    cmd = {"lua-language-server", "--locale=zh-CN"},
    filetypes = {"lua"},
    log_level = 2,
    -- 再比如我将该服务器的工作域范围改成了当前所在目录的工作区，避免了重复运行多个同样的语言服务器的问题
    root_dir = function()
        return vim.fn.getcwd()
    end,
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
                path = runtime_path
            },
            diagnostics = {
                globals = {"vim"}
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true)
            },
            telemetry = {
                enable = false
            }
        }
    }
}
```
###### nvim-lsp-installer 插件的配置
在 lua/conf/ 目录中新建 nvim-lsp-installer.lua 文件
```
-- https://github.com/williamboman/nvim-lsp-installer
​
local lsp_installer_servers = require("nvim-lsp-installer.servers")
​
-- WARN: 手动书写 LSP 配置文件
-- 名称：https://github.com/williamboman/nvim-lsp-installer#available-lsps
-- 配置：https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
​
local servers = {
    -- 语言服务器名称：配置选项
    sumneko_lua = require("lsp.sumneko_lua"),
    -- pyright = require("lsp.pyright"),
    -- tsserver = require("lsp.tsserver"),
    -- html = require("lsp.html"),
    -- cssls = require("lsp.cssls"),
    -- gopls = require("lsp.gopls"),
    -- jsonls = require("lsp.jsonls"),
    -- zeta_note = require("lsp.zeta_note"),
    -- sqls = require("lsp.sqls"),
    -- vuels = require("lsp.vuels")
}
​
-- 这里是 LSP 服务启动后的按键加载
local function attach(_, bufnr)
    -- 跳转到定义（代替内置 LSP 的窗口，telescope 插件让跳转定义更方便）
    vim.keybinds.bmap(bufnr, "n", "gd", "<cmd>Telescope lsp_definitions theme=dropdown<CR>", vim.keybinds.opts)
    -- 列出光标下所有引用（代替内置 LSP 的窗口，telescope 插件让查看引用更方便）
    vim.keybinds.bmap(bufnr, "n", "gr", "<cmd>Telescope lsp_references theme=dropdown<CR>", vim.keybinds.opts)
    -- 工作区诊断（代替内置 LSP 的窗口，telescope 插件让工作区诊断更方便）
    vim.keybinds.bmap(bufnr, "n", "go", "<cmd>Telescope diagnostics theme=dropdown<CR>", vim.keybinds.opts)
    -- 显示代码可用操作（代替内置 LSP 的窗口，telescope 插件让代码行为更方便）
    vim.keybinds.bmap(bufnr, "n", "<leader>ca", "<cmd>Telescope lsp_code_actions theme=dropdown<CR>", vim.keybinds.opts)
    -- 变量重命名（代替内置 LSP 的窗口，Lspsaga 让变量重命名更美观）
    vim.keybinds.bmap(bufnr, "n", "<leader>cn", "<cmd>Lspsaga rename<CR>", vim.keybinds.opts)
    -- 查看帮助信息（代替内置 LSP 的窗口，Lspsaga 让查看帮助信息更美观）
    vim.keybinds.bmap(bufnr, "n", "gh", "<cmd>Lspsaga hover_doc<CR>", vim.keybinds.opts)
    -- 跳转到上一个问题（代替内置 LSP 的窗口，Lspsaga 让跳转问题更美观）
    vim.keybinds.bmap(bufnr, "n", "g[", "<cmd>Lspsaga diagnostic_jump_prev<CR>", vim.keybinds.opts)
    -- 跳转到下一个问题（代替内置 LSP 的窗口，Lspsaga 让跳转问题更美观）
    vim.keybinds.bmap(bufnr, "n", "g]", "<cmd>Lspsaga diagnostic_jump_next<CR>", vim.keybinds.opts)
    -- 悬浮窗口上翻页，由 Lspsaga 提供
    vim.keybinds.bmap(
        bufnr,
        "n",
        "<C-p>",
        "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>",
        vim.keybinds.opts
    )
    -- 悬浮窗口下翻页，由 Lspsaga 提供
    vim.keybinds.bmap(
        bufnr,
        "n",
        "<C-n>",
        "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>",
        vim.keybinds.opts
    )
end
​
-- 自动安装或启动 LanguageServers
for server_name, server_options in pairs(servers) do
    local server_available, server = lsp_installer_servers.get_server(server_name)
    -- 判断服务是否可用
    if server_available then
        -- 判断服务是否准备就绪，若就绪则启动服务
        server:on_ready(
            function()
                -- keybind
                server_options.on_attach = attach
                -- options config
                server_options.flags = {
                    debounce_text_changes = 150
                }
                -- 启动服务
                server:setup(server_options)
            end
        )
        -- 如果服务器没有下载，则通过 notify 插件弹出下载提示
        if not server:is_installed() then
            vim.notify("Install Language Server : " .. server_name, "WARN", {title = "Language Servers"})
            server:install()
        end
    end
end
```
###### lspsaga配置
在 lua/conf/ 目录中新建 lspsaga.lua 文件
```
-- https://github.com/tami5/lspsaga.nvim
​
require("lspsaga").setup(
    {
        -- 提示边框样式：round、single、double
        border_style = "round",
        error_sign = " ",
        warn_sign = " ",
        hint_sign = " ",
        infor_sign = " ",
        diagnostic_header_icon = " ",
        -- 正在写入的行提示
        code_action_icon = " ",
        code_action_prompt = {
            -- 显示写入行提示
            -- 如果为 true ，则写代码时会在左侧行号栏中显示你所定义的图标
            enable = false,
            sign = true,
            sign_priority = 40,
            virtual_text = true
        },
        -- 快捷键配置
        code_action_keys = {
            quit = "<Esc>",
            exec = "<CR>"
        },
        rename_action_keys = {
            quit = "<Esc>",
            exec = "<CR>"
        }
    }
)
```
- :LspInfo 来查看语言服务器的工作状态  
- :LspInstallInfo 来查看是否下载完成
- gh 查看文档信息  
- gd 跳转到定义
- gr 查看引用
- <leader>cn 重命名变量
- go 进行工作区诊断


##### 显示 LSP 进度
在打开 Lua 文件时会等待大概十几秒 LSP 绑定的键位才会生效，这是由于 LSP 功能在启用前要先加载工作区。  
我们可以安装 [fidget](https://github.com/j-hui/fidget.nvim) 插件来查看 LSP 加载工作区的进度。  
在 lua/basic/plugins.lua 文件中安装 fidget：
```
-- LSP 进度提示
use {
    "j-hui/fidget.nvim",
    config = function()
        require("conf.fidget")
    end
}
```
在 lua/conf/ 目录下新建 fidget.lua 文件
```
-- https://github.com/j-hui/fidget.nvim
​
require("fidget").setup({
    window = {
        -- 窗口全透明，不建议修改这个选项
        -- 否则主题透明时将会出现一大片黑块
        blend = 0,
    }
})
```
重新进入 neovim 查看效果，现在右下角已经有了 LSP 加载的进度提示了。


##### 插入模式传参提示
在插入模式下编辑代码时，我们常常会想查看该函数的签名信息。通过 [lsp_signature](https://github.com/ray-x/lsp_signature.nvim) 插件就可以满足这种需求。
```
-- 插入模式获得函数签名
use {
    "ray-x/lsp_signature.nvim",
    config = function()
        require("conf.lsp_signature")
    end
}
```
在 lua/conf/ 目录下新建 lsp_signature.lua 文件
```
-- https://github.com/ray-x/lsp_signature.nvim
​
require("lsp_signature").setup(
    {
        bind = true,
        -- 边框样式
        handler_opts = {
            -- double、rounded、single、shadow、none
            border = "rounded"
        },
        -- 自动触发
        floating_window = false,
        -- 绑定按键
        toggle_key = "<C-j>",
        -- 虚拟提示关闭
        hint_enable = false,
        -- 正在输入的参数将如何突出显示
        hi_parameter = "LspSignatureActiveParameter"
    }
)
```
##### 灯泡提示代码行为
[nvim-lightbulb](https://github.com/kosayoda/nvim-lightbulb) 能够在有代码行为可使用的情况下在行号栏中提示一个小灯泡，类似与 vsocde 的功能：

```
-- 灯泡提示代码行为
use {
    "kosayoda/nvim-lightbulb",
    config = function()
        require("conf.nvim-lightbulb")
    end
}
```
在 lua/conf/ 目录下新建 nvim-lightbulb.lua 文件
```
-- https://github.com/kosayoda/nvim-lightbulb
​
vim.cmd([[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]])
```
当有代码行为可用时可按下 <leader>ca 来调用代码行为

##### 代码补全nvim-cmp
```
-- 自动代码补全系列插件
use {
    "hrsh7th/nvim-cmp",  -- 代码补全核心插件，下面都是增强补全的体验插件
    requires = {
        {"onsails/lspkind-nvim"}, -- 为补全添加类似 vscode 的图标
        {"hrsh7th/vim-vsnip"}, -- vsnip 引擎，用于获得代码片段支持
        {"hrsh7th/cmp-vsnip"}, -- 适用于 vsnip 的代码片段源
        {"hrsh7th/cmp-nvim-lsp"}, -- 替换内置 omnifunc，获得更多补全
        {"hrsh7th/cmp-path"}, -- 路径补全
        {"hrsh7th/cmp-buffer"}, -- 缓冲区补全
        {"hrsh7th/cmp-cmdline"}, -- 命令补全
        {"f3fora/cmp-spell"}, -- 拼写建议
        {"rafamadriz/friendly-snippets"}, -- 提供多种语言的代码片段
        {"lukas-reineke/cmp-under-comparator"}, -- 让补全结果的排序更加智能
        {"tzachar/cmp-tabnine", run = "./install.sh"} -- tabnine 源,提供基于 AI 的智能补全
    },
    config = function()
        require("conf.nvim-cmp")
    end
}
```

nvim-cmp 是补全核心插件，而 vim-vsnip 是补全引擎，补全引擎有很多但我个人觉得 vim-vsnip 是最强大的。

在 lua/conf/ 目录下新建 nvim-cmp.lua 文件
```
-- https://github.com/hrsh7th/nvim-cmp
-- https://github.com/hrsh7th/vim-vsnip
-- https://github.com/hrsh7th/cmp-vsnip
-- https://github.com/hrsh7th/cmp-nvim-lsp
-- https://github.com/hrsh7th/cmp-path
-- https://github.com/hrsh7th/cmp-buffer
-- https://github.com/hrsh7th/cmp-cmdline
-- https://github.com/f3fora/cmp-spell
-- https://github.com/rafamadriz/friendly-snippets
-- https://github.com/lukas-reineke/cmp-under-comparator
-- https://github.com/tzachar/cmp-tabnine
​
-- FIX: tabline 在某些计算机上有 1 个 BUG
-- 当出现：
--    TabNine is not executable
-- 等字样时，需要手动执行（仅限 Manjaro）：
--    rm ~/.local/share/nvim/plugged/cmp-tabnine/binaries
--    ~/.local/share/nvim/plugged/cmp-tabnine/install.sh
​
local lspkind = require("lspkind")
​
local cmp = require("cmp")
​
cmp.setup(
    ---@diagnostic disable-next-line: redundant-parameter
    {
        -- 指定补全引擎
        snippet = {
            expand = function(args)
                -- 使用 vsnip 引擎
                vim.fn["vsnip#anonymous"](args.body)
            end
        },
        -- 指定补全源（安装了补全源插件就在这里指定）
        sources = cmp.config.sources(
            {
                {name = "vsnip"},
                {name = "nvim_lsp"},
                {name = "path"},
                {name = "buffer"},
                {name = "cmdline"},
                {name = "spell"},
                {name = "cmp_tabnine"}
            }
        ),
        -- 格式化补全菜单
        formatting = {
            format = lspkind.cmp_format(
                {
                    with_text = true,
                    maxwidth = 50,
                    before = function(entry, vim_item)
                        vim_item.menu = "[" .. string.upper(entry.source.name) .. "]"
                        return vim_item
                    end
                }
            )
        },
        -- 对补全建议排序
        sorting = {
            comparators = {
                cmp.config.compare.offset,
                cmp.config.compare.exact,
                cmp.config.compare.score,
                cmp.config.compare.recently_used,
                require("cmp-under-comparator").under,
                require("cmp_tabnine.compare"),
                cmp.config.compare.kind,
                cmp.config.compare.sort_text,
                cmp.config.compare.length,
                cmp.config.compare.order
            }
        },
        -- 绑定补全相关的按键
        mapping = {
            -- 上一个
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            -- 下一个
            ["<C-n>"] = cmp.mapping.select_next_item(),
            -- 选择补全
            ["<CR>"] = cmp.mapping.confirm(),
            --  出现或关闭补全
            ["<C-k>"] = cmp.mapping(
                {
                    i = function()
                        if cmp.visible() then
                            cmp.abort()
                        else
                            cmp.complete()
                        end
                    end,
                    c = function()
                        if cmp.visible() then
                            cmp.close()
                        else
                            cmp.complete()
                        end
                    end
                }
            ),
            -- 类似于 IDEA 的功能，如果没进入选择框，tab
            -- 会选择下一个，如果进入了选择框，tab 会确认当前选择
            ["<Tab>"] = cmp.mapping(
                function(fallback)
                    if cmp.visible() then
                        local entry = cmp.get_selected_entry()
                        if not entry then
                            cmp.select_next_item({behavior = cmp.SelectBehavior.Select})
                        end
                        cmp.confirm()
                    else
                        fallback()
                    end
                end,
                {"i", "s", "c"}
            )
        }
    }
)
​
-- 命令行 / 模式提示
cmp.setup.cmdline(
    "/",
    {
        sources = {
            {name = "buffer"}
        }
    }
)
​
-- 命令行 : 模式提示
cmp.setup.cmdline(
    ":",
    {
        sources = cmp.config.sources(
            {
                {name = "path"}
            },
            {
                {name = "cmdline"}
            }
        )
    }
)
```
我重新进入 neovim 后，tabnine 报了一个错误
![tabnine错误](../image/tabnine%E9%94%99%E8%AF%AF.jpg)
退出 neovim 输入以下 2 条命令安装 tabnine（tabnine 一定在 ~/.local/share/nvim 目录下）：
```
-- 找到 com-tabnine 的安装目录
cd ~/.local/share/nvim/site/pack/packer/start/cmp-tabnine/
-- 安装 tabnine（确保安装了 curl 命令）
./install.sh
```

##### 增强 LSP 补全
[cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) 用于替换 neovim 默认的 omnifunc，能够增强补全体验。
在 nvim-lsp-installer.lua 中加入以下代码：
```
-- 使用 cmp_nvim_lsp 代替内置 omnifunc，获得更强的补全体验
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
​
-- 代替内置 omnifunc
server_options.capabilities = capabilities
```
![替代位置](../image/%E6%9B%BF%E4%BB%A3%E4%BD%8D%E7%BD%AE1.jpg)
![替代位置](../%E6%9B%BF%E4%BB%A3%E4%BD%8D%E7%BD%AE2.jpg)
