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
> bool只有两个可选值：false和true。lua只有false和nil看作是false，其他的都是true，数字0也是true  

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
---

### 基础
#### 注释
Lua 的行注释是 --，块注释是 --[[]]，如下示例：
```
-- Only one line

--[[
    Can be multiple lines
]]
```

#### 赋值
Lua 的赋值和其它动态编程语言类似，比如：
```
local num = 1
local str = "123"
```
也可以先定义后赋值，在赋值之前该变量的值 为 nil。
```
local x

print(x) -- nil

x = 1

print(x) -- 1
```
也可以支持平行赋值：
```
local a, b, c = 1, 2, 3

print(a, b, c) -- 1 2 3
```
#### nil

nil 相当于 null 或者 None。

nil 永远是 false。

对 nil 做类型比较时，应该加上双引号，否则将返回 false。
```
local a = nil

print(a == nil) -- true

-- 示意： type 返回类型
print(type(a) == nil) -- false

print(type(a) == "nil") -- true
```
#### 数值
Lua 数字只有一个 number 类型，无论浮点数还是整数：
```
local a, b, c = 1, 2.0, 3

print(a, b, c) -- 1 2.0 3
print(type(a), type(b), type(c)) -- number -- number -- number
```
#### 布尔值
Lua 布尔值只有 true 和 false。

0 等同于 true，此外任意的容器类型布尔结果都是 true，无论其是否含有元素。

#### 字符串
字符串用单引号或双引号包裹定义：
```
local s1 = '123'
local s2 = "123"
```
也可以使用 [[]] 包裹定义，它支持字符串跨行：
```
local s3 = [[
    123
    456
    789
]]
```
字符串长度可以通过 # 符号或者 string.len 方法来取：
```
print(#"123") -- 3
print(string.len("123")) -- 3
```
#### 表
Lua 的表非常强大， 你可以用它定义数组或者映射。
Lua 中的表（table）其实是一个”关联数组”（associative arrays），数组的索引可以是数字或者是字符串。
```
如下所示：

-- 纯数组
local ary = { 1, 2, 3 }

-- 映射（这种不支持 kebab-case 命名风格）
local map1 = { is_first = 1, is_last = 2 }

-- 映射（这种和上面本质是一样的，但支持 kebab-case 命名风格）
local map2 = { ["is-first"] = 1, ["is-last"] = 2 }

-- 数组混合映射
local ary_map = { 1, ["two"] = 2, tree = 3, 4, 5, 6 }
```
注意，Lua 中的数组下标从 1 开始，这一点尤其要小心。

当数组混合映射时，通过下标取值会变得很有趣：
```
print(ary_map[1]) -- a
print(ary_map[2]) -- b
print(ary_map[3]) -- c

print(ary_map["two"]) -- 2
print(ary_map["tree"]) -- 3
```
要获取一个数组的长度，可以使用 # 操作符：
```
-- 纯数组
local ary = { 1, 2, 3 }

-- 查看长度
print(#ary) -- 3

-- 取最后一个元素
print(ary[#ary]) -- 3
```
#### 操作符号
Lua 中操作符号有：
```
+ 加
- 减
* 乘
/ 除（浮点除）
% 求余
^ 乘幂
- 负号
// 整除


== 等于
~= 不等于
>= 大于或等于
<= 小于或等于
>  大于
<  小于

and 逻辑与
or  逻辑或
not 逻辑非
```
#### 条件判断
下面是条件判断的案例：
```
local name = "askfiy"

if name == "askfiy" then
    print("Hello askfiy")
elseif name == "jack" then
    print("Hello jack")
else
    print("I do not know you")
end

-- Hello askfiy
```
#### 三元表达式
由于 Lua 里 0 不等于 false，所以可以通过 and 与 or 的结合做出类似三元表达式的效果。

语法：

> 条件 and 真 or 假  

举例：
```
local name = "askfiy"

local result = name == "askfiy" and "I know you" or "I don't know you"

print(result)

-- I know you
```
#### 循环
Lua 里的循环如下。

