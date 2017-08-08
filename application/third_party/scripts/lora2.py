#!/usr/bin/python


import time

import serial



ser=serial.Serial(port='/dev/serial0',baudrate=57600)



#ser.write("radio set pwr 15"+chr(13)+chr(10))

#print ser.readline()
MAC_propia="b827eb880ec0"
MAC_propia=MAC_propia.upper()


while 1:
	ser.write("mac pause"+chr(13)+chr(10))
	print ser.readline()
	time.sleep(2)
