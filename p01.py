'''
题目：有四个数字：1、2、3、4，能组成多少个互不相同且无重复的三位数，
      各是哪些？
'''

sum=0
for a in range(1,5):
    for b in range(1,5):
        for c in range(1,5):
            if (a!=b) and (b!=c) and (c!=a):
                sum+=1
                print(a*100+b*10+c)
print("总数为:",sum)
