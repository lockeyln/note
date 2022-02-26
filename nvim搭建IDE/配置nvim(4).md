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
##### 缩进线indent-blankline
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

##### 单词取反switch
安装
```
-- 快速更改单词
use {
    "AndrewRadev/switch.vim",
    config = function()
        require("conf.switch")
    end
}
```
新建文件 switch.lua 到 lua/conf/ 目录下
```
-- https://github.com/AndrewRadev/switch.vim
​
-- NOTE: switch 手动定义需要增加的反意单词
local switch_words = {
    {"true", "false"},
    {"on", "off"},
    {"yes", "no"},
    {"disable", "enable"},
    {"+", "-"},
    {">", "<"},
    {"=", "!="}
}
​
-- enable Enable ENABLE
​
-- 定义增加单词的容器
local push_words = {}
​
for _, value in ipairs(switch_words) do
    local w1, w2 = value[1], value[2]
    -- 全小写
    table.insert(push_words, value)
    -- 全大写
    table.insert(push_words, {string.upper(w1), string.upper(w2)})
    -- 首字母大写，%l 代表小写字母，只取第一个
    w1, _ = string.gsub(w1, "^%l", string.upper)
    w2, _ = string.gsub(w2, "^%l", string.upper)
    table.insert(push_words, {w1, w2})
end
​
-- 放入全局变量
vim.g.switch_custom_definitions = push_words
​
-- 快速取反意单词，如 true 变为 false
vim.keybinds.gmap("n", "gs", ":Switch<CR>", vim.keybinds.opts)
```
##### 快速跳转hop
安装
```
-- 快速跳转
use {
    "phaazon/hop.nvim",
    config = function()
        require("conf.hop")
    end
}
```
新建文件 hop.lua 到 lua/conf/ 目录下
```
-- https://github.com/phaazon/hop.nvim
​
require("hop").setup()
​
-- 搜索并跳转到单词
vim.keybinds.gmap("n", "<leader>hw", "<cmd>HopWord<CR>", vim.keybinds.opts)
-- 搜索并跳转到行
vim.keybinds.gmap("n", "<leader>hl", "<cmd>HopLine<CR>", vim.keybinds.opts)
-- 搜索并跳转到字符
vim.keybinds.gmap("n", "<leader>hc", "<cmd>HopChar1<CR>", vim.keybinds.opts)

```

##### 包裹surround
安装
```
-- 包裹修改
use {
    "ur4ltz/surround.nvim",
    config = function()
        require("conf.surround")
    end
}
```
新建文件 surround.lua 到 lua/conf/ 目录下
```
-- https://github.com/ur4ltz/surround.nvim
​
require("surround").setup(
    {
        mappings_style = "surround"
    }
)
​
-- cs 字符 字符：修改包裹
-- ds 字符     ：删除包裹
-- ys 范围 字符：增加包裹
```

##### 高亮当前文档中与光标下相同的词汇 vim-illuminate

##### 显示单词的拼写错误 spellsitter