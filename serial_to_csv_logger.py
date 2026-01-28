# Python script to export data to a csv file

import serial
import csv
from datetime import datetime

port = '/dev/cu.usbmodem1301' //modify
baud = 9600
output_file = 'IMU_Data_1.csv'

ser = serial.Serial(port, baud)
print(f"Logging data to {output_file}...")

try:
	with open(output_file, 'w', newline='') as f:
		writer = csv.writer(f)
		writer.writerow(["time", "ax", "ay", "az", "gx", "gy", "gz", "t"])
		while True:
			line = ser.readline().decode('utf-8').strip()
			if line:
				data = line.split(",")
				print(f"Line not empty. Data: {data}")
				writer.writerow(data)

except KeyboardInterrupt:
	print("\nData logging stopped by user.")

finally:
	ser.close()
	print("Serial port closed.")
