#!/usr/bin/python

import MySQLdb
import random

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



file = open('temp', 'r')
file2 = open('hum', 'r')
temp = file.read()
hum = file2.read()
#temp=random.randrange(100)
#hum=random.randrange(100)

query="INSERT INTO datos (temperatura, humedad) VALUES ('%s','%s')" %(temp,hum)

print query
run_query(query)
