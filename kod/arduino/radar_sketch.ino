#include <Servo.h>

#define trigPin 4
#define echoPin 5
#define buttonPin 2
#define ledPin 3

long duration;
int distance;
int opState = 0;
int servoPos = 90; 
int stepDir = 1; 

Servo servo;

unsigned long lastDebounceTime = 0;
const unsigned long debounceMs = 40;
int lastButtonState = LOW;

unsigned long lastBlinkMs = 0;
const unsigned long blinkPeriodMs = 200;
bool ledBlinkState = false;

unsigned long lastServoMoveMs = 0;
const int servoInterval = 15; 

void setup() {
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(buttonPin, INPUT);
  pinMode(ledPin, OUTPUT);
  servo.attach(6);
  servo.write(servoPos);
  Serial.begin(9600);
}

void loop() {
  handleButton();
  handleKeyboard();

  if (opState == 1) {
    autoScan();
  }
  
  updateLed(); 
}

void handleButton() {
  int reading = digitalRead(buttonPin);
  if (reading != lastButtonState) lastDebounceTime = millis();

  if ((millis() - lastDebounceTime) > debounceMs) {
    static int stableState = LOW;
    if (reading != stableState) {
      stableState = reading;
      if (stableState == HIGH) opState = !opState;
    }
  }
  lastButtonState = reading;
}

void handleKeyboard() {
  if (Serial.available() > 0) {
    char key = Serial.read();
    if (key == 'd') { 
      opState = 0;
      servoPos = constrain(servoPos - 1, 15, 165);
      servo.write(servoPos);
      calculateDistance();
      sendData();
    } 
    else if (key == 'a') { 
      opState = 0;
      servoPos = constrain(servoPos + 1, 15, 165);
      servo.write(servoPos);
      calculateDistance();
      sendData();
    } 
    else if (key == 'm') { 
      opState = !opState;
    }
  }
}

void autoScan() {
  if (millis() - lastServoMoveMs >= servoInterval) {
    lastServoMoveMs = millis();
    servoPos += stepDir;
    if (servoPos >= 165 || servoPos <= 15) stepDir *= -1;
    
    servo.write(servoPos);
    calculateDistance();
    sendData();
  }
}

void updateLed() {
  if (opState == 0) {
    digitalWrite(ledPin, HIGH);
  } else {
    
    if (millis() - lastBlinkMs >= blinkPeriodMs) {
      lastBlinkMs = millis();
      ledBlinkState = !ledBlinkState;
      digitalWrite(ledPin, ledBlinkState ? HIGH : LOW);
    }
  }
}

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

void sendData() {
  Serial.print(servoPos);
  Serial.print(",");
  Serial.print(distance);
  Serial.print(".");
}