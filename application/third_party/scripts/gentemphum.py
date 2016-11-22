#!/usr/bin/python

import random
import time


while(1):
   temp=random.randrange(1000)/10.0
   hum=random.randrange(1000)/10.0
   f=open("temp","w")
   f.write(str(temp))
   f.close()
   f2=open("hum","w")
   f2.write(str(hum))
   f2.close()
   time.sleep(2)

