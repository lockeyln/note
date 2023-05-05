## Vim中无法用Alt键来映射

  > Alt+key（<A+key>)的格式设置不成功，将"<A+key>“的输入格式改为”^[key"

  **注意：这里的"^[key"不是直接将符号打上去的，正确输入方式：在插入模式下，先按下 Crtl+v会出现^ ,后再按下 Alt+key（想设置的键）**
  
  
## 符号$ & command!

```
:set textwidth=80
:echo &textwidth
```
- Vim会显示80。在名称的前面加一个&符号是告诉Vim你正在引用这个选项，而不是在使用一个名称刚好相同的变量。

```
:set nowrap
:echo &wrap
```
- Vim显示0
