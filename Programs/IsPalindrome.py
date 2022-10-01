##Below program is to check if a given number is palindrome or not.
n=int(input("Enter a number:"))
temp=n
rev=0

##Condition to check if a given number is palindrome or not.
while(n>0):
    dig=n%10
    rev=rev*10+dig
    n=n//10
if(temp==rev):
    print("The number is palindrome!")
else:
    print("Not a palindrome!")