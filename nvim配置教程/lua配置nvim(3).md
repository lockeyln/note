##### packer 插件管理
安装
```
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```
使用
```
---@diagnostic disable: undefined-global
-- https://github.com/wbthomason/packer.nvim
​
local packer = require("packer")
packer.startup(
    {
        -- 所有插件的安装都书写在 function 中
        function()
            -- 包管理器
            use {
                "wbthomason/packer.nvim"
            }
​
            -- 安装其它插件
​
        end,
        -- 使用浮动窗口
        config = {
            display = {
                open_fn = require("packer.util").float
            }
        }
    }
)
​
-- 实时生效配置
vim.cmd(
    [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]]
)
```
对于如何使用 packer，其主页 https://github.com/wbthomason/packer.nvim  
```
---@diagnostic disable: undefined-global
-- https://github.com/wbthomason/packer.nvim
​
local packer = require("packer")
packer.startup(
    {
        -- 所有插件的安装都书写在 function 中
        function()
            -- 包管理器
            use {
                "wbthomason/packer.nvim"
            }
​
            -- 可以一次加载一个插件，跟上一个字符串
            use "插件地址"
            
            -- 可以一次加载多个插件，跟上一个 list
            use {
                "插件地址",
                "插件地址",
                "插件地址"
            }
            
            -- 对于有依赖的插件，可以使用 requires 跟上一个 list
            use {
                "插件地址",
                requires = {
                     "依赖的插件地址",
                     "依赖的插件地址",
                     "依赖的插件地址",
                }
            }
            
            -- 可以在插件加载完成后自动运行一些代码
            use {
                "插件地址",
                config = function()
                    "需要运行的代码 ..."
                end
            }
            
            -- 插件可以在固定的文件类型里生效
            use {
                "插件地址",
                ft = {"html", "css", "javascript"}
            }
            
            -- 插件可以在一些自动事件加载后生效（延迟加载）
            use {
                "插件地址",
                event = "事件"  -- 使用 :h event 可获取事件帮助
            }
            
            -- 插件可以在输入一些命令后生效（延迟加载）
            use {
                "插件地址",
                cmd = {"命令", "命令", "命令"}
            }
            
            -- 插件可以在按下某些按键后生效（延迟加载）
            use {
                "插件地址",
                keys = {
                   "键位",
                   "键位"
                }
            }
            
            -- 在插件加载后自动执行一些操作
            use {
                "插件地址",
                run = "命令"
            }
​
        end,
        -- 使用浮动窗口
        config = {
            display = {
                open_fn = require("packer.util").float
            }
        }
    }
)
​
-- 实时生效配置
vim.cmd(
    [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]]
)
```

尝试安装第一个插件，vim中文文档，该插件没有任何依赖，可以直接通过 use 安装：
```
---@diagnostic disable: undefined-global
-- https://github.com/wbthomason/packer.nvim
​
local packer = require("packer")
packer.startup(
    {
        -- 所有插件的安装都书写在 function 中
        function()
​
            -- 包管理器
            use {
                "wbthomason/packer.nvim"
            }
​
            -- 中文文档
            use {
                "yianwillis/vimcdoc",
            }
​
        end,
        -- 使用浮动窗口
        config = {
            display = {
                open_fn = require("packer.util").float
            }
        }
    }
)
​
-- 实时生效配置
vim.cmd(
    [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]]
)
```
输入 :h event 查看中文文档插件是否生效

```
除了 PackerSync 命令外，还有一些命令：

PackerCompile：当插件更改后，运行该命令会使更改生效
PackerClean：删除禁用或未使用的插件
PackerInstall：清理，然后安装缺少的插件，不更新已有的插件
PackerUpdate：清理，然后更新已有的插件和安装缺少的插件
PackerSync：相当与 PackerUpdate 和 PackerCompile 的结合体
PackerLoad：立即加载某个插件
```
---
#### 插件推荐
##### 目录树
- nvim-tree
- chad-tree
- neo-tree

nvim-tree
```
-- nvim-tree
use {
    "kyazdani42/nvim-tree.lua",
    requires = {
        -- 依赖一个图标插件
        "kyazdani42/nvim-web-devicons"
    },
    config = function()
        -- 插件加载完成后自动运行 lua/conf/nvim-tree.lua 文件中的代码
        require("conf.nvim-tree")
    end
}
```
lua/conf/nvim-tree.lua
```
-- https://github.com/kyazdani42/nvim-tree.lua
​
require("nvim-tree").setup(
    {
        -- 自动关闭
        auto_close = true,
        -- 视图
        view = {
            -- 宽度
            width = 30,
            -- 高度
            height = 30,
            -- 隐藏顶部的根目录显示
            hide_root_folder = false,
            -- 自动调整大小
            auto_resize = true
        },
        diagnostics = {
            -- 是否启用文件诊断信息
            enable = true,
            icons = {
                hint = "",
                info = "",
                warning = "",
                error = ""
            }
        },
        git = {
            -- 是否启用 git 信息
            enable = true,
            ignore = true,
            timeout = 500
        }
    }
)
​
-- 默认图标，可自行修改
vim.g.nvim_tree_icons = {
    default = " ",
    symlink = " ",
    git = {
        unstaged = "",
        staged = "✓",
        unmerged = "",
        renamed = "➜",
        untracked = "",
        deleted = "",
        ignored = ""
    },
    folder = {
        -- arrow_open = "╰─▸",
        -- arrow_closed = "├─▸",
        arrow_open = "",
        arrow_closed = "",
        default = "",
        open = "",
        empty = "",
        empty_open = "",
        symlink = "",
        symlink_open = ""
    }
}
​
-- 目录后加上反斜杠 /
vim.g.nvim_tree_add_trailing = 1
​
-- 按 leader 1 打开文件树
vim.keybinds.gmap("n", "<leader>1", "<cmd>NvimTreeToggle<CR>", vim.keybinds.opts)
-- 按 leader fc 在文件树中找到当前以打开文件的位置
vim.keybinds.gmap("n", "<leader>fc", "<cmd>NvimTreeFindFile<CR>", vim.keybinds.opts)
​
-- 默认按键
-- o     ：打开目录或文件
-- a     ：新增目录或文件
-- r     ：重命名目录或文件
-- x     ：剪切目录或文件
-- c     ：复制目录或文件
-- d     ：删除目录或文件
-- y     ：复制目录或文件名称
-- Y     ：复制目录或文件相对路径
-- gy    ：复制目录或文件绝对路径
-- p     ：粘贴目录或文件
-- s     ：使用系统默认程序打开目录或文件
-- <Tab> ：将文件添加到缓冲区，但不移动光标
-- <C-v> ：垂直分屏打开文件
-- <C-x> ：水平分屏打开文件
-- <C-]> ：进入光标下的目录
-- <C-r> ：重命名目录或文件，删除已有目录名称
-- -     ：返回上层目录
-- I     ：切换隐藏文件/目录的可见性
-- H     ：切换点文件的可见性
-- R     ：刷新资源管理器
-- 另外，文件资源管理器操作和操作文档方式一致，可按 / ? 进行搜索
``` 
