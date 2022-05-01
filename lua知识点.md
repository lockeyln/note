##### 虚变量
```
--[[变量下划线_有特殊名字叫虚变量（哑变量、虚拟变量、名义变量），使用虚变量（即下划线）来存储丢弃不需要的数值，
    所以，虚变量即没有现实意义的变量
--]]
for _, n in ipairs(t) do
        set[n] = true
        -- print(set[n])
        print(_)
        print(n)
end
```
##### pcall函数

```
lua中pcall函数是一种异常处理函数，提供了一种安全的环境来运行函数，同时会捕获函数运行时的异常。
pcall接收一个函数和要传递个后者的参数，并执行，执行结果：有错误、无错误；返回值true或者或false, errorinfo
```
##### return和break
> return和break后面的语句永远无法被执行

- \# 井号取字符串或table长度
- function常用写法
```
Lua 中可以将函数作为参数传递给函数(常见用法)
myprint = function(param)
   print("这是打印函数 -   ##",param,"##")
end
```
#### 类
- 访问属性：使用点号(.)来访问类的属性
- 访问方法：使用冒号(:)来访问类的成员函数
