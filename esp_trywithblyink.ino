// ======= Smart Oscillometric BP Monitor for ESP32 =======
// - Smart inflation: stop when pulse disappears, then +INFLATE_MARGIN (max MAX_INFLATE)
// - Stepwise deflation with stabilization & sampling
// - MAP = maximum oscillation envelope; SYS/DIA from ratios
// - Sends results to Blynk and prints Serial for debugging
// - Keep tuning constants for your hardware & transducer
// =======================================================

#define BLYNK_AUTH_TOKEN "xzyGleJzRIwpRqmj7yXtknyLg9KZrIJx"
#define BLYNK_TEMPLATE_ID "TMPL2Ekm229uv"
#define BLYNK_TEMPLATE_NAME "SBPM"

/*******************************************************
     ESP32 Blood Pressure Monitor + MAX30102 + Blynk
     V3 = Live Pressure (mmHg)
     V6 = Start Button
     V7 = DIA
     V2 = SYS
     V8 = SPO2
     V4 = Heart Rate (calc)
     V9 = Heart Rate (MAX30102)
********************************************************/

#include <WiFi.h>
#include <BlynkSimpleEsp32.h>
#include "HX710AB.h"
#include <MAX30102_PulseOximeter.h>

// =================== WIFI ===================
char ssid[] = "AH";
char pass[] = "ahmedhassan010";

// =================== PINS ===================
#define DATA_PIN    19
#define CLOCK_PIN   18
#define MOTOR_PIN   25
#define VALVE_PIN   26
#define BUTTON_PIN  27

HX710B HX(DATA_PIN, CLOCK_PIN);
PulseOximeter pox;

// =================== Calibration (adjust to your calibration) ===================
const float pressure1_kPa = 0.0;
const float raw1 = -5236418;
const float pressure2_kPa = 10.666;
const float raw2 = 992242.0;

float offset = raw1;
float scale  = (pressure2_kPa - pressure1_kPa) / (raw2 - raw1); 

// =================== Inflating / Deflating Parameters ===================
// Smart inflation behavior
const float MAX_INFLATE = 175.0;   // absolute safety max (mmHg)
const float INFLATE_MARGIN = 30.0; // mmHg to add after pulse disappears
const float MIN_INFLATE_TO_CHECK = 110.0; // don't declare occlusion below this normally

// Step deflation and stabilization (tune for your setup)
const float STEP_DROP_MMHG = 2.0;     // mmHg per step
const unsigned long STABILIZE_MS = 800; // ms to wait and sample at each step

const float RELEASE_PRESSURE  = 30.0; // final release mmHg

// Oscillometric extraction
const int DC_WINDOW = 25;    // DC moving average window (samples)
const int ENV_LP_WINDOW = 8; // envelope smoothing window
const float OSC_THRESHOLD_MIN = 0.01; // minimum envelope amplitude to consider oscillation real

// SYS/DIA ratio thresholds
float SYS_RATIO = 0.55; // typical ~0.50-0.58
float DIA_RATIO = 0.85; // typical ~0.80-0.88

// =================== States ===================
enum SystemState { IDLE, INFLATING, STABILIZING_AFTER_INFLATE, DEFLATING, ANALYZING };
SystemState state = IDLE;

// =================== Data arrays ===================
const int MAX_SAMPLES = 3000;
float *pressureData;
float *oscEnvelope;
unsigned long *timeData;
int sampleCount = 0;
bool recording = false;

// =================== Filter buffers ===================
float dcBuffer[DC_WINDOW];
int dcIndex = 0;
bool dcFilled = false;

float envBuffer[ENV_LP_WINDOW];
int envIndex = 0;

// =================== HR estimation from envelope ===================
int estHR = 0;
unsigned long hrWindowStart = 0;
int peakCountWindow = 0;
const unsigned long HR_WINDOW_MS = 10000; // 10s window to estimate HR from envelope

// =================== Blynk START BUTTON (V6) ===================
BLYNK_WRITE(V6) {
  int stateBtn = param.asInt();
  if (stateBtn == 1) startMeasurement();
}

