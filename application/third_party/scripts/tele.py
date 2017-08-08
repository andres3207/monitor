#!/usr/bin/python


import MySQLdb
import telepot
import time
import netifaces

from telepot.loop import MessageLoop
from telepot.namedtuple import ReplyKeyboardMarkup, KeyboardButton
from telepot.namedtuple import InlineKeyboardMarkup, InlineKeyboardButton


teclado1=ReplyKeyboardMarkup(keyboard=[[KeyboardButton(text="Ultimo"), KeyboardButton(text="Actual")], [KeyboardButton(text="Umbrales"), KeyboardButton(text="Direcciones")], [KeyboardButton(text="Configurar Umbrales")]], one_time_keyboard=True)
teclado2=ReplyKeyboardMarkup(keyboard=[[KeyboardButton(text="Ultimo"), KeyboardButton(text="Actual")], [KeyboardButton(text="Umbrales"), KeyboardButton(text="Direcciones")], [KeyboardButton(text="Configurar Umbrales")]])
teclado_inline=InlineKeyboardMarkup(inline_keyboard=[
                     [InlineKeyboardButton(text='+1 tmax', callback_data='+1_tmax'),InlineKeyboardButton(text='-1 tmax', callback_data='-1_tmax'),InlineKeyboardButton(text='+1 tmin', callback_data='+1_tmin'),InlineKeyboardButton(text='-1 tmin', callback_data='-1_tmin')],
                     [InlineKeyboardButton(text='+1 hmax', callback_data='+1_hmax'),InlineKeyboardButton(text='-1 hmax', callback_data='-1_hmax'),InlineKeyboardButton(text='+1 hmin', callback_data='+1_hmin'),InlineKeyboardButton(text='-1 hmin', callback_data='-1_hmin')],
                     [InlineKeyboardButton(text='Guardar cambios', callback_data='guardar')],
                 ])

time.sleep(14)
#print "TELE ONLINE"

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


def on_chat_message(msg):
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
            hum=todos[0][3]
            fecha=todos[0][5]
            formato="%d/%m/%Y %H:%M:%S"
            fecha=fecha.strftime(formato)
            msg=str(nombre_codigo[0][0])+" TEMPERATURA = "+str(temp)+chr(10)+chr(13)+"HUMEDAD = "+str(hum)+chr(10)+chr(13)+"FECHA = "+str(fecha)
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
            hum=x[4]
            fecha=x[6]
            formato="%d/%m/%Y %H:%M:%S"
            fecha=fecha.strftime(formato)
            msg=str(nombre_codigo[0][0])+" TEMPERATURA = "+str(temp)+chr(10)+chr(13)+"HUMEDAD = "+str(hum)+chr(10)+chr(13)+"FECHA = "+str(fecha)
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
         Hmin=umbrales[0][3]
         Hmax=umbrales[0][4]
         #print Tmax
         msg="UMBRALES CONFIGURADOS:"+chr(10)+chr(13)+"Temp. min. = "+str(Tmin)
         msg=msg+chr(10)+chr(13)+"Temp. max. = "+str(Tmax)
         msg=msg+chr(10)+chr(13)+"Hum. min. = "+str(Hmin)
         msg=msg+chr(10)+chr(13)+"Hum. max. = "+str(Hmax)
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
         Hmin=umbrales[0][3]
         Hmax=umbrales[0][4]
         #print Tmax
         msg="Temp. min. = "+str(Tmin)
         msg=msg+chr(10)+chr(13)+"Temp. max. = "+str(Tmax)
         msg=msg+chr(10)+chr(13)+"Hum. min. = "+str(Hmin)
         msg=msg+chr(10)+chr(13)+"Hum. max. = "+str(Hmax)

         global tmax_tmp
         global tmin_tmp
         global hmax_tmp
         global hmin_tmp

         tmax_tmp=float(Tmax)
         tmin_tmp=float(Tmin)
         hmax_tmp=float(Hmax)
         hmin_tmp=float(Hmin)
         bot.sendMessage(chat_id,"Umbrales configurados:",reply_markup=teclado2)
         bot.sendMessage(chat_id,msg,reply_markup=teclado_inline)
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
      elif(msg_rec[0:12].lower()=="config hmax "):
         hmax=msg_rec[12:]
         query="SELECT MAX(id) from configuracion WHERE 1"
         n=run_query(query)
         n=n[0][0]
         query="UPDATE configuracion set h_max='%s' WHERE id='%s'"%(hmax,n)
         rta=run_query(query)
         query="SELECT h_max FROM configuracion WHERE id='%s'"%n
         hmax=run_query(query)
         msg="Hum. max configurada en "+str(hmax[0][0])
         bot.sendMessage(chat_id,msg)
         #print rta
      elif(msg_rec[0:12].lower()=="config hmin "):
         hmin=msg_rec[12:]
         query="SELECT MAX(id) from configuracion WHERE 1"
         n=run_query(query)
         n=n[0][0]
         query="UPDATE configuracion set h_min='%s' WHERE id='%s'"%(hmin,n)
         rta=run_query(query)
         query="SELECT h_min FROM configuracion WHERE id='%s'"%n
         hmin=run_query(query)
         msg="Hum. min configurada en "+str(hmin[0][0])
         bot.sendMessage(chat_id,msg)
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

