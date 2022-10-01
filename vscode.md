### vim配置

1. vim.handlerKeys //可以屏蔽一些快捷操作
2. vim.Insert Mode Key Bindings //映射快捷操作

### code runner输出中文乱码

```
"code-runner.runInTerminal": true,
"code-runner.executorMap": {
        "python": "set PYTHONIOENCODING=utf8 && python", 
},
```
