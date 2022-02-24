## 切记以下配置用nvim编辑，否则出现<200b>之类的特殊字符，肉眼看不见，别的编辑器发现不了
##### 特殊字符

| Unicode code point | utf-8(in literal) | name             |
|--------------------|-------------------|------------------|
| U+200B或<200b>      | \xe2\x80\x8b     | ZERO WIDTH SPACE |
| U+200C或<200c>      | \xe2\x80\x8c     | ZERO WIDTH NON-JOINER |
| U+200D或<200d>      | \xe2\x80\x8d     | ZERO WIDTH JOINER |
> 这些字符其实就是排版过程中产生的，而排版使用的规范是Unicode编码标准
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
##### 目录树推荐
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
nvim-tree 图标显示错误是因为缺少一个需要手动安装的外部依赖 [nerd font](https://www.nerdfonts.com/)。  
推荐使用 FiraCode，兼容性好并且支持连体字。
##### 主题美化推荐
neovim 可选的主题非常多，可参照[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter/wiki/Colorschemes)中推荐的主题
- [catppuccin](https://github.com/catppuccin/nvim)
- [vscode-dark](https://github.com/tomasiser/vim-code-dark)
- [kanagawa](https://github.com/rebelot/kanagawa.nvim)
- [monokai](https://github.com/tanvirtin/monokai.nvim)  

catppuccin主题
```
-- 优秀的暗色主题
use {
    "catppuccin/nvim",
    -- 改个别名，因为它的名字是 nvim，可能会冲突
    as = "catppuccin",
    config = function()
        -- 插件加载完成后自动运行 lua/conf/catppuccin.lua 文件中的代码
        require("conf.catppuccin")
    end
}
```
新建文件 catppuccin.lua 到 lua/conf/ 目录下
```
-- https://github.com/catppuccin/nvim
​
require("catppuccin").setup(
    {
        -- 透明背景
        transparent_background = false,
        -- 使用终端背景色
        term_color = false,
        -- 代码样式
        styles = {
            comments = "italic",
            functions = "NONE",
            keywords = "NONE",
            strings = "NONE",
            variables = "NONE"
        },
        -- 为不同的插件统一样式风格
        -- 尽管这里有一些插件还没有安装，但是先将它们
        -- 设置为 true 并不影响
        integrations = {
            cmp = true,
            gitsigns = true,
            telescope = true,
            which_key = true,
            bufferline = true,
            markdown = true,
            ts_rainbow = true,
            hop = true,
            notify = true,
            indent_blankline = {
                enabled = true,
                colored_indent_levels = false
            },
            nvimtree = {
                enabled = true,
                show_root = false,
                -- 透明背景
                transparent_panel = false,
            },
            native_lsp = {
                enabled = true,
                virtual_text = {
                    errors = "italic",
                    hints = "italic",
                    warnings = "italic",
                    information = "italic"
                },
                underlines = {
                    errors = "underline",
                    hints = "underline",
                    warnings = "underline",
                    information = "underline"
                }
            },
            -- 后面我们自己会手动设置
            lsp_saga = false
        }
    }
)
​
-- 应用主题
vim.cmd([[colorscheme catppuccin]])
```

背景透明
catppuccin 可以让自身和 nvim-tree 的背景都透明，但需要设置 2 个地方。
1. 在lua/basic/config.lua 文件中自己设置一个选项，统一管理是否需要透明它们
```
-- 是否透明背景
vim.g.background_transparency = true
```
2. 修改 lua/conf/cappuccin.lua 中关于 transparent_background 和 transparent_panel 的选项
```
transparent_background = vim.g.background_transparency,
...
nvimtree = {
    ...
    transparent_panel = vim.g.background_transparency,
}
```
将 Gnome-Terminal 修改为透明背景
![输入图片说明](../image/%E7%BB%88%E7%AB%AF%E8%83%8C%E6%99%AF%E8%AE%BE%E7%BD%AE%E9%80%8F%E6%98%8E.jpg)

##### 状态栏美化推荐
- [feline](https://github.com/feline-nvim/feline.nvim)
- [windline](https://github.com/windwp/windline.nvim)
- [lualine](https://github.com/nvim-lualine/lualine.nvim)  
其中 windline 的效果最酷炫，它的内置主题可以让状态栏动起来。  
windline  
安装
```
-- 炫酷的状态栏插件
use {
    "windwp/windline.nvim",
    config = function()
        -- 插件加载完成后自动运行 lua/conf/windline.lua 文件中的代码
        require("conf.windline")
    end
}
```
新建文件 windline.lua 到 lua/conf/ 目录下
```
-- https://github.com/windwp/windline.nvim
-- 更多内置样式，参见：
-- https://github.com/windwp/windline.nvim/tree/master/lua/wlsample
​
local windline = require('windline')
local effects = require('wlanimation.effects')
local HSL = require('wlanimation.utils')
require('wlsample.airline')
local animation = require('wlanimation')
​
local is_run = false
​
local function toggle_anim()
    if is_run then
        animation.stop_all()
        is_run = false
        return
    end
    is_run = true
    local magenta_anim={}
    local yellow_anim={}
    local blue_anim = {}
    local green_anim={}
    local red_anim = {}
    local colors = windline.get_colors()
​
    if vim.o.background == 'light' then
        magenta_anim = HSL.rgb_to_hsl(colors.magenta):tints(10,8)
        yellow_anim = HSL.rgb_to_hsl(colors.yellow):tints(10,8)
        blue_anim = HSL.rgb_to_hsl(colors.blue):tints(10, 8)
        green_anim = HSL.rgb_to_hsl(colors.green):tints(10,8)
        red_anim = HSL.rgb_to_hsl(colors.red):tints(10,8)
    else
        -- shades will create array of color from color to black color .I don't need
        -- black color then I only take 8
        magenta_anim = HSL.rgb_to_hsl(colors.magenta):shades(10,8)
        yellow_anim = HSL.rgb_to_hsl(colors.yellow):shades(10, 8)
        blue_anim = HSL.rgb_to_hsl(colors.blue):shades(10, 8)
        green_anim = HSL.rgb_to_hsl(colors.green):shades(10, 8)
        red_anim = HSL.rgb_to_hsl(colors.red):shades(10, 8)
    end
​
    animation.stop_all()
    animation.animation({
        data = {
            { 'magenta_a', effects.list_color(magenta_anim, 3) },
            { 'magenta_b', effects.list_color(magenta_anim, 2) },
            { 'magenta_c', effects.list_color(magenta_anim, 1) },
​
            { 'yellow_a', effects.list_color(yellow_anim, 3) },
            { 'yellow_b', effects.list_color(yellow_anim, 2) },
            { 'yellow_c', effects.list_color(yellow_anim, 1) },
​
            { 'blue_a', effects.list_color(blue_anim, 3) },
            { 'blue_b', effects.list_color(blue_anim, 2) },
            { 'blue_c', effects.list_color(blue_anim, 1) },
​
            { 'green_a', effects.list_color(green_anim, 3) },
            { 'green_b', effects.list_color(green_anim, 2) },
            { 'green_c', effects.list_color(green_anim, 1) },
​
            { 'red_a', effects.list_color(red_anim, 3) },
            { 'red_b', effects.list_color(red_anim, 2) },
            { 'red_c', effects.list_color(red_anim, 1) },
        },
​
        timeout = nil,
        delay = 200,
        interval = 150,
    })
end
​
WindLine.airline_anim_toggle = toggle_anim
​
-- make it run on startup
vim.defer_fn(function()
    toggle_anim()
end, 200)
```
如果在一个git仓库中，windline状态栏其实也可以显示当前你在哪个分支下。
但是需要安装额外的一个插件 gitsigns，这个插件不仅可以让 windline 显示更多的内容，还提供了一些额外的操作 。
```
-- 为了能让状态栏显示 git 信息，所以这个插件是必须的
use {
    "lewis6991/gitsigns.nvim",
    requires = {
        -- 依赖于该插件（一款 Lua 开发使用的插件）
        "nvim-lua/plenary.nvim"
    },
    config = function()
        require("gitsigns").setup()
    end
}
```
新建文件 gitsigns.lua 到 lua/conf/ 目录下
```
-- https://github.com/lewis6991/gitsigns.nvim
-- TODO: 您也可以绑定一些快捷键位快速查看 git 信息
-- 参见：https://github.com/lewis6991/gitsigns.nvim/#keymaps
​
require("gitsigns").setup(
    {
      -- 设置在左侧的行号列中显示的 git 信息
      signs = {
        add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
        change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
        delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
      },
​
    }
)
```

##### buffer栏美化
bufferline  
当开启多个文件时，我们希望 neovim 顶部能拥有不同的标签页，此时就需要使用 [bufferline](https://github.com/akinsho/bufferline.nvim)插件。  
其它同类型插件：
- [barbar](https://github.com/romgrk/barbar.nvim)
- [luatab](https://github.com/alvarosevilla95/luatab.nvim)
安装
```
-- 支持 LSP 状态的 buffer 栏
use {
    "akinsho/bufferline.nvim",
    requires = {
        "famiu/bufdelete.nvim" -- 删除 buffer 时不影响现有布局
    },
    config = function()
        require("conf.bufferline")
    end
}
```
新建文件 buffline.lua 到 lua/conf/ 目录下
```
-- https://github.com/akinsho/bufferline.nvim
​
require("bufferline").setup(
    {
        options = {
            -- 为每个 buffer 都配置一个序数
            numbers = "ordinal",
            -- 使用内置 LSP 进行诊断
            diagnostics = "nvim_lsp",
            -- 不建议更改图标
            indicator_icon = "▎",
            buffer_close_icon = "",
            modified_icon = "●",
            close_icon = "",
            left_trunc_marker = "",
            right_trunc_marker = "",
            -- 分割符样式："slant" | "thick" | "thin"
            -- 如果是透明背景，不推荐使用 slant
            separator_style = "thin",
            -- 左侧让出 nvim-tree 的位置
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "File Explorer",
                    highlight = "Directory",
                    text_align = "left"
                }
            },
            -- 显示 LSP 报错图标
            diagnostics_indicator = function(count, level, diagnostics_dict, context)
                local s = " "
                for e, n in pairs(diagnostics_dict) do
                    local sym = e == "error" and " " or (e == "warning" and " " or "")
                    s = s .. n .. sym
                end
                return s
            end
        }
    }
)
​
-- 关闭当前 buffer，由 bufdelete 插件所提供的方法
vim.keybinds.gmap("n", "<C-q>", "<cmd>Bdelete!<CR>", vim.keybinds.opts)
-- 切换上一个缓冲区
vim.keybinds.gmap("n", "<C-h>", "<cmd>BufferLineCyclePrev<CR>", vim.keybinds.opts)
-- 切换下一个缓冲区
vim.keybinds.gmap("n", "<C-l>", "<cmd>BufferLineCycleNext<CR>", vim.keybinds.opts)
-- 关闭左侧缓冲区
vim.keybinds.gmap("n", "<leader>bh", "<cmd>BufferLineCloseLeft<CR>", vim.keybinds.opts)
-- 关闭右侧缓冲区
vim.keybinds.gmap("n", "<leader>bl", "<cmd>BufferLineCloseRight<CR>", vim.keybinds.opts)
```