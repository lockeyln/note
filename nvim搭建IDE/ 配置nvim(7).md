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


