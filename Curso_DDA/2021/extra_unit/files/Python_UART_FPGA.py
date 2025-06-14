import time
import serial
import sys

portUSB = sys.argv[0]

ser = serial.Serial(
    port='COM5',	#Configurar con el puerto
    baudrate=115200,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE,
    bytesize=serial.EIGHTBITS
)
# ser = serial.Serial('COM5',115200)

ser.isOpen()
ser.timeout=None
print(ser.timeout)

print ('Ingrese un comando:[0,1,2,3]\r\n')

while 1 :
    inputData = input("<< ")	
    if inputData == 'exit':
        ser.close()
        exit()
    elif(inputData == '3'):
        print ("Wait Input Data")
        ser.write(inputData.encode())
        time.sleep(2)
        readData = ser.read(1)
        out = str(int.from_bytes(readData,byteorder='big'))
        print(ser.inWaiting())
        if out != '':
            print (">>" + out)
    else:
        ser.write(inputData.encode())
        time.sleep(1)
