# Predictive Gait Analysis (PGA)

This repository contains the data collection and logging pipeline for an IMU-based predictive gait analysis prototype. The system explores how cane-mounted and foot-mounted inertial sensors can be used to capture gait patterns associated with mobility decline and fall risk.

The project emphasizes:

* Minimal sensing (IMU-only hardware)
* Clinically interpretable gait features
* Longitudinal, real-world data collection

---

## Project Overview

Predictive Gait Analysis (PGA) investigates whether meaningful changes in gait and mobility can be detected early using a device older adults already rely on daily. Rather than producing a single abstract “fall risk” score, the system is framed around detecting specific gait abnormalities and relating them to plausible biomechanical causes and actionable interventions.

Two sensor placements were explored:

* **Cane-mounted IMU** → monitoring reliance and overall stability
* **Foot-mounted IMU** → identifying biomechanical gait abnormalities (e.g., reduced stride length, foot clearance, asymmetry)

---

## Repository Structure

```
.
├── arduino_imu_logger.ino      # Arduino firmware for IMU streaming
├── serial_to_csv_logger.py     # Python script for serial logging to CSV
├── examples/
│   └── sample_data.csv         # Small example dataset
├── docs/
│   ├── poster.pdf              # Project poster
│   └── case_competition_paper.pdf
├── README.md
└── LICENSE
```

---

## Hardware

* Microcontroller: Arduino (e.g., Uno / Nano / ESP32)
* IMU: MPU6050 (or equivalent 6-axis accelerometer + gyroscope)
* Mounting locations:

  * Base of cane
  * Near foot / ankle

---

## Data Format

IMU data are logged as CSV files with the following fields:

```
timestamp, ax, ay, az, gx, gy, gz
```

Where:

* `a*` = acceleration (raw units or m/s²)
* `g*` = angular velocity (raw units or deg/s)

---

## Usage

### 1. Flash the Arduino

Upload `arduino_imu_logger.ino` to the Arduino.
The firmware streams IMU data over the serial port.

### 2. Log data to CSV

Run the Python script:

```bash
python serial_to_csv_logger.py
```

This will:

* read IMU data from the serial port
* timestamp each sample
* write data to a CSV file

### 3. Collect trials

Record walking trials under different conditions:

* normal gait
* simulated gait abnormalities (e.g., reduced stride, low foot clearance)
* cane-mounted and foot-mounted sensor placements

---

## Dataset

Raw IMU recordings, synchronized walking videos, and experiment notes are hosted externally due to file size:

**Supplementary Data (Google Drive):**
[https://drive.google.com/drive/folders/1rCGqkWPsfDxp_-JHScxSccDoRixHejuz?usp=sharing](https://drive.google.com/drive/folders/1rCGqkWPsfDxp_-JHScxSccDoRixHejuz?usp=sharing)

This repository includes only small example CSV files for demonstration.

---

## Poster and Competition Paper

Project documentation is provided in the `docs/` directory:

* `poster.pdf` — Project poster
* `case_competition_paper.pdf` — Google Case Competition research paper

These describe the motivation, design rationale, and system-level framing of the project.

---

## Scope and Limitations

This project is an experimental prototype and is **not** a medical device.
It does not perform clinical diagnosis and has not been validated in patient populations. The system is intended for research and educational purposes only.

---

## License

This project is released under the MIT License.
