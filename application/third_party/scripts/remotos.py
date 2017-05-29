#!/usr/bin/python


import time
import sys

import MySQLdb






time.sleep(15)
print "REMOTOS ONLINE"

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



while True:

	query="SELECT * from sensores where 1"
	datos=run_query(query)

	temp=datos[0][3]
	hum=datos[0][4]


	if ((temp!="") and (hum!="")):
	#if hum is not None and temp is not None:
		time.sleep(1)
		f=open("/var/www/web/monitor/application/third_party/scripts/temp2","w")
		f.write(temp)
		f.close()
		f2=open("/var/www/web/monitor/application/third_party/scripts/hum2","w")
		f2.write(hum)
		f2.close()


