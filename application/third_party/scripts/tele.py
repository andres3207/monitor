#!/usr/bin/python

import MySQLdb
import telepot
import time




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


def handle(msg):
   chat_id=msg['chat']['id']
   msg_rec=msg['text']
   
   query="SELECT COUNT(id) from usuarios where chat_id="+str(chat_id)+" and habilitado=1"
   n=run_query(query)
   n=n[0][0]
   #print n
   if n==0:
      query="SELECT COUNT(id) from usuarios where chat_id="+str(chat_id)
      n=run_query(query)
      n=n[0][0]
      if n==0:
         if(msg_rec=="alta "+NUMERO_SERIE):
            query="INSERT into usuarios (chat_id,habilitado) values ('"+str(chat_id)+"',1)"
            resp=run_query(query)
            bot.sendMessage(chat_id,"CODIGO VALIDO"+chr(10)+chr(13)+"Usuario dado de alta")
         else:
            bot.sendMessage(chat_id,"CODIGO INVALIDO"+chr(10)+chr(13)+"Vuelva a intentar")
      else:
         if(msg_rec=="alta "+NUMERO_SERIE):
            query="UPDATE usuarios set habilitado=1 where chat_id="+str(chat_id)
            resp=run_query(query)
            bot.sendMessage(chat_id,"CODIGO VALIDO"+chr(10)+chr(13)+"Usuario dado de alta")
         else:
            bot.sendMessage(chat_id,"CODIGO INVALIDO"+chr(10)+chr(13)+"Vuelva a intentar")
   else:      
      if msg_rec=="ultimo":
         #bot.sendMessage(chat_id,"Hola")
         query="SELECT max(id) FROM datos"
         n=run_query(query)
         n=n[0][0]
         query="SELECT * FROM datos where id='%s'"%n
         todos=run_query(query)
         temp=todos[0][1]
         hum=todos[0][2]
         fecha=todos[0][3]
         #formato="a las %H:%M:%S del dia %d/%m/%Y"
         formato="%d/%m/%Y %H:%M:%S"
         fecha=fecha.strftime(formato)
         #print type(fecha)
         #msg="La ultima temperatura y humedad registrados fueron de %s grados y %s%% %s" %(temp,hum,fecha)
         #msg=(50*"-")+chr(10)+chr(13)+"| TEMPERATURA "+19*" "+str(temp)+" | "+chr(10)+chr(13)+50*"-"+chr(10)+chr(13)+"| HUMEDAD  "+28*" "+str(hum)+" | "+chr(10)+chr(13)+50*"-"+chr(10)+chr(13)+"| FECHA  "+str(fecha)+" | "+chr(10)+chr(13)+50*"-"
         #msg="<b>HOLA</b>"
         #print(len("| TEMPERATURA "+str(temp)))
         msg="TEMPERATURA = "+str(temp)+chr(10)+chr(13)+"HUMEDAD = "+str(hum)+chr(10)+chr(13)+"FECHA = "+str(fecha)
         bot.sendMessage(chat_id,msg)
         #print(msg)
      elif(msg_rec=="alta "+NUMERO_SERIE):
         bot.sendMessage(chat_id,"El usuario ya se encontraba de alta")
      elif(msg_rec=="baja"):
         query="UPDATE usuarios set habilitado=0 where chat_id="+str(chat_id)
         resp=run_query(query)
         bot.sendMessage(chat_id,"Usuario dado de baja"+chr(10)+chr(13)+"puede volver a darse de alta en el futuro")
      else:
         bot.sendMessage(chat_id,"Comando no reconocido")
   


NUMERO_SERIE="0258768680"

DB_HOST='localhost'
DB_USER='root'
DB_PASS='andres'
DB_NAME='monitoreo'


bot=telepot.Bot('196708475:AAFXMiVQVR1CwyYcs9Hv4Lsa1otAg4gLCM0')
bot.message_loop(handle)
while 1:
   time.sleep(10)
