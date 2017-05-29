#!/usr/bin/python

import MySQLdb
import random
import telepot

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

temp=""
hum=""

query="SELECT * FROM sensores WHERE habilitado=1"
#print query
datos=run_query(query)

#print datos[0]

for sensor in datos:
   id_sensor=sensor[0]
   temp=sensor[3]
   hum=sensor[4]
   query="INSERT INTO datos (id_sensor,temperatura, humedad) VALUES ('%s','%s','%s')" %(id_sensor,temp,hum)
   #print query
   run_query(query)



