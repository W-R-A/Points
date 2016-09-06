#A program to write a program -RA

x = input('start')
y = input('finish')

x=int(x)
x = x+1
y=int(y)
y = y+1
for i in range(x, y):
    print(i, end = ", ")


q = input('\nPress any key to exit')
