# Data Directory

This directory contains IMU recordings and synchronized videos of walking trials collected for the Predictive Gait Analysis project. Data were recorded across multiple sessions to capture normal walking, cane usage variations, and simulated gait abnormalities associated with muscle weakness and balance impairment.

---

## Data Collection Rounds

### Round 1 – Cane Usage and Basic Motions

* `RegularWalking1` — Normal walking with cane
* `SlightReliance` — Light dependence on cane
* `HeavyReliance` — Heavy dependence on cane
* `SpinAroundZ` — Rotational motion for axis validation

---

### Round 2 – Speed and Style Variations

* `RegularWalking2` — Normal walking (repeat trial)
* `FastWalking` — Increased cadence
* `SlowWalking` — Decreased cadence
* `CurvedWalking` — Walking along a curved path
* `CautiousWalking` — Bent-knee, guarded gait
* `TippyToeWalking` — Reduced heel strike
* `ImproperCaneUse` — Cane not aligned with left step
* `NoCaneUse` — Walking while holding cane upright and stationary
* `NoCaneUseRotation` — Walking while swinging cane

---

### Round 3 – Foot-Mounted IMU

The following motions were recorded with the MPU6050 attached near the ankle.
Each motion was performed for approximately 5 seconds.

#### Baseline Motions

* `Motionless`
  *Purpose:* Capture sensor noise baseline

* `LegSwing`
  *Purpose:* Capture basic gait cycle

* `AnkleTilt` (inversion/eversion)
  *Purpose:* Balance-related motion

* `ToeLift` (dorsiflexion/plantarflexion)
  *Purpose:* Foot clearance and swing phase

* `Stomping`
  *Purpose:* Synchronization and signal landmarking

---

#### Step Events and Abnormalities

* `HeelStrikeToeOff`
  *Purpose:* Train detection of step events

* `NoHeelClearance`
  *Purpose:* Simulate gait with reduced toe lift

---

## Simulated Gait Abnormalities (Muscle Weakness Focus)

Based on clinical gait disorder references and physician input, the following patterns were prioritized because they are commonly linked to muscle weakness and are potentially addressable through exercise and physical therapy:

* **Trendelenburg Gait (Gluteus Medius Weakness)**
  Pelvic drop and trunk lean during stance phase

* **Weak Dorsiflexor Gait (Foot Drop)**
  Toe drag and exaggerated hip/knee flexion

* **Weak Hamstrings Gait**
  Knee snapping back (hyperextension)

* **Cautious Gait (Deconditioning / Core Weakness)**
  Slow, broad-based, hesitant steps

* **Reduced Heel Strike / Flat Foot Contact**
  Associated with quadriceps weakness

These patterns were simulated to study how biomechanical deficits manifest in IMU signals.

---

## References for Gait Patterns

Clinical descriptions were informed by:

* Cleveland Clinic – Gait Disorders
  [https://my.clevelandclinic.org/health/diseases/21092-gait-disorders](https://my.clevelandclinic.org/health/diseases/21092-gait-disorders)
* Merck Manual – Gait Disorders in Older Adults
  [https://www.merckmanuals.com/professional/geriatrics/gait-disorders-in-older-adults](https://www.merckmanuals.com/professional/geriatrics/gait-disorders-in-older-adults)
* Educational video series on gait abnormalities:
  [https://www.youtube.com/watch?v=kqoUzTyn_k4&list=PLNtAtk-8i_IhuhwGD7GtmYc3PSJe03vh5](https://www.youtube.com/watch?v=kqoUzTyn_k4&list=PLNtAtk-8i_IhuhwGD7GtmYc3PSJe03vh5)

---

## Selection Criteria for Gait Patterns

Simulated gaits were selected based on:

* Muscle-based origin (rather than irreversible neurodegeneration)
* Potential reversibility through exercise or therapy
* Detectability using IMU signals (e.g., step asymmetry, trunk lean, foot clearance)

## Dataset

Raw IMU recordings, synchronized walking videos, and experiment notes are hosted externally due to file size:

**Supplementary Data (Google Drive):**  
https://drive.google.com/drive/folders/1rCGqkWPsfDxp_-JHScxSccDoRixHejuz?usp=sharing
