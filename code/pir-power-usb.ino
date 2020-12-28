#include "LowPower.h"

const int LED = 11;
const int PIR = 0;

const unsigned long ON_MS = 500;
const unsigned long OFF_MS = 1000;
const unsigned long ON_OFF_DELAY_MS = 40000;

double led = 0;

boolean isMotionDetected = false;
unsigned long motionDetectStartAt = 0;
unsigned long timeDelayStartAt = 0;
unsigned long sleepInterruptedAt = 0;

unsigned long sleepMillis = 0;

void setup() {
  Serial.begin(9600);
  
  pinMode(LED, OUTPUT);
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(PIR, INPUT);

  attachInterrupt(digitalPinToInterrupt(PIR), pirStateChange, CHANGE);

  blinkLed(3, 500);
}

void loop() {
  unsigned long currentMillis = millis() + sleepMillis;
  if (motionDetectStartAt > currentMillis || timeDelayStartAt > currentMillis) {
    motionDetectStartAt = 0;
    timeDelayStartAt = 0;
  }

  boolean wasMotionDetected = isMotionDetected;
  isMotionDetected = digitalRead(PIR) == HIGH;
  if (isMotionDetected && !wasMotionDetected) {
    motionDetectStartAt = currentMillis;
  } else if (!isMotionDetected && wasMotionDetected) {
    timeDelayStartAt = currentMillis;
  }

  boolean transitionRunning = updateLed(currentMillis);
  if (!transitionRunning) {
    LowPower.powerDown(SLEEP_8S, ADC_OFF, BOD_OFF);
    sleepMillis += 8000;
  }
}

void blinkLed(int times, int durationMs) {
  double stepMs = 10.0;
  for (int t = 0; t < times; t++) {
    for (led = 0.0; led < 1.0; led = min(1.0, led + stepMs / (durationMs / 2))) {
      writeLed();
      delay(stepMs);
    }
    for (led = 1.0; led > 0.0; led = max(0.0, led - stepMs / (durationMs / 2))) {
      writeLed();
      delay(stepMs);
    }
  }
}

void pirStateChange() {
  // Do nothing.
}

boolean updateLed(unsigned long currentMillis) {
  boolean transitionRunning;
  if (motionDetectStartAt > timeDelayStartAt || currentMillis < timeDelayStartAt + ON_OFF_DELAY_MS) {
    led = max(led, constrain((currentMillis - motionDetectStartAt) / (double) ON_MS, 0.0, 1.0));
    transitionRunning = led != 1.0;
  } else {
    led = min(led, constrain(1.0 - ((currentMillis - (timeDelayStartAt + ON_OFF_DELAY_MS)) / (double) OFF_MS), 0.0, 1.0));
    transitionRunning = led != 0.0;
  }
  writeLed();
  return transitionRunning;
}

void writeLed() {
  analogWrite(LED, led * 255);
  digitalWrite(LED_BUILTIN, led > 0.5 ? HIGH : LOW);
}

