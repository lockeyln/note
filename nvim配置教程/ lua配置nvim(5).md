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