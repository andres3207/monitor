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



file = open('/var/www/web/monitor/application/third_party/scripts/temp', 'r')
file2 = open('/var/www/web/monitor/application/third_party/scripts/hum', 'r')
temp = file.read()
hum = file2.read()
file.close()
file2.close()
#temp=random.randrange(100)
#hum=random.randrange(100)

query="INSERT INTO datos (temperatura, humedad) VALUES ('%s','%s')" %(temp,hum)
print query
run_query(query)

query="SELECT * from configuracion where 1"
datos=run_query(query)

t_min=datos[0][1]
t_max=datos[0][2]
h_min=datos[0][3]
h_max=datos[0][4]

if (temp<t_min):
   if(hum<h_min):
      reporte="temperatura y humedad por debajo"
      reporte="TEMPERATURA = "+temp+" por debajo del limite configurado de "+str(t_min)+". HUMEDAD = "+hum+" por debajo del limite configurado de "+str(h_min)+"."
      condicion=0
   elif((hum>=h_min) and (hum<=h_max)):
      reporte="temperatura por debajo, humedad ok"
      reporte="TEMPERATURA = "+temp+" por debajo del limite configurado de "+str(t_min)+". HUMEDAD = "+hum+" dentro del limite configurado de "+str(h_min)+" y "+str(h_max)+"."
      condicion=1
   elif(hum>h_max):
      reporte="temperatura por debajo, humedad por encima"
      reporte="TEMPERATURA = "+temp+" por debajo del limite configurado de "+str(t_min)+". HUMEDAD = "+hum+" por encima del limite configurado de "+str(h_min)+"."
      condicion=2
elif((temp>=t_min) and (temp<=t_max)):
   if(hum<h_min):
      reporte="temperatura ok, humedad por debajo"
      reporte="TEMPERATURA = "+temp+" dentro del limite configurado de "+str(t_min)+" y "+str(t_max)+". HUMEDAD = "+hum+" por debajo del limite configurado de "+str(h_min)+"."
      condicion=3
   elif((hum>=h_min) and (hum<=h_max)):
      reporte="temperatura ok, humedad ok"
      reporte="TEMPERATURA = "+temp+" dentro del limite configurado de "+str(t_min)+" y "+str(t_max)+". HUMEDAD = "+hum+" dentro del limite configurado de "+str(h_min)+" y "+str(h_max)+"."
      condicion=4
   elif(hum>h_max):
      reporte="temperatura ok, humedad por encima"
      reporte="TEMPERATURA = "+temp+" dentro del limite configurado de "+str(t_min)+" y "+str(t_max)+". HUMEDAD = "+hum+" por encima del limite configurado de "+str(h_min)+"."
      condicion=5
elif (temp>t_max):
   if(hum<h_min):
      reporte="temperatura por encima, humedad por debajo"
      reporte="TEMPERATURA = "+temp+" por encima del limite configurado de "+str(t_max)+". HUMEDAD = "+hum+" por debajo del limite configurado de "+str(h_min)+"."
      condicion=6
   elif((hum>=h_min) and (hum<=h_max)):
      reporte="temperatura por encima, humedad ok"
      reporte="TEMPERATURA = "+temp+" por encima del limite configurado de "+str(t_max)+". HUMEDAD = "+hum+" dentro del limite configurado de "+str(h_min)+" y "+str(h_max)+"."
      condicion=7
   elif(hum>h_max):
      reporte="temperatura por encima, humedad por encima"
      reporte="TEMPERATURA = "+temp+" por encima del limite configurado de "+str(t_max)+". HUMEDAD = "+hum+" por encima del limite configurado de "+str(h_min)+"."
      condicion=8

query="INSERT INTO alertas (mensaje) VALUES ('%s')" %(reporte)
#print query
run_query(query)

query="SELECT chat_id from usuarios where habilitado=1"
destinatarios=run_query(query)

#print len(destinatarios)
bot=telepot.Bot('196708475:AAFXMiVQVR1CwyYcs9Hv4Lsa1otAg4gLCM0')

for i in range(len(destinatarios)):
   chat_id=str(destinatarios[i][0])
   #print chat_id
   bot.sendMessage(chat_id,reporte)