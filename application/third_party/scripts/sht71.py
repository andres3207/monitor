#!/usr/bin/python

from sht1x.Sht1x import Sht1x as SHT1x

dataPin = 11

clkPin = 7

sht1x = SHT1x(11,7)

temp=sht1x.read_temperature_C()

hum=sht1x.read_humidity() 


#SHT1x = sht1x(dataPin, clkPin, Sht1x.GPIO_BOARD)

#temperature=SHT1x.read_temperature_C()

#humedity = SHT1x.read_humidity()


print ("Temperature: {} Humidity: {}".format(temp, hum))