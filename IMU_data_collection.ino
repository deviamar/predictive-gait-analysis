
/*
  IMU Data Collection

  Author: Devi Amarsaikhan
  Date created: 8 July 2025
  Board: Arduino NANO 33 IoT

  Description
  This code makes use of the LSM6DS3 IMU to collect data using the accelerometer and gyroscope. 
  The data will be continuously printed to Serial Monitor.

  Notes
    Data format: timestamp, ax, ay, az, gx, gy, gz
    Use with python script 'IMU_data.py' to save data to a csv file and do live plotting
*/

#include <Arduino_LSM6DS3.h>

void setup() {
  Serial.begin(9600);
  while(!Serial);

  if(!IMU.begin()) {
    Serial.println("ERROR: Failed to initialize IMU");
    while(1);
  }

  Serial.println("Time in ms, Acceleration in g's, Gyroscope in degrees/second, Temperature in degrees C");
  Serial.println("Ti,AX,AY,AZ,GX,GY,GZ,Te");
}

void loop() {
  float ax, ay, az;
  float gx, gy, gz;

  unsigned long currentTime = millis();
  Serial.print(currentTime); Serial.print(",");

  if (IMU.accelerationAvailable()) {
    IMU.readAcceleration(ax, ay, az);

    Serial.print(ax); Serial.print(',');
    Serial.print(ay); Serial.print(',');
    Serial.print(az); Serial.print(',');
  }

  if (IMU.gyroscopeAvailable()) {
    IMU.readGyroscope(gx, gy, gz);

    Serial.print(gx); Serial.print(',');
    Serial.print(gy); Serial.print(',');
    Serial.print(gz); Serial.println(',');
  }

  delay(10);
}











