#!/usr/bin/python

import random
import time
import sys

import Adafruit_DHT




sensor = 22
pin = 22


#print "Temp: "+temp
#print "Hum: "+hum


while(1):
#   temp=random.randrange(1000)/10.0
#   hum=random.randrange(1000)/10.0
   humidity, temperature = Adafruit_DHT.read_retry(sensor, pin)
   if humidity is not None and temperature is not None:
      temp="{0:0.1f}".format(temperature)
      hum="{0:0.1f}".format(humidity)
      f=open("/var/www/web/monitor/application/third_party/scripts/temp","w")
      f.write(temp)
      f.close()
      f2=open("/var/www/web/monitor/application/third_party/scripts/hum","w")
      f2.write(hum)
      f2.close()
   #time.sleep(5)

