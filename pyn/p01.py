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

i = int(input('净利润:'))
print('您的输入是',i)
