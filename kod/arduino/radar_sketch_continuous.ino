#include<Servo.h>

#define trigPin 2
#define echoPin 3

long duration;
int distance ;

Servo servo;

int calculateDistance()
{
  digitalWrite(trigPin,LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin,HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin,LOW);
  duration = pulseIn(echoPin, HIGH);
  // Distance calculation: duration * speed_of_sound_cm_us / 2
  distance = duration * 0.034 / 2; 
  return distance;
}

void setup()
{
  pinMode(trigPin , OUTPUT);
  pinMode(echoPin, INPUT);
  servo.attach(4);
  Serial.begin(9600);
  // Center the continuous servo at start (Stop position)
  mservo.write(90); 
  delay(5000);
}

void loop()
{
  // --- Simulated Sweep: Direction 1 (e.g., Left) ---
  // The value '45' sets the speed/direction. Adjust this value (closer to 90 is slower) 
  // until the speed looks right to you.
  servo.write(80); 
  
  // The 'i' variable now represents the TIME the servo SPINS in this direction, 
  // not a specific angle. We will spin for 50 cycles.
  for (int i = 0; i < 25; i++)
  {
    delay(20); // Spin time per measurement
    calculateDistance();
    
    // NOTE: The 'i' here does NOT represent the angle, but we print it 
    // to keep the serial output format similar to the original code.
    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }
  
  // Stop the servo briefly to simulate the end of the sweep
  servo.write(90); 
  delay(500);
  
  // --- Simulated Sweep: Direction 2 (e.g., Right) ---
  // The value '135' sets the speed/direction. Adjust this value (closer to 90 is slower).
  servo.write(100); 
  
  // Spin back for 50 cycles
  for(int i = 25; i > 0; i--)
  {
    delay(20); // Spin time per measurement
    calculateDistance();
    
    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }

  // Stop the servo again
  servo.write(90);
  delay(500);
}