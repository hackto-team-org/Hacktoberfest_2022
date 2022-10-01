# Breaking into Substrings
def substring(stng):
  substr=[]
  for i in range(0,len(stng)):
    for j in range(i+1,len(stng)):
      substr.append(stng[i:j+1])
  palin=[]
  for ele in substr:
    if(isPalin(ele)):
      palin.append(ele)
  return palin

# Checking Palindrome
def isPalin(ele):
  if(ele==(ele[::-1])):
    return True
  else:
    return False


print(substring(input("Enter a String")))