常规循环：
```
for i = 1, 10 do
    print(i)
    i = i + 1
end
```
数组循环，使用 ipairs 函数：
```
for index, value in ipairs({ "A", "B", "C" }) do
    print(index, value)
end


-- 1       A
-- 2       B
-- 3       C
```
映射循环，使用 pairs 函数：
```
for key, value in pairs({ a = 1, b=2, c= 3}) do
    print(key, value)
end


-- c       3
-- b       2
-- a       1
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
#### 模块
一个 Lua 文件就是一个模块，我们有以下文件结构：
```
.
├── package
│   └── module.lua
└── setup.lua
module.lua 是一个模块，它的代码如下：

local M = {
    a = 1,
    b = 2,
}

function M.test()
    print("module test ..")
end

return M
```
在 setup.lua 中，我们可以通过 require 方法导入模块 module，如下所示：
```
-- 这里也可以用 package.module 来导入
local m = require("package.module")

for key, value in pairs(m) do
    print(key, value)
end

-- b       2
-- test    function: 0x55d8450b0e00
-- a       1
```
#### 函数
Lua 中的函数可以有多个返回值，多个参数：

local function show(x, y)
    return x + 1, y + 1
end
```
local res_x, res_y = show(1, 2)
print(res_x, res_y)

-- 2, 3
```
函数可以使用 ... 操作符接收无限制的位置传参：
```
local function show(...)
    -- 在使用时，将它们放在一个 table 中
    print({ ... })
    -- 最终结果是
    -- {1, 2, 3, 4, 5}
end

show(1, 2, 3, 4, 5)
```
为一个模块定义函数有 2 种方式：
```
M.f1 = function()
    print("f1")
end

function M.f2()
    print("f2")
end

M.f1()
M.f2()
```

#### 闭包
由于 Lua 中的函数可以被赋值，这意味着函数也可以被当作参数传递。

闭包函数在 neovim 中书写一些配置项时可能会被用到，它的定义如下：
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

示例如下：
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
#### 异常
Lua 中的异常可以通过 pcall 捕获。

格式如下：
```
local 状态, 返回值 = pcall(函数, 参数)

if not 状态 then
    异常处理
    return
end

对返回值操作 ...
```
#### 方法
##### string
string 中的方法很多都会被用到，特别是 match 等 ..

由于篇幅原因这里不再举例，你可以直接跳转到 菜鸟教程 查看 match 的使用。

另外举例几个比较常用的函数：
```
string.upper(str)
string.lower(str)
string.find(str, sub)
string.format(str, ...)
string.sub(str, s, e)
.. 操作符
```
示例：
```
local str = "AbCdEfG"

-- 转全大写
print(string.upper(str)) -- ABCDEFG
-- 转全小写
print(string.lower(str)) -- abcdefg

-- 查找子串，返回开始和结束下标（下标从 1 起始）
print(string.find(str, "C")) --  3 3

local name = "askfiy"
local age = 18
-- 格式化
print(string.format("Hello, my name is %s, i am %s years old", name, age))
-- Hello, my name is askfiy, i am 18 years old

-- 拼接字符串
local s1 = "<<<"
local s2 = ">>>"
local s3 = s1 .. "|" .. s2
print(s3)
-- <<<|>>>

-- 截取字符串
local s4 = "abcdefg"

-- 从 2 取到 4， 取头取尾
print(string.sub(s4, 2, 4)) -- bcd
```
#### table
table 里我们可能会用到 2 个方法：
```
table.insert(t, v)
table.remove(t, i)
```
示例：
```
local tb = { 1, 2 }

-- 将 3 插入到 tb
table.insert(tb, 3)
print(tb[#tb])

-- 删除 tb 中 1 号下标的元素
table.remove(tb, 1)
print(tb[1])
```
##### 调用
一些方法可以被对象本身调用，如 string.upper。

对象通过 : 操作符调用方法时，会将对象本身传递进去，这个概念类似于 Javascript 中的 this 和 Python 中的 self。

示例：
```
local str = "hello"

print(str:upper()) -- HELLO
print(str:lower()) -- hello
print(str:len()) -- 5
```

