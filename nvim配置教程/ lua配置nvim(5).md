本章节最重要的事情就是增强 neovim 的一些内置功能，让它看起来更像是一款现代化的 IDE
##### 自动保存AutoSave
```
-- 自动保存
use {
    "Pocco81/AutoSave.nvim",
    config = function()
        require("conf.AutoSave")
    end
}
```
新建文件 AutoSave.lua 到 lua/conf/ 目录下
```
-- https://github.com/Pocco81/AutoSave.nvim
​
require("autosave").setup(
    {
        enabled = true,
        -- 触发自动保存的事件（退出插入模式或者普通模式下文本内容发生改变）
        events = {"InsertLeave", "TextChanged"},
        -- 自动保存时的提示信息
        execution_message = "",
        conditions = {
            exists = true,
            -- 忽略自动保存的文件名字或文件类型
            filename_is_not = {},
            filetype_is_not = {},
            modifiable = true
        },
        -- 保存时写入全部的 Buffer
        write_all_buffers = true,
        on_off_commands = false,
        clean_command_line_interval = 0,
        debounce_delay = 135
    }
)
```
默认是离开插入模式或正常模式下修改了文本才触发自动保存，你可以将它设置的更激进，  
比如加上 TextChangedI 事件，即使在插入模式下修改内容也会触发自动保存，看个人取舍。
另外需要注意，该插件生效后，实时生效插件配置的自动命令可能会频繁的抛出异常，  
可以选择将该自动命令注释掉，也可以不注释而忽略异常，都无伤大雅。

##### 恢复光标位置nvim-lastplace
当你在一个文件中退出 neovim 后，下次再次打开这个文件，通过 nvim-lastplace 插件的加持，光标会停留在上次编辑时的位置
```
-- 自动恢复光标位置
use {
    "ethanholz/nvim-lastplace",
    config = function()
        require("conf.nvim-lastplace")
    end
}
```
新建文件 nvim-lastplace.lua 到 lua/conf/ 目录下
```
-- https://github.com/ethanholz/nvim-lastplace
​
require("nvim-lastplace").setup(
    {
        -- 那些 buffer 类型不记录光标位置
        lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
        -- 那些文件类型不记录光标位置
        lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit"},
        lastplace_open_folds = true
    }
)
```

##### 自动会话管理auto-session
保存上次退出 neovim 时的会话状态，如上次会话开了多少文件，窗口布局是什么样子等。  
如果直接输入 nvim 不带任何文件路径启动，将自动恢复上次会话状态。  
如果输入 nvim 后面有文件路径，就不会恢复上次的会话状态，这种情况下，仍然可以通过输入命令：RestoreSession 来恢复上次的会话状态。
```
-- 自动会话管理
use {
    "rmagatti/auto-session",
    config = function()
        require("conf.auto-session")
    end
}
```
新建文件 auto-session.lua 到 lua/conf/ 目录下
```
-- https://github.com/rmagatti/auto-session
​
-- 推荐设置
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
​
require("auto-session").setup(
    {
        -- 自动加载最后保存的一次会话
        auto_session_enable_last_session = true,
        -- 保存会话时自动关闭 nvim-tree
        -- 这是因为 nvim-tree 如果处于开启
        -- 状态，会破坏会话的保存
        pre_save_cmds = {"tabdo NvimTreeClose"}
    }
)
​
-- 在每次退出 neovim 时自动保存会话
-- 其实该插件不加这个自动命令也能
-- 自动保存会话，但总是感觉效果不理想
-- 所以这里我就自己加了个自动命令
vim.cmd([[
    autocmd VimLeavePre * silent! :SaveSession
]])
```

