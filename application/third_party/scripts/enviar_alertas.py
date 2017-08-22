#!/usr/bin/python


import time
import sys
import telepot

import telepot.api
import urllib3

telepot.api._pools = {
    'default': urllib3.PoolManager(num_pools=3, maxsize=10, retries=10, timeout=40),
}


import MySQLdb


from datetime import datetime

import smtplib
from email.MIMEText import MIMEText 




time.sleep(20)
print "Alertas Iniciado"


DB_HOST='localhost'
DB_USER='root'
DB_PASS='andres'
DB_NAME='monitoreo'

username = 'monitor.temp.hum@gmail.com'
password = 'andres00'


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




def enviar_telegrams(mensaje):
   query="select chat_id from usuarios where habilitado=1"
   usuarios=run_query(query)
   #print usuarios
   
   for x in usuarios:

      #bot=telepot.Bot('196708475:AAFXMiVQVR1CwyYcs9Hv4Lsa1otAg4gLCM0')
      bot.sendMessage(str(x[0]),mensaje)
      print "Telegram enviado a "+str(x[0])
      #time.sleep(1)

def enviar_correos(mensaje):
   query="select email from correos where habilitado=1"
   correos=run_query(query)
   fromaddr = 'monitor.temp.hum@gmail.com'
   subject="Alerta de Monitor de Humedad y Temperatura"
   for x in correos:
      toaddrs  = str(x[0])
      msg = MIMEText(mensaje)
      msg["From"]=fromaddr
      msg["Subject"]=subject
      msg["To"]=toaddrs
      server = smtplib.SMTP('smtp.gmail.com:587')
      server.starttls()
      server.login(username,password)
      server.sendmail(fromaddr, toaddrs, msg.as_string())
      server.quit()

def visar_alerta(id_alarma):
   query="update alertas set enviado=1, cuando=cuando where id="+str(id_alarma)
   run_query(query)

bot=telepot.Bot('196708475:AAFXMiVQVR1CwyYcs9Hv4Lsa1otAg4gLCM0')
while(1):
   query="select id,mensaje,cuando from alertas where enviado=0"
   alertas=run_query(query)
   for x in alertas:
      id_alarma=x[0]
      mensaje=str(x[1])+". "+str(x[2])
      #print id_alarma
      #print mensaje
      try:
         enviar_telegrams(mensaje)
      except:
         print "EXCEPT de Telegram"
         enviar_telegrams(mensaje)
         print "Lo reenvie"
      try:
         enviar_correos(mensaje)
      except:
         pass
      try:
         visar_alerta(id_alarma)
      except:
         pass
      
      time.sleep(5)
   #print "CHK"
   time.sleep(5)