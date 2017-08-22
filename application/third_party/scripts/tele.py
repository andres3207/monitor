#!/usr/bin/python


import MySQLdb
import telepot
import time
import netifaces

from telepot.loop import MessageLoop
from telepot.namedtuple import ReplyKeyboardMarkup, KeyboardButton
from telepot.namedtuple import InlineKeyboardMarkup, InlineKeyboardButton


teclado1=ReplyKeyboardMarkup(keyboard=[[KeyboardButton(text="Ultimo"), KeyboardButton(text="Actual")], [KeyboardButton(text="Umbrales"), KeyboardButton(text="Direcciones")], [KeyboardButton(text="Configurar Umbrales")]], one_time_keyboard=True)
teclado2=ReplyKeyboardMarkup(keyboard=[[KeyboardButton(text="Ultimo"), KeyboardButton(text="Actual")], [KeyboardButton(text="Umbrales"), KeyboardButton(text="Direcciones")]])


time.sleep(14)
print "TELE ONLINE"

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
         if(msg_rec.lower()=="alta "+NUMERO_SERIE):
            query="INSERT into usuarios (chat_id,habilitado) values ('"+str(chat_id)+"',1)"
            resp=run_query(query)
            bot.sendMessage(chat_id,"CODIGO VALIDO"+chr(10)+chr(13)+"Usuario dado de alta",reply_markup=teclado2)
         else:
            bot.sendMessage(chat_id,"CODIGO INVALIDO"+chr(10)+chr(13)+"Vuelva a intentar")
      else:
         if(msg_rec.lower()=="alta "+NUMERO_SERIE):
            query="UPDATE usuarios set habilitado=1 where chat_id="+str(chat_id)
            resp=run_query(query)
            bot.sendMessage(chat_id,"CODIGO VALIDO"+chr(10)+chr(13)+"Usuario dado de alta",reply_markup=teclado2)
         else:
            bot.sendMessage(chat_id,"CODIGO INVALIDO"+chr(10)+chr(13)+"Vuelva a intentar")
   else:      
      if msg_rec.lower()=="ultimo":
         query="select id from sensores where habilitado=1"
         sensores=run_query(query)
         for x in sensores:
            query="select max(id) from datos where id_sensor ="+str(x[0])
            id_dato=run_query(query)         
            query="SELECT * FROM datos where id='%s'"%id_dato[0]
            todos=run_query(query)
            query="select nombre_codigo("+str(x[0])+")"
            nombre_codigo=run_query(query)
            temp=todos[0][2]
            #hum=todos[0][3]
            fecha=todos[0][4]
            formato="%d/%m/%Y %H:%M:%S"
            fecha=fecha.strftime(formato)
            msg=str(nombre_codigo[0][0])+" TEMPERATURA = "+str(temp)+chr(10)+chr(13)+"FECHA = "+str(fecha)
            bot.sendMessage(chat_id,msg,reply_markup=teclado2)
            #print(msg)
      elif(msg_rec.lower()=="alta "+NUMERO_SERIE):
         bot.sendMessage(chat_id,"El usuario ya se encontraba de alta",reply_markup=teclado2)
      elif(msg_rec.lower()=="baja"):
         query="UPDATE usuarios set habilitado=0 where chat_id="+str(chat_id)
         resp=run_query(query)
         bot.sendMessage(chat_id,"Usuario dado de baja"+chr(10)+chr(13)+"puede volver a darse de alta en el futuro")
      elif(msg_rec.lower()=="actual"):
         query="select * from sensores where habilitado=1"
         sensores=run_query(query)
         for x in sensores:
            #print x
            query="select nombre_codigo("+str(x[0])+")"
            nombre_codigo=run_query(query)
            temp=x[3]
            #hum=x[4]
            fecha=x[5]
            formato="%d/%m/%Y %H:%M:%S"
            fecha=fecha.strftime(formato)
            msg=str(nombre_codigo[0][0])+" TEMPERATURA = "+str(temp)+chr(10)+chr(13)+"FECHA = "+str(fecha)
            bot.sendMessage(chat_id,msg,reply_markup=teclado2)
            #print(msg)
      elif(msg_rec.lower()=="umbrales"):
         query="SELECT MAX(id) from configuracion WHERE 1"
         n=run_query(query)
         n=n[0][0]
         #print n
         query="SELECT * FROM configuracion WHERE id='%s'"%n
         umbrales=run_query(query)
         #print umbrales
         Tmin=umbrales[0][1]
         Tmax=umbrales[0][2]
         #print Tmax
         msg="UMBRALES CONFIGURADOS:"+chr(10)+chr(13)+"Temp. min. = "+str(Tmin)
         msg=msg+chr(10)+chr(13)+"Temp. max. = "+str(Tmax)
         bot.sendMessage(chat_id,msg,reply_markup=teclado2)
      elif(msg_rec.lower()=="configurar umbrales"):
         query="SELECT MAX(id) from configuracion WHERE 1"
         n=run_query(query)
         n=n[0][0]
         #print n
         query="SELECT * FROM configuracion WHERE id='%s'"%n
         umbrales=run_query(query)
         #print umbrales
         Tmin=umbrales[0][1]
         Tmax=umbrales[0][2]

         #print Tmax
         msg="Temp. min. = "+str(Tmin)
         msg=msg+chr(10)+chr(13)+"Temp. max. = "+str(Tmax)


         global tmax_tmp
         global tmin_tmp


         tmax_tmp=float(Tmax)
         tmin_tmp=float(Tmin)

         bot.sendMessage(chat_id,"Umbrales configurados:",reply_markup=teclado2)
         bot.sendMessage(chat_id,msg,reply_markup=teclado2)
      elif(msg_rec[0:12].lower()=="config tmax "):
         tmax=msg_rec[12:]
         query="SELECT MAX(id) from configuracion WHERE 1"
         n=run_query(query)
         n=n[0][0]
         query="UPDATE configuracion set t_max='%s' WHERE id='%s'"%(tmax,n)
         rta=run_query(query)
         query="SELECT t_max FROM configuracion WHERE id='%s'"%n
         tmax=run_query(query)
         msg="Temp. max configurada en "+str(tmax[0][0])
         bot.sendMessage(chat_id,msg)
         #print rta
      elif(msg_rec[0:12].lower()=="config tmin "):
         tmin=msg_rec[12:]
         query="SELECT MAX(id) from configuracion WHERE 1"
         n=run_query(query)
         n=n[0][0]
         query="UPDATE configuracion set t_min='%s' WHERE id='%s'"%(tmin,n)
         rta=run_query(query)
         query="SELECT t_min FROM configuracion WHERE id='%s'"%n
         tmin=run_query(query)
         msg="Temp. min configurada en "+str(tmin[0][0])
         bot.sendMessage(chat_id,msg)
         #print rta
      elif(msg_rec.lower()=="direcciones"):
         interfaces=netifaces.interfaces()
         msg="Utilice las siguientes direcciones para acceder al sistema web:"+chr(10)+chr(13)+chr(10)+chr(13)
         for i in interfaces:
            addrs = netifaces.ifaddresses(i)
            direccion= addrs[netifaces.AF_INET][0]["addr"]
            if i=="eth0":
               msg=msg+"Desde la red local: http://"+str(direccion)+"/monitor/ "+chr(10)+chr(13)+chr(10)+chr(13)
            elif i=="wlan0":
               msg=msg+"Desde la red Wifi del equipo: http://"+str(direccion)+"/monitor/"
         bot.sendMessage(chat_id,msg,reply_markup=teclado2)
      else:
         bot.sendMessage(chat_id,"Comando no reconocido",reply_markup=teclado2)


    
   


NUMERO_SERIE="0258768680"

DB_HOST='localhost'
DB_USER='root'
DB_PASS='andres'
DB_NAME='monitoreo'

tmax_tmp=0.0
tmin_tmp=0.0



bot = telepot.Bot('196708475:AAFXMiVQVR1CwyYcs9Hv4Lsa1otAg4gLCM0')
answerer = telepot.helper.Answerer(bot)

bot.message_loop(handle)

# Keep the program running.
while 1:
    time.sleep(10)
