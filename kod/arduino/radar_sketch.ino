#include <Servo.h>

#define trigPin 4
#define echoPin 5
#define buttonPin 2
#define ledPin 3

long duration;
int distance;
int opState = 0;

Servo servo;

int lastButtonState = LOW;
unsigned long lastDebounceTime = 0;
const unsigned long debounceMs = 40;


bool ledBlinkState = false;
unsigned long lastBlinkMs = 0;
const unsigned long blinkPeriodMs = 200;

int calculateDistance() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH, 30000);
  distance = duration * 0.034 / 2;
  return distance;
}

void setup() {
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(buttonPin, INPUT);
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, LOW);
  servo.attach(6);
  Serial.begin(9600);
}

void handleButton() {
  int reading = digitalRead(buttonPin);

  if (reading != lastButtonState) {
    lastDebounceTime = millis();
  }

  if ((millis() - lastDebounceTime) > debounceMs) {
    static int stableState = LOW;
    if (reading != stableState) {
      stableState = reading;
      if (stableState == HIGH) {
        opState = !opState;
      }
    }
  }
  lastButtonState = reading;
}

void updateLed(bool running) {
    if (opState == 0) {
        digitalWrite(ledPin, HIGH);
        return;
    }
    
    unsigned long now = millis();
    if (now - lastBlinkMs >= blinkPeriodMs) {
        lastBlinkMs = now;
        ledBlinkState = !ledBlinkState;
        digitalWrite(ledPin, ledBlinkState ? HIGH : LOW);
    }
}

void loop() {
  handleButton();

  bool running = false;

  if (opState == 1) {
    for (int i = 15; i <= 165; i++) {
      running = true;
      servo.write(i);
      delay(15);
      calculateDistance();
      Serial.print(i);
      Serial.print(",");
      Serial.print(distance);
      Serial.print(".");
      handleButton();
      updateLed(running);
      if (opState == 0) break;
    }

    for (int i = 165; i >= 15 && opState == 1; i--) {
      running = true;
      servo.write(i);
      delay(15);
      calculateDistance();
      Serial.print(i);
      Serial.print(",");
      Serial.print(distance);
      Serial.print(".");
      handleButton();
      updateLed(running);
      if (opState == 0) break;
    }
  }

  updateLed(running);
}
