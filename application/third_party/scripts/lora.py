#!/usr/bin/python


import time

import serial

ser=serial.Serial(port='/dev/serial0',baudrate=57600)



ser.write("radio set pwr 15"+chr(13)+chr(10))

MAC_propia="b8:27:eb:88:0e:c0"
MAC_propia=MAC_propia.upper()


while 1:
	ser.write("mac pause"+chr(13)+chr(10))
	lora=ser.readline()
	ser.write("radio rx 0"+chr(13)+chr(10))
	lora=ser.readline()
	lora=ser.readline()
	if (lora.upper().startswith(MAC_propia)):
		MAC_camara=lora[17:34]
		MAC_sensor=lora[34:51]
		temperatura=lora[lora.index("T")+1:lora.index("H")]
		humedad=lora[lora.index("H")+1:]

	#time.sleep(2)