def on_callback_query(msg):
    query_id, from_id, data = telepot.glance(msg, flavor='callback_query')
    #print('Callback query:', query_id, from_id, data)

    global tmax_tmp
    global tmin_tmp
    global hmax_tmp
    global hmin_tmp
    data=str(data).lower()
    if data == '+1_tmax':
        tmax_tmp=tmax_tmp + 1
        mensaje="Temp max: "+str(tmax_tmp)
        bot.answerCallbackQuery(query_id, text=mensaje)
    elif data == '-1_tmax':
        tmax_tmp=tmax_tmp - 1
        mensaje="Temp max"+str(tmax_tmp)
        bot.answerCallbackQuery(query_id, text=mensaje)
    elif data == '+1_tmin':
        tmin_tmp=tmin_tmp + 1
        mensaje="Temp min: "+str(tmin_tmp)
        bot.answerCallbackQuery(query_id, text=mensaje)
    elif data == '-1_tmin':
        tmin_tmp=tmin_tmp - 1
        mensaje="Temp min: "+str(tmin_tmp)
        bot.answerCallbackQuery(query_id, text=mensaje)
    elif data == '+1_hmax':
        hmax_tmp=hmax_tmp + 1
        mensaje="Hum max: "+str(hmax_tmp)
        bot.answerCallbackQuery(query_id, text=mensaje)
    elif data == '-1_hmax':
        hmax_tmp=hmax_tmp - 1
        mensaje="Hum max: "+str(hmax_tmp)
        bot.answerCallbackQuery(query_id, text=mensaje)
    elif data == '+1_hmin':
        hmin_tmp=hmin_tmp + 1
        mensaje="Hum min: "+str(hmin_tmp)
        bot.answerCallbackQuery(query_id, text=mensaje)
    elif data == '-1_hmin':
        hmin_tmp=hmin_tmp - 1
        mensaje="Hum min: "+str(hmin_tmp)
        bot.answerCallbackQuery(query_id, text=mensaje)
    elif data == 'guardar':
        query="SELECT MAX(id) from configuracion WHERE 1"
        n=run_query(query)
        n=n[0][0]
        query="UPDATE configuracion set t_max='%s',t_min='%s',h_max='%s',h_min='%s' WHERE id='%s'"%(tmax_tmp,tmin_tmp,hmax_tmp,hmin_tmp,n)
        run_query(query)
        mensaje="Valores Actualizados"
        bot.answerCallbackQuery(query_id, text=mensaje)

    
   


NUMERO_SERIE="0258768680"

DB_HOST='localhost'
DB_USER='root'
DB_PASS='andres'
DB_NAME='monitoreo'

tmax_tmp=0.0
tmin_tmp=0.0
hmax_tmp=0.0
hmin_tmp=0.0


bot = telepot.Bot('196708475:AAFXMiVQVR1CwyYcs9Hv4Lsa1otAg4gLCM0')
answerer = telepot.helper.Answerer(bot)

MessageLoop(bot, {'chat': on_chat_message,
                  'callback_query': on_callback_query}).run_as_thread()
print('Listening ...')

# Keep the program running.
while 1:
    time.sleep(10)
