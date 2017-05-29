#!/usr/bin/python

from sht1x.Sht1x import Sht1x as SHT1x
import time
import sys

dataPin = 11

clkPin = 7

sht1x = SHT1x(8,10)

while True:
	time.sleep(1)
	temp=sht1x.read_temperature_C()
	time.sleep(1)
	hum=sht1x.read_humidity() 

	temp="{0:0.1f}".format(temp)
	hum="{0:0.1f}".format(hum)
	#print "Temperatura: "+temp
	#print "Humedad: "+hum
	if ((temp!="") and (hum!="")):
	#if hum is not None and temp is not None:
		#time.sleep(1)
		f=open("/var/www/web/monitor/application/third_party/scripts/temp3","w")
		f.write(temp)
		f.close()
		f2=open("/var/www/web/monitor/application/third_party/scripts/hum3","w")
		f2.write(hum)
		f2.close()
		print temp
		print hum


