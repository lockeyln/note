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
lua中pcall函数提供了一种安全的环境来运行函数，同时会捕获函数运行时的异常。
pcall接收一个函数和要传递个后者的参数，并执行，执行结果：有错误、无错误；返回值true或者或false, errorinfo
```
