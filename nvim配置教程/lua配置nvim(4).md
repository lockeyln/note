##### 搜索高亮nvim-hlslens
安装
```
-- 搜索时显示条目
use {
    "kevinhwang91/nvim-hlslens",
    config = function()
        require("conf.nvim-hlslens")
    end
}

```
新建文件 nvim-hlslens.lua 到 lua/conf/ 目录下
```
-- https://github.com/kevinhwang91/nvim-hlslens
​
-- 其实不用管下面这些键位绑定是什么意思，总之按下这些键位后会出现当前搜索结果的条目数量
vim.keybinds.gmap(
    "n",
    "n",
    "<Cmd>execute('normal!'.v:count1.'n')<CR><Cmd>lua require('hlslens').start()<CR>",
    vim.keybinds.opts
)
vim.keybinds.gmap(
    "n",
    "N",
    "<Cmd>execute('normal!'.v:count1.'N')<CR><Cmd>lua require('hlslens').start()<CR>",
    vim.keybinds.opts
)
vim.keybinds.gmap("n", "*", "*<Cmd>lua require('hlslens').start()<CR>", vim.keybinds.opts)
vim.keybinds.gmap("n", "#", "#<Cmd>lua require('hlslens').start()<CR>", vim.keybinds.opts)
vim.keybinds.gmap("n", "g*", "g*<Cmd>lua require('hlslens').start()<CR>", vim.keybinds.opts)
vim.keybinds.gmap("n", "g#", "g#<Cmd>lua require('hlslens').start()<CR>", vim.keybinds.opts)

```
##### 缩进indent-blankline
安装
```
-- 显示缩进线
use {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
        require("conf.indent-blankline")
    end
}
```
新建文件 indent-blankline.lua 到 lua/conf/ 目录下
```
-- https://github.com/lukas-reineke/indent-blankline.nvim
​
require("indent_blankline").setup(
    {
        -- 显示当前所在区域
        show_current_context = true,
        -- 显示当前所在区域的开始位置
        show_current_context_start = true,
        -- 显示行尾符
        show_end_of_line = true
    }
)
```
##### 自动补全括号nvim-autopairs
安装
```
-- 自动匹配括号
use {
    "windwp/nvim-autopairs",
    config = function()
        require("conf.nvim-autopairs")
    end
}
```
新建文件 nvim-autopairs.lua 到 lua/conf/ 目录下
```
-- https://github.com/windwp/nvim-autopairs
require("nvim-autopairs").setup()
```