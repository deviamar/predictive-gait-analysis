import serial
import time

# Change '/dev/tty.usbmodemXXXX' to the serial port of your Arduino (you will find this in the Arduino IDE under Tools > Port)
arduino_port = '/dev/cu.usbmodem1401'
baud_rate = 115200  # Baud rate must match the one set in your Arduino sketch

ser = serial.Serial(arduino_port, baud_rate)  # Open the serial port
time.sleep(2)  # Wait for the connection to establish

with open('sensor_data.txt', 'w') as file:
    print("Logging data...")
    while True:
        line = ser.readline().decode('utf-8').strip()  # Read data from serial port
        print(line)  # Optionally print data to the terminal as well
        file.write(line + '\n')  # Save data to the file
