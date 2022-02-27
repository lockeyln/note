本章节主要讲怎么使用 DAP 进行代码调试，需要使用 3 个插件：
- [nvim-dap](https://github.com/mfussenegger/nvim-dap) ：基础插件
- [nvim-dap-virtual-text](https://github.com/theHamsta/nvim-dap-virtual-text)：显示内联信息
- [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)：显示调试界面  

关于 DAP 是什么这里不做过多介绍，感兴趣的可以 google。  

```
-- 代码调试基础插件
use {
    "mfussenegger/nvim-dap",
    config = function()
        require("conf.nvim-dap")
    end
}
                                              
-- 为代码调试提供内联文本
use {
    "theHamsta/nvim-dap-virtual-text",
    requires = {
        "mfussenegger/nvim-dap"
    },
    config = function()
        require("conf.nvim-dap-virtual-text")
    end
}
                                              
-- 为代码调试提供 UI 界面
use {
    "rcarriga/nvim-dap-ui",
    requires = {
        "mfussenegger/nvim-dap"
    },
    config = function()
        require("conf.nvim-dap-ui")
    end
}
```

在 lua/conf/ 目录下新建 nvim-dap-virtual-text.lua 文件，当调试器启动时会显示变量的内联信息，当调试器关闭时会自动关闭变量的内联信息：
```
-- https://github.com/theHamsta/nvim-dap-virtual-text
​
require("nvim-dap-virtual-text").setup()
```

在 lua/conf/ 目录下新建 nvim-dap-ui.lua 文件，当调试器启动时会启动调试的 UI 界面，当调试器关闭时会自动关闭调试的 UI 界面：
```
-- https://github.com/rcarriga/nvim-dap-ui
​
local dap = require("dap")
local dapui = require("dapui")
​
-- 初始化调试界面
dapui.setup(
    {
        sidebar = {
            -- dapui 的窗口设置在右边
            position = "right"
        }
    }
)
​
-- 如果开启或关闭调试，则自动打开或关闭调试界面
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
    dap.repl.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
    dap.repl.close()
end
-- 显示或隐藏调试界面
vim.keybinds.gmap("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<CR>", vim.keybinds.opts)
```

在 lua/conf/ 目录下新建 nvim-dap.lua 文件，复制粘贴以下代码：
```
-- https://github.com/mfussenegger/nvim-dap
​
-- WARN: dap 手动下载调试器
-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
​
local dap = require("dap")
​
-- 设置断点样式
vim.fn.sign_define("DapBreakpoint", {text = "⊚", texthl = "TodoFgFIX", linehl = "", numhl = ""})
​
-- 加载调试器配置
local dap_config = {
    python = require("dap.python"),
    -- go = require("dap.go")
}
​
-- 设置调试器
for dap_name, dap_options in pairs(dap_config) do
    dap.adapters[dap_name] = dap_options.adapters
    dap.configurations[dap_name] = dap_options.configurations
end
​
-- 打断点
vim.keybinds.gmap("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", vim.keybinds.opts)
-- 开启调试或到下一个断点处
vim.keybinds.gmap("n", "<F5>", "<cmd>lua require'dap'.continue()<CR>", vim.keybinds.opts)
-- 单步进入执行（会进入函数内部，有回溯阶段）
vim.keybinds.gmap("n", "<F6>", "<cmd>lua require'dap'.step_into()<CR>", vim.keybinds.opts)
-- 单步跳过执行（不进入函数内部，无回溯阶段）
vim.keybinds.gmap("n", "<F7>", "<cmd>lua require'dap'.step_over()<CR>", vim.keybinds.opts)
-- 步出当前函数
vim.keybinds.gmap("n", "<F8>", "<cmd>lua require'dap'.step_out()<CR>", vim.keybinds.opts)
-- 重启调试
vim.keybinds.gmap("n", "<F9>", "<cmd>lua require'dap'.run_last()<CR>", vim.keybinds.opts)
-- 退出调试（关闭调试，关闭 repl，关闭 ui，清除内联文本）
vim.keybinds.gmap(
    "n",
    "<F10>",
    "<cmd>lua require'dap'.close()<CR><cmd>lua require'dap.repl'.close()<CR><cmd>lua require'dapui'.close()<CR><cmd>DapVirtualTextForceRefresh<CR>",
    vim.keybinds.opts
)
```

##### 调试器配置
在 lua/conf/nvim-dap.lua 文件中，我们有一个加载调试器配置的选项：
```
-- 加载调试器配置
local dap_config = {
    python = require("dap.python"),
    -- go = require("dap.go")
}
```
这意味着我们需要为不同语言的调试书写配置文件，配置文件书写方式参见：
- [调试器下载和配置](https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation)  

以 Python 举例，在 lua/dap/ 目录中新建 python.lua 文件，并参照上述链接的调试器配置为其做适当修改：
```
-- python3 -m pip install debugpy
​
return {
    adapters = {
        type = "executable",
        command = "python3",
        args = {"-m", "debugpy.adapter"}
    },
    configurations = {
        {
            type = "python",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            pythonPath = function()
                return vim.g.python_path
            end
        }
    }
}
```

上面 configurations 的 table 中，我们指定了 pythonPath 是 vim.g.python_path，所以可以在 lua/basic/config.lua 中新增 vim.g.python_path：
```
-- 指定 Python 解释器路径
vim.g.python_path = "/usr/bin/python3.8"
```
Python 的调试器配置写完后，需要安装 debugpy 模块：
```
$ python3 -m pip install debugpy
```

最终效果
![输入图片说明](../image/pydebug%E6%95%88%E6%9E%9C.webp)

##### golang 调试器配置

```
-- pacman -S delve
-- go install github.com/go-delve/delve/cmd/dlv@latest
​
return {
    adapters = function(callback, _) -- _ = config
        local stdout = vim.loop.new_pipe(false)
        local handle
        local pid_or_err
        local port = 38697
        local opts = {
            stdio = {nil, stdout},
            args = {"dap", "-l", "127.0.0.1:" .. port},
            detached = true
        }
        handle, pid_or_err =
            vim.loop.spawn(
            "dlv",
            opts,
            function(code)
                stdout:close()
                handle:close()
                if code ~= 0 then
                    print("dlv exited with code", code)
                end
            end
        )
        assert(handle, "Error running dlv: " .. tostring(pid_or_err))
        stdout:read_start(
            function(err, chunk)
                assert(not err, err)
                if chunk then
                    vim.schedule(
                        function()
                            require("dap.repl").append(chunk)
                        end
                    )
                end
            end
        )
        -- Wait for delve to start
        vim.defer_fn(
            function()
                callback({type = "server", host = "127.0.0.1", port = port})
            end,
            100
        )
    end,
    configurations = {
        {
            type = "go",
            name = "Debug",
            request = "launch",
            program = "${file}"
        },
        {
            type = "go",
            name = "Debug test", -- configuration for debugging test files
            request = "launch",
            mode = "test",
            program = "${file}"
        },
        -- works with go.mod packages and sub packages
        {
            type = "go",
            name = "Debug test (go.mod)",
            request = "launch",
            mode = "test",
            program = "./${relativeFileDirname}"
        }
    }
}
```

#### 关于DAP（Debug Adapter Protocol）介绍
1. 调试器（debugger）  
> 编程语言是用debugger调试的，有些debugger可以用来调试多种编程语言，  
  例如，GDB，它支持Assembly，C，C++，Go，Rust，等等。  
  有些编程语言有自己的debugger，例如，Haskell的GHCi，有些debugger集成到了IDE中，例如，DrRacket中。 
 
因为无法用平凡的办法证明程序没有错误，所以能对程序进行调试还是很必要的，

2. 编辑器扩展
> 编辑器为了能对特定的编程语言进行调试，需要增加编写扩展，例如，Emacs可以使用python-mode，调用pdb调试python代码。  
  内部都是调用了相应编程语言的debugger，调试功能也大同小异。一般而言，不同的编辑器需要单独编写自己的调试模块或者扩展，  
  并且，同一个编辑器中，不同编程语言的调试模块也是不同的，如下图。  

![输入图片说明](../image/debug%E8%B0%83%E8%AF%95.webp)     
这样不论对编辑器开发者而言，还是对语言供应商而言，都是一个灾难。

3. DAP
> 介于此，微软提出了Debug Adapter Protocol，各编辑器通过相同的协议与debugger通信。  
  可是，让现有的debugger满足这个协议是非常困难的，因此，还需要增加一层，就是为各个debugger编写适配器（Debug Adapter），整 
  体架构如下图。  
  
![输入图片说明](../image/DAP%E6%9E%B6%E6%9E%84.webp)  
不同的编辑器通过统一的DAP（Debug Adapter Protocol）协议与各个debugger对应的适配器（Debug Adapter）通信，  
这样大大降低了开发难度，创造了一个双赢局面。

##### DAP工作原理
```
调试过程总共涉及了三个角色，
编辑器（Editor，IDE），调试适配器（Debug Adapter），调试器（debuger）（包括被调试对象（debuggee））。

（1）调试会话（debug session)
调试过程是通过会话（session）来完成的，会话指的是编辑器与调试适配器（Debug Adapter）之间的交互过程。
它们之间通过DAP（Debug Adapter Protocol）通信。

总共有两种会话模式，single session mode 和 multi session mode。
前者调试适配器（Debug Adapter）进程是由编辑器启动的，通过标准输入输出进行交互，调试结束后，该进程会被终止。
后者，编辑器会假定调试适配器（Debug Adapter）已经启动了，然后通过唯一端口号与调试适配器（Debug Adapter）建立连接。
编辑器终止会话，只是与调试适配器（Debug Adapter）断开连接。

（2）初始化
DAP（Debug Adapter Protocol）定义了很多调试特性，并且这个特性列表还在不断增加，
为了避免使用版本号进行区分，为了兼容性考虑，
编辑器和调试适配器（Debug Adapter）之间，在初始化时，要互相通信，
借此让编辑器了解，调试适配器（Debug Adapter）支持哪些调试特性，这些特性合集称为能力（capabilities）。

（3）调试方式
调试配置器（Debug Adapter）有两种方式启动调试，launch 和 attach。

attach方式，调试适配器（Debug Adapter）会通过调试器（debugger）与一个已经在运行的程序建立连接，
用户可以启动和终止这个程序。

launch方式，由调试适配器（Debug Adapter）启动被调试的程序，通过调试器（debugger）与之建立连接，
被调试程序的启动和终止都是由调试适配器（Debug Adapter）负责的。

（4）设置断点
断点以及异常相关的配置，是在程序启动之前由编辑器传递给调试适配器（Debug Adapter）的，
因为不同的调试器（debugger）对于何时使用断点信息有不同的原则，
一些调试器（debugger）要提前知道断点信息，有些则不用。

因此，编辑器会在启动调试之前，先把断点信息传递给调试适配器（Debug Adapter）。

![输入图片说明](../image/DAP%E5%B7%A5%E4%BD%9C%E5%8E%9F%E7%90%86.webp)  

（5）调用栈信息与局部变量
调试适配器（Debug Adapter）会在断点处，向调试器（debugger）发送停止信号，
程序停止后，编辑器会再通过调试适配器（Debug Adapter）请求获取调用栈信息（stacktrace）。

在调试过程中，通常用户还需要查看局部变量的值，
编辑器会再次发送请求，通过调试适配器（Debug Adapter）获取所有的局部变量名以及它们的值。
```


