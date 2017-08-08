#!/usr/bin/python


import time

import serial

ser=serial.Serial(port='/dev/serial0',baudrate=57600)



ser.write("radio set pwr 15"+chr(13)+chr(10))

MAC_propia="b827eb880ec0"
MAC_propia=MAC_propia.upper()


while 1:
	ser.write("mac pause"+chr(13)+chr(10))
	lora=ser.readline()
	ser.write("radio rx 0"+chr(13)+chr(10))
	lora=ser.readline()
	lora=ser.readline()
	if (lora.upper().startswith("RADIO_RX  "+MAC_propia)):
		MAC_camara=lora[22:34]
		MAC_sensor=lora[34:46]
		temperatura=float(lora[46:50])/10.0
		humedad=float(lora[50:])/10.0
		print MAC_camara
		print MAC_sensor
		print temperatura
		print humedad
	print lora.upper()

	#time.sleep(2)
