''' 有四个数字：1、2、3、4，能组成多少个互不相同且无重复数字的三位数？
各是多少？
'''
# sum=0
# for a in range(1,5):
#     for b in range(1,5):
#         for c in range(1,5):
#             if (a!=b) and (b!=c) and (c!=a):
#                 sum+=1
#                 print(a*100+b*10+c)
# print("总数为:",sum)
#

'''
企业发放的奖金根据利润提成。利润(I)低于或等于10万元时，奖金可提10%；利润高于10万元，低于20万元时，低于10万元的部分按10%提成，高于10万元的部分，可提成7.5%；20万到40万之间时，高于20万元的部分，可提成5%；40万到60万之间时高于40万元的部分，可提成3%；60万到100万之间时，高于60万元的部分，可提成1.5%，高于100万元时，超过100万元的部分按1%提成，从键盘输入当月利润I，求应发放奖金总数？
'''
#
# i=int(input("请输入您的利润:"))
# arr=[1000000,600000,400000,200000,100000,0]
# rat=[0.01,0.015,0.03,0.05,0.075,0.1]
# r=0
# for idx in range(0,6):
#     if i>arr[idx]:
#         r+=(i-arr[idx])*rat[idx]
#         print((i-arr[idx])*rat[idx])
#         i=arr[idx]
# print("奖金为:",r)
#
'''
题目：一个整数，它加上100是个完全平方数，再加上168又是一个完全平方数，
请问该数是多少？
x+100=n²
x+100+168=m²
m²-n²=(m+n)(m-n)=168
i=m+n j=m-n i*j=168 i和j至少一个是偶数
m=(i+j)/2 n=(i-j)/2 要么都是偶数，要么都是奇数
i与j均是大于等于2的偶数
i*j=168 j>=2 则1<i<168/2+1
'''
#
# for i in range(1, 85):
#     if 168 % i == 0:
#         j = 168/i
#         if i > j and (i+j) % 2 == 0 and (i-j) % 2 == 0:
#             m = (i+j)/2
#             n = (i-j)/2
#             x = n*n-100
#             print(x)

'''
题目：输入某年某月末日，判断这一天是这一年的第几天?
'''
# year = int(input('请输入年:\n'))
# month = int(input("请输入月:\n"))
# day = int(input("请输入日：\n"))
#
# months=(0,31,59,90,120,151,181,212,243,273,304,334)
# sum=0
# if 0<month<=12:
#     sum=months[month-1]
# else:
#     print('输入错误!')
# sum+=day
# leap=0
# if year%400==0 or year%4==0 and (year%100!=0):
#     leap=1
# if leap==1 and month>2:
#     sum+=1
# print("今年的第%d天"%(sum))

'''
题目：输入三个整数xyz，请把这三个数由小到大输出
'''
x = int(input("请输入x："))
y = int(input("请输入y："))
z = int(input("请输入z："))
a = [x, y, z]
# a.sort()
# for i in a:
#     print(i)

# 冒泡排序
for j in range(len(a)-1):
    for i in range(len(a)-1-j):
        if a[i] > a[i+1]:
            a[i], a[i+1] = a[i+1], a[i]

print(a)
