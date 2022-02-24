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


###### 显示 LSP 进度
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
![输入图片说明](../image/%E6%9B%BF%E4%BB%A3%E4%BD%8D%E7%BD%AE2.jpg)


##### 新增代码片段
vim-vsnip 能够新增 vscode 格式的用户代码片段，我们在 lua/basic/conf.lua 文件中设定一下代码片段保存的位置：
```
-- 指定代码片段存储路径
vim.g.vsnip_snippet_dir = "~/.config/nvim/snippet"
```
退出重进 neovim，然后打开一个 Lua 文件，命令行输入命令:VsnipOpen  
代码片段的格式和 vscode 相同：
```
// Place your snippets for html here. Each snippet is defined under a snippet name and has a prefix, body and
// description. The prefix is what is used to trigger the snippet and the body will be expanded and inserted. Possible variables are:
// $1, $2 for tab stops, $0 for the final cursor position, and ${1:label}, ${2:another} for placeholders. Placeholders with the
// same ids are connected.
// Example:
// "Print to console": {
//  "prefix": "log",
//  "body": [
//      "console.log('$1');",
//      "$2"
//  ],
//  "description": "Log output to console"
// }

```
##### github copilot
[copilot](https://github.com/github/copilot.vim) 它能快速生成一大片代码段。  
比如想写个匹配手机号码的正则表达式，你只需要打上注释 match mobile number 即可获得代码实现，非常强大，但需要预览资格。
```
-- git copilot 自动补全
use {
    "github/copilot.vim",
    config = function()
        require("conf.copilot")
    end
}
```
在 lua/conf/ 目录下新建 copilot.lua 文件
```
-- https://github.com/github/copilot.vim
​
vim.g.copilot_no_tab_map = true
​
vim.keybinds.gmap("i", "<C-l>", "copilot#Accept('')", {silent = true, expr = true})
​
-- 使用 C-l 确认补全
-- 使用 M-[ 查看上一个补全
-- 使用 M-[ 查看下一个补全
-- 使用 C-[ 关闭补全
```
输入 :Copilot setup 记录命令行中出现的设备号并填入网页的验证框中，而后 copilot 插件就能正常工作了。


##### lint 代码诊断
尽管许多 LSP 语言服务器已经自带了诊断信息，但我们更希望使用其他的诊断工具，如 eslint、pylint 等。  
[nvim-lint](https://github.com/mfussenegger/nvim-lint) 插件就是做这个功能的，以 Python 举例，在此之前要先安装 Python 语言服务器 pyright。  
在 Ubuntu 上安装 nodejs 和 npm，因为 Python 的语言服务器 Pyright 自动下载时需要使用到这 2 个工具：
```
wget https://nodejs.org/dist/v16.14.0/node-v16.14.0-linux-x64.tar.xz
sudo tar -xvf ./node-v16.14.0-linux-x64.tar.xz -C /usr/local/
sudo mv /usr/local/node-v16.14.0-linux-x64/ /usr/local/node
nvim ~/.bashrc
export PATH=/usr/local/node/bin:$PATH
source ~/.bashrc
```
安装完成后在 lua/lsp/ 目录中新建 pyright.lua 文件
```
return {
    root_dir = function()
        return vim.fn.getcwd()
    end,
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "off"
            }
        }
    }
}
```
解开 lua/conf/nvim-lsp-installer.lua 文件中需要下载的语言服务器配置注释：
```
local servers = {
    -- 语言服务器名称：配置选项
    sumneko_lua = require("lsp.sumneko_lua"),
    pyright = require(lsp.pyright),
    -- tssever = require("lsp.pyright")
}
```
在 lua/basic/plugins.lua 中安装 nvim-lint 插件：
```
-- 扩展 LSP 诊断
use {
    "mfussenegger/nvim-lint",
    config = function()
        require("conf.nvim-lint")
    end
}
```
在 lua/conf/ 目录下新建 nvim-lint.lua 文件
```
-- https://github.com/mfussenegger/nvim-lint
​
-- WARN: nvim-lint 手动下载诊断工具，确保该诊断工具能被全局调用
-- pip3 install pylint
​
require("lint").linters_by_ft = {
    python = {"pylint"}
    -- javascript = {"eslint"},
    -- typescript = {"eslint"},
    -- go = {"golangcilint"}
}
​
-- 配置 pylint，pylint 配置文件需要自己准备，这里不再演示
require("lint.linters.pylint").args = {
    "-f",
    "json",
    "--rcfile=~/.config/nvim/lint/pylint.conf"
}
​
-- 何时触发检测：
-- BufEnter    ： 载入 Buf 后
-- BufWritePost： 写入文件后
-- 由于搭配了 AutoSave，所以其他的事件就不用加了
​
vim.cmd([[
au BufEnter * lua require('lint').try_lint()
au BufWritePost * lua require('lint').try_lint()
]])
```
输入 :PackerSync 等待该插件下载完成后退出 neovim，手动下载 pylint 诊断：
```
sudo apt install pylint
```
打开一个 py 文件，尝试输入内容，不出意外的话你应该能看到 2 个诊断源的信息，分别是 pyright 和 pylint  
如果想禁用 pyright，而只启动 pylint 的诊断，可以更改 lua/lsp/pyright.lua 文件中的配置
```
return {
    root_dir = function()
        return vim.fn.getcwd()
    end,
    -- 禁用 Pyright 的诊断信息（只使用 pylint）
    handlers = {
        ---@diagnostic disable-next-line: unused-vararg
        ["textDocument/publishDiagnostics"] = function(...)
        end
    },
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "off"
            }
        }
    }
}
```
这样就只有 pylint 在诊断了  


##### 语法高亮 nvim-treesitter
[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) 插件有以下一些功能：

- 语法高亮显示（主要功能，非常好用，打开了）
- 增量选择代码块（很好用，打开了）
- 缩进（关了，有 bug，在编辑 Python 文件时碰到了）
- 折叠（关了，我喜欢用基于缩进的折叠  
除此之外它也能配合一些其它插件来使用，如下面需要安装的彩虹括号。
在安装它之前需要安装一些外部依赖：
```
sudo apt install build-essential -- 会安装一系列工具，包括 gcc
​
-- 还需要：tar 和 curl 或 git，如果有就不用装了
```
在 lua/basic/plugins.lua 文件中安装 nvim-treesitter 和 彩虹括号插件：
```
-- 语法高亮
use {
    "nvim-treesitter/nvim-treesitter",
    run = {":TSupdate"},
    requires = {
        "p00f/nvim-ts-rainbow" -- 彩虹括号
    },
    config = function()
        require("conf.nvim-treesitter")
    end
}
```
在 lua/conf/ 目录下新建 nvim-treesitter.lua 文件
```
-- https://github.com/nvim-treesitter/nvim-treesitter
-- https://github.com/p00f/nvim-ts-rainbow
​
require("nvim-treesitter.configs").setup(
    {
        -- 安装的高亮支持来源
        ensure_installed = "maintained",
        -- 同步下载高亮支持
        sync_install = false,
        -- 高亮相关
        highlight = {
            -- 启用高亮支持
            enable = true,
            -- 使用 treesitter 高亮而不是 neovim 内置的高亮
            additional_vim_regex_highlighting = false
        },
        -- 范围选择
        incremental_selection = {
            enable = true,
            keymaps = {
                -- 初始化选择
                init_selection = "<CR>",
                -- 递增
                node_incremental = "<CR>",
                -- 递减
                node_decremental = "<BS>",
                -- 选择一个范围
                scope_incremental = "<TAB>"
            }
        },
        -- 缩进，关闭
        indent = {
            enable = false
        },
        -- 彩虹括号，由 nvim-ts-rainbow 插件提供
        rainbow = {
            enable = true,
            extended_mode = true
            -- colors = {}, -- table of hex strings
            -- termcolors = {} -- table of colour name strings
        },
    }
)
```
Ps：最近 nvim-ts-rainbow 插件更新了，在启动 neovim 时会抛出一个异常：
![nvim-ts-rainbow异常](../image/nvim-ts-rainbow%E5%BC%82%E5%B8%B8.jpg)  
官方 github 已经有人提供 issuse 了，我也去顶了一下，参见：[点我跳转](https://github.com/p00f/nvim-ts-rainbow/issues/94)。在该问题解决之前，可以先暂时禁用彩虹括号，将 enable 修改为 false，如果放任它不管很可能其它插件就不能正确运行了。

##### 代码注释Comment
[Comment](https://github.com/numToStr/Comment.nvim) 插件能够提供代码注释的功能，搭配 [nvim-ts-context-commentstring ](https://github.com/JoosepAlviste/nvim-ts-context-commentstring)插件可以做到根据当前光标所在的上下文环境给予不同的代码注释方式。  
比如在 vue 文件中，template、style、script 这 3 个标签的注释方式都有所不同，只有使用 Comment + nvim-ts-context-commentstring 插件才能提供正确的注释。  

在 lua/basic/plugins.lua 文件中安装这 2 个插件：
```
-- 代码注释
use {
    "numToStr/Comment.nvim",
    requires = {
        "JoosepAlviste/nvim-ts-context-commentstring"
    },
    config = function()
        require("conf.Comment")
    end
}
```
要想启用 nvim-ts-context-commentstring 插件，需要到 lua/conf/nvim-treesitter.lua 文件里添加上下面的代码：
```
-- 根据当前上下文定义文件类型，由 nvim-ts-context-commentstring 插件提供
context_commentstring = {
    enable = true
}
```
![nvim-ts-context-commentstring ](../image/nvim-ts-context-commentstring%E6%B7%BB%E5%8A%A0%E4%BD%8D%E7%BD%AE.jpg)  
然后在 lua/conf/ 目录下创建 Comment.lua 文件
```
-- https://github.com/numToStr/Comment.nvim
-- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
​
local comment_string = require("ts_context_commentstring")
​
require("Comment").setup(
    {
        toggler = {
            -- 切换行注释
            line = "gcc",
            --- 切换块注释
            block = "gCC"
        },
        opleader = {
            -- 可视模式下的行注释
            line = "gc",
            -- 可视模式下的块注释
            block = "gC"
        },
        extra = {
            -- 在当前行上方新增行注释
            above = "gcO",
            -- 在当前行下方新增行注释
            below = "gco",
            -- 在当前行行尾新增行注释
            eol = "gcA"
        },
        -- 根据当前光标所在上下文判断不同类别的注释
        -- 由 nvim-ts-context-commentstring  提供
        pre_hook = function(ctx)
            -- Only calculate commentstring for tsx filetypes
            if vim.bo.filetype == "typescriptreact" then
                local U = require("Comment.utils")
                -- Detemine whether to use linewise or blockwise commentstring
                local type = ctx.ctype == U.ctype.line and "__default" or "__multiline"
                -- Determine the location where to calculate commentstring from
                local location = nil
                if ctx.ctype == U.ctype.block then
                    location = comment_string.utils.get_cursor_location()
                elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
                    location = comment_string.utils.get_visual_start_location()
                end
                return comment_string.calculate_commentstring(
                    {
                        key = type,
                        location = location
                    }
                )
            end
        end
    }
)
```


##### 代码格式化 neoformat
[neoformat](https://github.com/sbdchd/neoformat) 插件能够提供代码格式化，但需要手动安装各个语言的代码格式化程序。  
[点我查询各个语言代码格式化程序的安装](https://github.com/sbdchd/neoformat#supported-filetypes)  
以下是以python代码格式化程序安装示例：
```
python：在 ubuntu 下可以直接 sudo apt install python3-autopep8
lua：直接通过 npm 安装 npm install -g lua-fmt
html、css、vue、js、ts、json：直接通过 npm 安装 npm install -g prettier
```
在 lua/basic/plugins.lua 中安装 neoformat 插件
```
-- 代码格式化
use {
    "sbdchd/neoformat",
    config = function()
        require("conf.neoformat")
    end
}
```
在 lua/conf/ 目录下新建文件 neoformat.lua 
```
-- https://github.com/sbdchd/neoformat
​
-- WARN: neoformat 手动安装各语言的代码格式化程序
-- https://github.com/sbdchd/neoformat#supported-filetypes
​
-- 当没有找到格式化程序时，将按照如下方式自动格式化
​
-- 1.自动对齐
vim.g.neoformat_basic_format_align = 1
-- 2.自动删除行尾空格
vim.g.neoformat_basic_format_trim = 1
-- 3.将制表符替换为空格
vim.g.neoformat_basic_format_retab = 0
​
-- 只提示错误消息
vim.g.neoformat_only_msg_on_error = 1
​
-- 自动格式化
​
-- vim.cmd([[
-- augroup fmt
--   autocmd!
--   autocmd BufWritePre * undojoin | Neoformat
-- augroup END
-- ]])
​
vim.keybinds.gmap("n", "<leader>cf", "<cmd>Neoformat<CR>", vim.keybinds.opts)
```


##### 主题扩展
[lsp-colors](https://github.com/folke/lsp-colors.nvim) 是一个可选插件，当你的主题不支持 LSP 的某些诊断显示时，可通过该插件设定默认值。  
```
-- 为不支持 LSP 高亮的主题提供默认高亮方案
use {
    "folke/lsp-colors.nvim",
    config = function()
        require("conf.lsp-colors")
    end
}
```
在 lua/conf/ 目录下新建 lsp-colors.lua 文件
```
-- https://github.com/folke/lsp-colors.nvim
​
-- 当主题不支持 LSP 高亮时，将采用以下默认方案
require("lsp-colors").setup(
    {
        Error = "#db4b4b",
        Warning = "#e0af68",
        Information = "#0db9d7",
        Hint = "#10B981"
    }
)
```
##### 大纲预览vista
[vista](https://github.com/liuchengxu/vista.vim) 是一款由 viml 编写的插件，能够快速预览当前文档的大纲视图。
```
-- view tree
use {
    "liuchengxu/vista.vim",
    config = function()
        require("conf.vista")
    end
}
```
在 lua/conf/ 目录下新建 vista.lua 文件
```
-- https://github.com/liuchengxu/vista.vim
​
vim.cmd(
    [[
" 缩进显示方式
let g:vista_icon_indent = ["▸ ", ""]
" 通过那种方式渲染大纲预览（ctags 或者 nvim_lsp）
let g:vista_default_executive = 'nvim_lsp'
" 启用图标支持"
let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }
]]
)
​
-- 打开大纲预览
vim.keybinds.gmap("n", "<leader>2", "<cmd>Vista!!<CR>", vim.keybinds.opts)
```

##### 常用语言 LSP 配置
- sumneko_lua
```
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
​
return {
    cmd = {"lua-language-server", "--locale=zh-CN"},
    filetypes = {"lua"},
    log_level = 2,
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
- html
```
return {
    root_dir = function()
        return vim.fn.getcwd()
    end
}
```
- css
```
-- 语言服务器名称是 cssls
return {
    root_dir = function()
        return vim.fn.getcwd()
    end
}
```

- golang
```
-- 语言服务器名称是 gopls
return {
    root_dir = function()
        return vim.fn.getcwd()
    end
}
```
- json
```
-- 语言服务器名称是 jsonls：
return {
    root_dir = function()
        return vim.fn.getcwd()
    end
}
```

- python
```
-- 语言服务器名称是 pyright
return {
    root_dir = function()
        return vim.fn.getcwd()
    end,
    -- 禁用 Pyright 的诊断信息（使用 pylint）
    handlers = {
        ---@diagnostic disable-next-line: unused-vararg
        ["textDocument/publishDiagnostics"] = function(...)
        end
    },
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "off"
            }
        }
    }
}
```
- sql
```
-- 语言服务器名称是 sqls：
return {
    root_dir = function()
        return vim.fn.getcwd()
    end
}
```

- js\ts
```
-- 语言服务器名称是 tsserver：
return {
    cmd = {"typescript-language-server", "--stdio"},
    init_options = {
        hostInfo = "neovim"
    },
    root_dir = function()
        return vim.fn.getcwd()
    end
}
```

- vue
```
-- 语言服务器名称是 vuels：
return {
    root_dir = function()
        return vim.fn.getcwd()
    end
}
```

- markdown
```
-- 语言服务器名称是 zeta_note：
return {
    root_dir = function()
        return vim.fn.getcwd()
    end
}
```