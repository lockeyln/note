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