##### 全局替换nvim-spectre
在当前工作区目录下跨多个文件修改某段字符串是非常常用的功能，比如 vscode 中的模糊搜索就非常好用。  
该插件需要一个可选外部依赖 sed 命令和 ripgrep。  
```
wget https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
sudo dpkg -i ripgrep_13.0.0_amd64.deb
```
```
-- 全局替换
use {
    "nvim-pack/nvim-spectre",
    requires = {
        "nvim-lua/plenary.nvim", -- Lua 开发模块
        "BurntSushi/ripgrep" -- 文字查找
    },
    config = function()
        require("conf.nvim-spectre")
    end
}
```
新建文件 nvim-spectre.lua 到 lua/conf/ 目录下
```
-- https://github.com/nvim-pack/nvim-spectre
​
-- WARN: spectre 手动安装依赖项 sed 和 ripgrep
-- sed 命令（自行安装，如果已有则忽略）
-- repgrep： https://github.com/BurntSushi/ripgrep
​
require("spectre").setup(
    {
        mapping = {
            -- 删除选中
            ["toggle_line"] = {
                map = "dd",
                cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
                desc = "toggle current item"
            },
            -- 前往文件
            ["enter_file"] = {
                map = "<CR>",
                cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
                desc = "goto current file"
            },
            -- 查看菜单（忽略大小写、忽略隐藏文件）
            ["show_option_menu"] = {
                map = "<leader>o",
                cmd = "<cmd>lua require('spectre').show_options()<CR>",
                desc = "show option"
            },
            -- 开始替换
            ["run_replace"] = {
                map = "<leader>r",
                cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
                desc = "replace all"
            },
            -- 显示差异
            ["change_view_mode"] = {
                map = "<leader>v",
                cmd = "<cmd>lua require('spectre').change_view()<CR>",
                desc = "change result view mode"
            }
        }
    }
)
​
-- 全项目替换
vim.keybinds.gmap("n", "<leader>rp", "<cmd>lua require('spectre').open()<CR>", vim.keybinds.opts)
-- 只替换当前文件
vim.keybinds.gmap("n", "<leader>rf", "viw:lua require('spectre').open_file_search()<CR>", vim.keybinds.opts)
-- 全项目中搜索当前单词
vim.keybinds.gmap("n", "<leader>rw", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", vim.keybinds.opts)
```

##### 多光标模式vim-multiple-cursors
vim-multiple-cursors 是一款 viml 插件，它能够生成多个光标选择同一个单词然后一起操作，缺点是比较卡。
```
-- 多光标模式
use {
    "terryma/vim-multiple-cursors",
    config = function()
        require("conf.vim-multiple-cursors")
    end
}
```
新建文件 vim-multiple-cursors.lua 到 lua/conf/ 目录下
```
-- https://github.com/terryma/vim-multiple-cursors
​
-- 关闭默认键位绑定
vim.g.multi_cursor_use_default_mapping = 0
​
-- 应用键位
-- 开始选择单词
vim.g.multi_cursor_start_word_key = "gb"
-- 向后选择
vim.g.multi_cursor_next_key = "<C-n>"
-- 取消当前选择
vim.g.multi_cursor_prev_key = "<C-p>"
-- 跳过选择
vim.g.multi_cursor_skip_key = "<C-b>"
-- 退出选择
vim.g.multi_cursor_quit_key = "<ESC>"
```

##### 侧边栏滚动条nvim-scrollbar
配合 LSP 能显示一些当前文档的诊断信息。
```
-- 显示滚动条
use {
    "petertriho/nvim-scrollbar",
    config = function()
        require("conf.nvim-scrollbar")
    end
}
```
新建文件 nvim-scrollbar.lua 到 lua/conf/ 目录下
```
-- https://github.com/petertriho/nvim-scrollbar
​
local colors = {
    color = "#292E42",
    Search = "#FC867",
    Error = "#FD6883",
    Warn = "#FFD886",
    Info = "A9DC76",
    Hint = "#78DCE8",
    Misc = "#AB9DF2"
}
​
require("scrollbar").setup(
    {
        handle = {
            -- 滚动条颜色
            color = colors.color
        },
        marks = {
            -- 诊断颜色，需要 LSP 支持
            Search = {color = colors.Search},
            Error = {color = colors.Error},
            Warn = {color = colors.Warn},
            Info = {color = colors.Info},
            Hint = {color = colors.Hint},
            Misc = {color = colors.Misc}
        }
    }
)
```
##### 显示网页色nvim-colorizer
对于编辑 CSS 来说，nvim-colorizer 绝对算的上一款神器，它可以在当前编辑器中显示 #16 进制的颜色。
```
-- 显示网页色
use {
    "norcalli/nvim-colorizer.lua",
    config = function()
        require("conf.nvim-colorizer")
    end
}
```
新建文件 nvim-colorizer.lua 到 lua/conf/ 目录下
```
-- https://github.com/norcalli/nvim-colorizer.lua
​
require("colorizer").setup()
```