// =================== SETUP ===================
void setup() {
  Serial.begin(115200);
  Serial.println(">>> ESP32 BP Monitor (Smart Inflation) <<<");
  Blynk.begin(BLYNK_AUTH_TOKEN, ssid, pass);

  HX.begin();
  pinMode(MOTOR_PIN, OUTPUT);
  pinMode(VALVE_PIN, OUTPUT);
  pinMode(BUTTON_PIN, INPUT);

  pressureData = (float*)malloc(MAX_SAMPLES * sizeof(float));
  oscEnvelope = (float*)malloc(MAX_SAMPLES * sizeof(float));
  timeData = (unsigned long*)malloc(MAX_SAMPLES * sizeof(unsigned long));

  // init filter buffers
  for (int i = 0; i < DC_WINDOW; i++) dcBuffer[i] = 0.0f;
  for (int i = 0; i < ENV_LP_WINDOW; i++) envBuffer[i] = 0.0f;

  stopAll();

  if (!pox.begin()) {
    Serial.println("MAX30102 not found!");
  } else {
    Serial.println("MAX30102 initialized.");
    // optional: pox.setIRLedCurrent(...); // adjust sensor LED current if needed
  }

  Serial.println("========= READY =========");
}

// =================== LOOP ===================
void loop() {
  Blynk.run();
  pox.update();

  // Live SpO2 and MAX30102 HR to Blynk (always)
  Blynk.virtualWrite(V8, pox.getSpO2());
  Blynk.virtualWrite(V9, pox.getHeartRate());

  if (HX.is_ready()) {
    float pressure = readPressure_mmHg();
    Blynk.virtualWrite(V3, pressure); // live pressure

    switch (state) {
      case IDLE:
        // idle: do nothing until startMeasurement() sets state
        break;

      case INFLATING:
        inflateSmart(pressure);
        break;

      case STABILIZING_AFTER_INFLATE:
        // gather samples while stabilizing before stepwise deflation
        // record a few samples during a short stabilization period
        if (recording) {
          unsigned long stableStart = millis();
          unsigned long end = stableStart + STABILIZE_MS;
          while (millis() < end && HX.is_ready()) {
            float p = readPressure_mmHg();
            recordPressure(p);
            delay(10);
          }
        }
        state = DEFLATING;
        Serial.println("→ Begin stepwise deflation.");
        break;

      case DEFLATING:
        deflateStepwise(pressure);
        break;

      case ANALYZING:
        // analysis done inside analyzePressure(); keep IDLE afterwards
        break;
    }
  }

  // update HR estimate to Blynk
  Blynk.virtualWrite(V4, estHR);

  delay(10);
}

// =================== START MEASUREMENT ===================
void startMeasurement() {
  Serial.println("\n===== NEW MEASUREMENT =====");
  sampleCount = 0;
  recording = false;
  state = INFLATING;

  // reset filters & counters
  dcIndex = 0; dcFilled = false;
  envIndex = 0;
  for (int i = 0; i < DC_WINDOW; i++) dcBuffer[i] = 0.0f;
  for (int i = 0; i < ENV_LP_WINDOW; i++) envBuffer[i] = 0.0f;
  estHR = 0; peakCountWindow = 0; hrWindowStart = millis();

  Blynk.virtualWrite(V4, 0);
  Blynk.virtualWrite(V7, 0);
  Blynk.virtualWrite(V2, 0);
  Blynk.virtualWrite(V8, 0);
  Blynk.virtualWrite(V3, 0);
  Blynk.virtualWrite(V9, 0);

  // begin inflation
  Serial.println("→ Inflating...");
  closeValve();
  digitalWrite(MOTOR_PIN, HIGH);
}

// =================== SMART INFLATION ===================
// Inflates while watching for pulse disappearance (both MAX30102 HR and envelope).
// When we detect pulse lost, we inflate target = current pressure + INFLATE_MARGIN (clamped to MAX_INFLATE).
void inflateSmart(float pressure) {
  if (!recording) {
    recording = true;
    Serial.println("START RECORDING (inflation)");
  }

  // record current pressure into buffers to let envelope build during inflation
  recordPressure(pressure);

  // Determine pulse presence:
  // 1) MAX30102 heart rate presence (pooled)
  bool poxHasPulse = (pox.getHeartRate() > 30 && pox.getHeartRate() < 200);

  // 2) Envelope presence: if envelope is above minimal threshold in recent samples
  float lastEnv = (sampleCount > 0) ? oscEnvelope[sampleCount - 1] : 0.0f;
  bool envHasPulse = (lastEnv > OSC_THRESHOLD_MIN);

  static unsigned long lastPulseSeen = 0;
  static bool pulsePreviouslySeen = false;

  // if either sensor sees a pulse, we consider pulse present
  if (poxHasPulse || envHasPulse) {
    lastPulseSeen = millis();
    pulsePreviouslySeen = true;
  }

  // if we've seen pulses before and now pulses haven't been seen for a while -> pulse lost
  if (pulsePreviouslySeen && (millis() - lastPulseSeen > 1500)) { // 1.5 s gap -> lost
    // Decide final inflation target
    float target = pressure + INFLATE_MARGIN;
    if (target > MAX_INFLATE) target = MAX_INFLATE;

    Serial.printf("Pulse lost at %.1f mmHg → final inflation target %.1f mmHg\n", pressure, target);

    // keep inflating until reach target
    if (pressure >= target) {
      // stop motor, keep valve closed to stabilize
      digitalWrite(MOTOR_PIN, LOW);
      closeValve();
      Serial.println("Inflation complete (smart) → stabilizing then deflating");
      state = STABILIZING_AFTER_INFLATE;
      return;
    }
    // else keep motor ON (we are still inflating)
    digitalWrite(MOTOR_PIN, HIGH);
    return;
  }

  // Safety: if we reach absolute max, stop and go to deflation
  if (pressure >= MAX_INFLATE) {
    digitalWrite(MOTOR_PIN, LOW);
    closeValve();
    Serial.println("Reached MAX_INFLATE safety limit → stabilizing then deflating");
    state = STABILIZING_AFTER_INFLATE;
    return;
  }

  // still inflating normally; ensure motor on and valve closed
  closeValve();
  digitalWrite(MOTOR_PIN, HIGH);
}

