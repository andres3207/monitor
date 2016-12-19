#!/usr/bin/python


import time
import sys

import Adafruit_DHT






sensor = 22
pin = 22

while(1):
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
   time.sleep(2)