##### 内置终端toggleterm
neovim 虽然拥有内置终端，但该终端的使用体验非常不好。  
通过 toggleterm 插件，能够让默认终端变得既好看又好用。
```
-- 内置终端
use {
    "akinsho/toggleterm.nvim",
    config = function()
        require("conf.toggleterm")
    end
}
```
新建文件 toggleterm.lua 到 lua/conf/ 目录下  
PS：另外强烈推荐命令行 git 神器 lazygit，可自行下载该软件，下面的配置已经将 lazygit 集成进来了
```
-- https://github.com/akinsho/toggleterm.nvim
​
local Toggleterm = require("toggleterm")
​
Toggleterm.setup(
    {
        --  开启的终端默认进入插入模式
        start_in_insert = true,
        -- 设置终端打开的大小
        size = 6,
        -- 打开普通终端时，关闭拼写检查
        on_open = function()
            vim.cmd("setlocal nospell")
        end
    }
)
​
-- 新建终端
local Terminal = require("toggleterm.terminal").Terminal
​
local function inInsert()
    -- 删除 Esc 的映射
    vim.keybinds.dgmap("t", "<Esc>")
end
​
-- 新建浮动终端
local floatTerm =
    Terminal:new(
    {
        hidden = true,
        direction = "float",
        float_opts = {
            border = "double"
        },
        on_open = function(term)
            inInsert()
            -- 浮动终端中 Esc 是退出
            vim.keybinds.bmap(term.bufnr, "t", "<Esc>", "<C-\\><C-n>:close<CR>", vim.keybinds.opts)
        end,
        on_close = function()
            -- 重新映射 Esc
            vim.keybinds.gmap("t", "<Esc>", "<C-\\><C-n>", vim.keybinds.opts)
        end
    }
)
​
-- 新建 lazygit 终端
local lazyGit =
    Terminal:new(
    {
        cmd = "lazygit",
        hidden = true,
        direction = "float",
        float_opts = {
            border = "double"
        },
        on_open = function(term)
            inInsert()
            -- lazygit 中 q 是退出
            vim.keybinds.bmap(term.bufnr, "i", "q", "<cmd>close<CR>", vim.keybinds.opts)
        end,
        on_close = function()
            -- 重新映射 Esc
            vim.keybinds.gmap("t", "<Esc>", "<C-\\><C-n>", vim.keybinds.ns_opt)
        end
    }
)
​
-- 定义新的方法
Toggleterm.float_toggle = function()
    floatTerm:toggle()
end
​
Toggleterm.lazygit_toggle = function()
    lazyGit:toggle()
end
​
-- 退出终端插入模式
vim.keybinds.gmap("t", "<Esc>", "<C-\\><C-n>", vim.keybinds.opts)
-- 打开普通终端
vim.keybinds.gmap("n", "<leader>tt", "<cmd>exe v:count.'ToggleTerm'<CR>", vim.keybinds.opts)
-- 打开浮动终端
vim.keybinds.gmap("n", "<leader>tf", "<cmd>lua require('toggleterm').float_toggle()<CR>", vim.keybinds.opts)
-- 打开lazy git 终端
vim.keybinds.gmap("n", "<leader>tg", "<cmd>lua require('toggleterm').lazygit_toggle()<CR>", vim.keybinds.opts)
-- 打开或关闭所有终端
vim.keybinds.gmap("n", "<leader>ta", "<cmd>ToggleTermToggleAll<CR>", vim.keybinds.opts)
​
-- 要需创建多个终端，可：
-- 1 <键位> leader tt
-- 2 <键位>
-- ... <键位>
-- 另外，上面我们新建了 2 个特殊终端，所以普通终端的顺序应该是从 3 开始
```

##### undotree
很多编辑器包括 vscode 在内，一经退出后 redo 和 undo 都没办法继续执行了。  
但是 neovim 通过 undotree 插件（虽然是 viml 插件，但是强大到无与伦比），  
可以缓存该文件所有的变更记录，即使你中途退出了 neovim 但 u 和 <C-r> 的功能依旧不会失效。
> 首先我们需要在 lua/basic/config.lua 中定义好需要缓存的路径：  
  -- 指定 undotree 缓存存放路径
  vim.g.undotree_dir = "~/.cache/nvim/undodir"
