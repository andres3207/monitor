#!/usr/bin/python

from sht1x.Sht1x import Sht1x as SHT1x
import time
import sys

dataPin = 11

clkPin = 7

sht1x = SHT1x(11,7)

while True:
	temp=sht1x.read_temperature_C()

	hum=sht1x.read_humidity() 

	temp="{0:0.1f}".format(temp)
	hum="{0:0.1f}".format(hum)

	f=open("/var/www/web/monitor/application/third_party/scripts/temp2","w")
	f.write(temp)
	f.close()
	f2=open("/var/www/web/monitor/application/third_party/scripts/hum2","w")
	f2.write(hum)
	f2.close()
	#print ("Temperature: {} Humidity: {}".format(temp, hum))


#SHT1x = sht1x(dataPin, clkPin, Sht1x.GPIO_BOARD)

#temperature=SHT1x.read_temperature_C()

#humedity = SHT1x.read_humidity()

