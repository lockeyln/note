### 参考资料

- [VIM中文用户手册](https://yianwillis.github.io/vimcdoc/doc/help.html)
- [VIM教程](https://www.w3cschool.cn/vim/)
- [Vim Cheat Sheet](https://vim.rtorr.com/lang/zh_cn)
- [VIM手册](https://vim.rtorr.com/lang/zh_cn)
- [VIM学习笔记](http://yyq123.github.io/learn-vim/)
- [笨办法学vimscript](https://www.kancloud.cn/kancloud/learn-vimscript-the-hard-way/49321)

`Ctrl+C 等同于 ESC`

## 基础

| text objcet | 说明 |
| --- | --- |
| 名词 | w=word，s=sentence，p=paragraph，t=tag，单引号，双引号，小括号，中括号，大括号 |
| 动词 | y=yank，p=paste，d=delete，c=change， v=选择模式 |
| 范围 | i=inner a=a或around |
| 量词 | 数字 |


## 配置相关

### Vim中无法用Alt键来映射

1. Alt+key（<A+key>)的格式设置不成功，将"<A+key>“的输入格式改为”^[key"

    - 注意：这里的"^\[key"不是直接将符号打上去的，正确输入方式：在插入模式下，先按下 Crtl+v会出现^ ,后再按下 Alt+key

2. 通过<Esc>映射Alt
    
  ```
  terminal仿真器有两种方式发送一个Alt键（通常称为Meta键，因为实际的terminal没有Alt）。 它可以发送8位字符，并在使用Alt时设置高位，
  也可以使用转义序列，将Alt-a作为<Esc>a 。   
  Vim希望看到8位编码，而不是转义序列。有些terminal仿真程序（如xterm）可以设置为使用任一模式，但Gnometerminal不提供任何此类设置。 
  说实话，在Unicode编辑里，8位编码不是一个好主意。 但是转义序列也不是问题; 他们没有办法区分<Esc>j表示Alt-j与按Esc后跟j 。
  在早期的terminal使用中，键入Esc j是在没有Meta键的情况下在键盘上发送Meta的另一种方式，但是这不适合vi使用Esc离开插入模式。
  ```
  
  
### 关于符号 & 和 $ 

1. 关于符号&：&变量 表示vim选项,而不是普通的变量。

```
:set textwidth=80
:echo &textwidth
```
- 显示80

```
:set nowrap
:echo &wrap
```
- 显示0

2. 关于符号$：$变量 表示环境变量

### command!(自定义命令)

```
Vim编辑器允许定义自己的命令，我们可以像执行内置命令一样来执行我们自己定义的命令。

使用以下:command命令自定义命令：

:command Delete_first :1delete

注意自定义命令的名称，必须以大写字母开头；如果我们执行:Delete_first自定义命令，那么Vim就会执行:1delete命令，从而删除第一行。

可以使用!来强制重新定义同名的自定义命令：

:command! -nargs=+ Say :echo <args>

用户定义的命令可以指定一系列的参数，参数的个数由-nargs选项在命令行中指定。例如定义Delete_one命令没有参数：

:command Delete_one -nargs=0 1delete

默认情况下-nargs=0，所以可以省略。

在命令定义中，参数是由关键字<args>指定的：

:command -nargs=+ Say :echo "<args>

输入以下自定义命令：

:Say Hello World

命令的执行结果显示：

Hello World
```

### 技巧篇

- 暂时离开buffer到终端再回vim：
  1. Ctrl+z挂起vim到终端执行完任务再fg回到vim
  2. vim中使用命令模式下!command执行外部命令，按Enter键回到vim
