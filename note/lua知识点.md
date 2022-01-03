```
--[[下划线_有特殊名字叫虚变量（哑变量、虚拟变量、名义变量），使用虚变量（即下划线）来存储丢弃不需要的数值，
    所以，虚变量即没有现实意义的变量
  ]]
for _, n in ipairs(t) do
        set[n] = true
        -- print(set[n])
        print(_)
        print(n)
end
```
