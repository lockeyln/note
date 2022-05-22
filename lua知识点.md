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
pcall在保护模式（protected mode）下执⾏函数内容，同时捕获所有的异常和错误。若⼀切正常，pcall返回true以及“被执⾏函数”的返回
值；否则返回nil和错误信息。
```
##### return和break
> return和break后面的语句永远无法被执行  


- \# 井号取字符串或table长度
- Lua 中可以将函数作为参数传递给函数(常见用法)
```
变量 = function(参数1,参数2...)
    函数体
 end
 例如：
myprint = function(param)
   print("这是打印函数 -   ##",param,"##")
end
```
#### 类
- 访问属性：使用点号(.)来访问类的属性
- 访问方法：使用冒号(:)来访问类的成员函数
```
访问成员方法也可以用点.
冒号的作用就是：定义函数时，给函数的添加隐藏的第一个参数self，调用函数时，默认把当前调用者作为第一个参数传递进去。
使用了冒号之后，就相当于使用点号时第一个参数为self一样，只是不再需要显式地定义self参数以及主动地传递参数。
```
#### vim.fn
> 作用与vim.call()一样，调用函数  

#### 布尔值
> bool只有两个可选值：false和true。lua把false和nil看作是false，其他的都是true，数字0也是true  

#### 三元表达式
语法  
> 条件 and 真 or 假  
```
local name = "hello"
local result = name == "hello" and "I know you" or "I don't know you"
print(result)
-- I know you
```
#### 作用域
在 Lua 中，所有变量都具有全局作用域和局部作用域之分。

未经 local 声明的函数或变量都将存储在全局对象 _G 中。

全局对象 _G 类似于 Javascript 中的 window 对象，这意味这你可以在任意地方调用到该全局变量。

而被 local 声明的变量只能在当前模块中调用。

所以在声明函数或变量时，我们应该为其加上 local 前缀，否则可能会造成命名冲突的情况发生：
```
A = "GLOBAL"

-- 下面两种访问方式是一样的，类似于 js 中的 window.A 与 A
print(A) -- GLOBAL
print(_G.A) -- GLOBAL

local a = "local" -- local

print(a)
```
#### 闭包
由于 Lua 中的函数可以被赋值，这意味着函数也可以被当作参数传递。

闭包函数在 neovim 中书写一些配置项时可能会被用到，它的定义如下  
```
local function set(conf)
    return function()
        print(conf.a) -- 1
        print(conf.b) -- 2
    end
end

local inner = set({ a = 1, b = 2 })

-- 其实 inner 更多的是作为一个 callbackfn 被调用
inner()
```

#### 元表
当定义一个 table 时，我们可以为该 table 定义 __call 方法以此规定该 table 被调用时的处理逻辑（和 Python 的元类 __call__ 很像）。

也可以为该 table 定义 __index 方法来继承另一个 table。  

```
local metatable = {
    f1 = function()
        print("metatable f1 ...")
    end,
    f2 = function()
        print("metatable f2")
    end,
}

-- 第一个 {} 是一个对象本身，第二个 {} 代表它的行为
-- 通过 __index 第一个 {} 继承了 第二个 {}
local obj = setmetatable({}, {
    __call = function()
        print("__call ...")
    end,
    __index = metatable,
})

obj()
obj.f1()
obj.f2()

-- __call ...
-- metatable f1 ...
-- metatable f2
```
