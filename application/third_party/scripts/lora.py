#!/usr/bin/python


import time

import serial

import MySQLdb

time.sleep(20)
print "Iniciado"


DB_HOST='localhost'
DB_USER='root'
DB_PASS='andres'
DB_NAME='monitoreo'



def run_query(query=''):
   datos = [DB_HOST, DB_USER, DB_PASS, DB_NAME]
   conn = MySQLdb.connect(*datos) # Conectar a la base de datos 
   cursor = conn.cursor()         # Crear un cursor 
   cursor.execute(query)          # Ejecutar una consulta
   if query.upper().startswith('SELECT'):
      data = cursor.fetchall()   # Traer los resultados de un select 
   else:
      conn.commit()              # Hacer efectiva la escritura de datos 
      data = None 
   
   cursor.close()                 # Cerrar el cursor 
   conn.close()                   # Cerrar la conexion 

   return data


def guardar_sensor_camara(camara,sensor,temp,hum):
	query="SELECT count(id) FROM camaras WHERE mac_camara='"+camara+"'"
	n=run_query(query)[0][0]
	#print n
	if(n==0):
		query="insert into camaras (mac_camara) value ('"+camara+"')"
		run_query(query)
		print "Camara agregada"
	query="SELECT id FROM camaras WHERE mac_camara='"+camara+"'"
	id_cam=run_query(query)[0][0]
	query="SELECT COUNT(id) from sensores where mac_sensor='"+sensor+"'"
	n=run_query(query)[0][0]
	if(n==0):
		query="insert into sensores (mac_sensor,temperatura,humedad,habilitado,id_camara) values('"+sensor+"','"+temp+"','"+hum+"',1,"+str(id_cam)+")"
		#print query
		run_query(query)
		print "Sensor agregado"
	elif(n==1):
		query="select id from sensores where mac_sensor='"+sensor+"'"
		id_sen=run_query(query)[0][0]
		query="update sensores set temperatura='"+temp+"',humedad='"+hum+"',cuando=now() where id="+str(id_sen)
		run_query(query)
		print "Sensor actualizado"


ser=serial.Serial(port='/dev/serial0',baudrate=57600)



ser.write("radio set pwr 15"+chr(13)+chr(10))

lora=ser.readline()
MAC_propia="b827eb880ec0"
MAC_propia=MAC_propia.upper()


while 1:
	ser.write("mac pause"+chr(13)+chr(10))
	lora=ser.readline()
	#print lora
	ser.write("radio rx 0"+chr(13)+chr(10))
	lora=ser.readline()
	lora=ser.readline()
	if (lora.upper().startswith("RADIO_RX  "+MAC_propia)):
		MAC_camara=lora[22:34]
		MAC_sensor=lora[34:46]
		temperatura2=float(lora[46:50])/10.0
		humedad2=float(lora[50:])/10.0
		#query="insert into temporal (camara,sensor,temperatura,humedad) values ('"+MAC_camara+"','"+MAC_sensor+"','"+str(temperatura)+"','"+str(humedad)+"')"
		#query="update temporal set camara='"+MAC_camara+"',sensor='"+MAC_sensor+"',temperatura='"+str(temperatura2)+"',humedad='"+str(humedad2)+"',cuando=now() where id=1"
		#query="SELECT guardar_sensor_camara('"+MAC_camara+"','"+MAC_sensor+"','"+str(temperatura2)+"','"+str(humedad2)+"')"
		#print query
		#print run_query(query)
		guardar_sensor_camara(MAC_camara,MAC_sensor,str(temperatura2),str(humedad2))
		#print "Base escrita"
		#print MAC_camara
		#print MAC_sensor
		#print temperatura
		#print humedad
	#print lora.upper()

	#time.sleep(2)
