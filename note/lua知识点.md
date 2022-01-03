```
--下划线_有特殊名字叫虚变量，虚变量可以当做一个不常用的变量名，保存不需要获取的一个或者多个数
for _, n in ipairs(t) do
        set[n] = true
        -- print(set[n])
        print(_)
        print(n)
end
```