```
-- undo tree
use {
    "mbbill/undotree",
    config = function()
        require("conf.undotree")
    end
}
```
新建文件 undotree.lua 到 lua/conf/ 目录下
```
-- https://github.com/mbbill/undotree
​
vim.cmd(
    [[
if has("persistent_undo")
    " 在 config.lua 中定义好了 undotree_dir 全局变量
    let target_path = expand(undotree_dir)
    if !isdirectory(target_path)
        call mkdir(target_path, "p", 0700)
    endif
    let &undodir = target_path
    set undofile
]]
)
​
-- 按键绑定，查看 undotree
vim.keybinds.gmap("n", "<leader>3", ":UndotreeToggle<CR>", vim.keybinds.opts)
```
##### 键位绑定器which-key
which-key 插件有很多功能：
- 能够绑定键位，自定义按键描述（未使用，感兴趣可自行查看 github 主页）
- 能够查看你的键位（默认启用）
- 能够查看剪切板（默认启用）
- 能够查看 marks（默认启用）
- 能够接管 z= 的单词拼写建议提示（默认未启用，下面会启用它，这个很方便）
```
-- 键位绑定器
use {
    "folke/which-key.nvim",
    config = function()
        require("conf.which-key")
    end
}
```
新建文件 which-key.lua 到 lua/conf/ 目录下
```
-- https://github.com/folke/which-key.nvim
​
require("which-key").setup(
    {
        plugins = {
            spelling = {
                -- 是否接管默认 z= 的行为
                enabled = true,
                suggestions = 20
            }
        }
    }
)
```

##### 模糊查找telescope
它能够模糊搜索文件、文字、文档等非常多的资源。  
该插件有 2 个外部依赖，[fd](https://github.com/sharkdp/fd) 和 [repgrep](https://github.com/BurntSushi/ripgrep)   
> sudo apt install fd-find
```
-- 模糊查找
use {
    "nvim-telescope/telescope.nvim",
    requires = {
        "nvim-lua/plenary.nvim", -- Lua 开发模块
        "BurntSushi/ripgrep", -- 文字查找
        "sharkdp/fd" -- 文件查找
    },
    config = function()
        require("conf.telescope")
    end
}
```
新建文件 telescope.lua 到 lua/conf/ 目录下
```
-- https://github.com/nvim-telescope/telescope.nvim
​
-- WARN: telescope 手动安装依赖 fd 和 repgrep
-- https://github.com/sharkdp/fd
-- https://github.com/BurntSushi/ripgrep
​
require("telescope").setup()
​
-- 查找文件
vim.keybinds.gmap("n", "<leader>ff", "<cmd>Telescope find_files theme=dropdown<CR>", vim.keybinds.opts)
-- 查找文字
vim.keybinds.gmap("n", "<leader>fg", "<cmd>Telescope live_grep theme=dropdown<CR>", vim.keybinds.opts)
-- 查找特殊符号
vim.keybinds.gmap("n", "<leader>fb", "<cmd>Telescope buffers theme=dropdown<CR>", vim.keybinds.opts)
-- 查找帮助文档
vim.keybinds.gmap("n", "<leader>fh", "<cmd>Telescope help_tags theme=dropdown<CR>", vim.keybinds.opts)
-- 查找最近打开的文件
vim.keybinds.gmap("n", "<leader>fo", "<cmd>Telescope oldfiles theme=dropdown<CR>", vim.keybinds.opts)
-- 查找 marks 标记
vim.keybinds.gmap("n", "<leader>fm", "<cmd>Telescope marks theme=dropdown<CR>", vim.keybinds.opts)
```
该插件有一些默认按键，该插件还能自定义外观 
```
<CR> 打开选中的搜索结果
<Tab> 选中当前的搜索结果，可搭配 <CR> 一次性打开多个
<C-v> 垂直拆分打开选中的搜索结果
<C-c> 退出搜索框
<C-n> 选择下一项目（插入模式下）
<C-p> 选择上一个项目（插入模式下）
j     选择下一个项目（普通模式下）
k     选择上一个项目（普通模式下）
```