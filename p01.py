
sum=0
for a in range(1,5):
    for b in range(1,5):
        for c in range(1,5):
            if (a!=b) and (b!=c) and (c!=a):
                sum+=1
                print(a*100+b*10+c)
print("总数为:",sum)
print('大家好')