// =================== STEPWISE DEFLATION ===================
// Drops pressure in steps of STEP_DROP_MMHG, stabilize and sample at each step
void deflateStepwise(float pressure) {
  static float nextTarget = 0.0f;
  static bool stepInProgress = false;
  static unsigned long stepStart = 0;

  if (!stepInProgress) {
    // set next target
    nextTarget = pressure - STEP_DROP_MMHG;
    if (nextTarget < RELEASE_PRESSURE) nextTarget = RELEASE_PRESSURE;
    // open valve to start drop
    openValve();
    stepInProgress = true;
    stepStart = millis();
  }

  // wait until pressure drops to nextTarget (or timeout)
  if (pressure <= nextTarget || (millis() - stepStart) > 5000) {
    // close valve and stabilize while sampling
    closeValve();
    unsigned long start = millis();
    while (millis() - start < STABILIZE_MS) {
      if (!HX.is_ready()) break;
      float p = readPressure_mmHg();
      recordPressure(p);
      delay(10);
    }
    stepInProgress = false;

    // If we've reached release pressure or ran out of sample space, finish
    if (pressure <= RELEASE_PRESSURE || sampleCount >= MAX_SAMPLES - 10) {
      Serial.println("Reached release or sample buffer limit -> finishing");
      // dump air quickly for comfort
      openValve();
      delay(400);
      stopAll();
      state = ANALYZING;
      analyzePressure();
      recording = false;
      state = IDLE;
      return;
    }
  } else {
    // while dropping, we still record samples
    recordPressure(pressure);
  }
}

// =================== READ PRESSURE (mmHg) ===================
float readPressure_mmHg() {
  long raw = HX.read();
  float pressure_kPa = (raw - offset) * scale;
  float pressure_mmHg = pressure_kPa * 7.50062;
  return pressure_mmHg;
}

// =================== RECORD PRESSURE & COMPUTE OSCILLATION ENVELOPE ===================
void recordPressure(float pressure) {
  // update DC buffer
  dcBuffer[dcIndex] = pressure;
  dcIndex = (dcIndex + 1) % DC_WINDOW;
  if (dcIndex == 0) dcFilled = true;

  // compute DC average
  float dcSum = 0.0f;
  int dcCount = dcFilled ? DC_WINDOW : dcIndex;
  if (dcCount == 0) dcCount = 1;
  for (int i = 0; i < dcCount; i++) dcSum += dcBuffer[i];
  float dcAvg = dcSum / dcCount;

  // AC component (approx high-pass)
  float ac = pressure - dcAvg;
  float absAc = fabs(ac);

  // envelope smoothing
  envBuffer[envIndex] = absAc;
  envIndex = (envIndex + 1) % ENV_LP_WINDOW;
  float envSum = 0.0f;
  for (int i = 0; i < ENV_LP_WINDOW; i++) envSum += envBuffer[i];
  float env = envSum / ENV_LP_WINDOW;

  // detect peaks in env for HR estimation
  detectEnvelopePeak(env);

  // store
  if (sampleCount < MAX_SAMPLES) {
    pressureData[sampleCount] = pressure;
    oscEnvelope[sampleCount] = env;
    timeData[sampleCount] = millis();
    sampleCount++;
  } else {
    // buffer full - ignore further
  }
}

