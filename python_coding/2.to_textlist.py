#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import glob
import os
#path = os.path.dirname(os.path.realpath(__file__))
#os.chdir(path)
path = "C:/users/joanl/산학연계 프로젝트/text"
if os.path.exists("8percent_text_all.txt"):
    os.remove("8percent_text_all.txt")
else:
    print("The file does not exist")
read_files = glob.glob("*.txt")
print(read_files)
with open("8percent_text_all.txt", "wb") as outfile:
    for f in read_files:
        #i = 0
        #line = "***********" + f + "***********" + "\n\n"
        #i += 1
        #outfile.write(line.encode('utf-8'))
        with open(f, "rb") as infile:
            outfile.write(infile.read())
      


# In[ ]:


f = open("C:/users/joanl/산학연계 프로젝트/text/8percent_text_all.txt", 'r')
lines = f.readlines()
companySet = set(lines)
f.close()
# 메모장에 저장
f = open("C:/users/joanl/산학연계 프로젝트/text/8percent_text_nosame.txt", 'w')
for account in companySet:
    data = account
    f.write(data)
f.close()
print(len(companySet))