// =================== SIMPLE ENVELOPE PEAK DETECTOR (for HR) ===================
void detectEnvelopePeak(float env) {
  static float prev = 0.0f;
  static bool wasRising = false;
  static unsigned long lastPeak = 0;

  if (env > prev) {
    wasRising = true;
  }
  if (wasRising && env < prev && prev > OSC_THRESHOLD_MIN) {
    unsigned long now = millis();
    if (now - lastPeak > 250) { // avoid spurious very-fast peaks
      lastPeak = now;
      // update window counters
      if (hrWindowStart == 0) hrWindowStart = now;
      peakCountWindow++;
      // recompute HR every HR_WINDOW_MS
      if (now - hrWindowStart >= HR_WINDOW_MS) {
        estHR = (int)((peakCountWindow * 60000.0) / (now - hrWindowStart) + 0.5);
        peakCountWindow = 0;
        hrWindowStart = now;
      }
    }
    wasRising = false;
  }
  prev = env;
}

// =================== ANALYSIS: find MAP, SYS, DIA ===================
float calibrateSYS(float rawSYS) { return 0.829f * rawSYS - 16.89f; }
float calibrateDIA(float rawDIA) { return 0.224f * rawDIA + 57.59f; }

void analyzePressure() {
  if (sampleCount < 6) {
    Serial.println("Not enough data to analyze.");
    Blynk.virtualWrite(V2, 0);
    Blynk.virtualWrite(V7, 0);
    return;
  }

  // find max envelope -> MAP
  float maxOsc = 0.0f;
  int maxIndex = 0;
  for (int i = 0; i < sampleCount; i++) {
    if (oscEnvelope[i] > maxOsc) {
      maxOsc = oscEnvelope[i];
      maxIndex = i;
    }
  }

  float MAP = pressureData[maxIndex];

  // find systolic on ascending side (search backwards)
  float systolic = 0.0f;
  for (int i = maxIndex; i >= 0; i--) {
    if (oscEnvelope[i] <= SYS_RATIO * maxOsc) {
      systolic = pressureData[i];
      break;
    }
  }
  if (systolic == 0.0f) systolic = pressureData[0];

  // find diastolic on descending side (search forwards)
  float diastolic = 0.0f;
  for (int i = maxIndex; i < sampleCount; i++) {
    if (oscEnvelope[i] <= DIA_RATIO * maxOsc) {
      diastolic = pressureData[i];
      break;
    }
  }
  if (diastolic == 0.0f) diastolic = pressureData[sampleCount - 1];

  // calibrate (if you have calibration equations; otherwise they are pass-through-ish)
  float calibratedSYS = calibrateSYS(systolic);
  float calibratedDIA = calibrateDIA(diastolic);

  Serial.println("\n------ ANALYSIS ------");
  Serial.printf("Samples: %d\n", sampleCount);
  Serial.printf("MAP (raw): %.1f mmHg (index %d)\n", MAP, maxIndex);
  Serial.printf("MaxOsc: %.5f\n", maxOsc);
  Serial.printf("SYS raw: %.1f -> calibrated: %.1f\n", systolic, calibratedSYS);
  Serial.printf("DIA raw: %.1f -> calibrated: %.1f\n", diastolic, calibratedDIA);
  Serial.printf("HR est (env): %d bpm | HR (MAX30102): %d bpm\n", estHR, pox.getHeartRate());
  Serial.printf("SpO2: %.1f\n", pox.getSpO2());

  // send to Blynk
  Blynk.virtualWrite(V2, calibratedSYS);
  Blynk.virtualWrite(V7, calibratedDIA);
  Blynk.virtualWrite(V4, estHR);
  Blynk.virtualWrite(V8, pox.getSpO2());
  Blynk.virtualWrite(V9, pox.getHeartRate());

  // optional: dump raw vectors to Serial for calibration/tuning
  Serial.println("\n--- Raw pressure, envelope ---");
  for (int i = 0; i < sampleCount; i += max(1, sampleCount / 100)) { // print ~100 points max
    Serial.printf("%.1f, %.6f\n", pressureData[i], oscEnvelope[i]);
  }
}

// =================== CONTROL FUNCTIONS ===================
void stopAll() {
  digitalWrite(MOTOR_PIN, LOW);
  digitalWrite(VALVE_PIN, LOW);
}

void closeValve() {
  digitalWrite(VALVE_PIN, HIGH);
}

void openValve() {
  digitalWrite(VALVE_PIN, LOW);
}
