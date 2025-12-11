#include<Servo.h>

#define trigPin 2
#define echoPin 3

long duration;
int distance ;

Servo servo;

int calculateDistance()
{
  digitalWrite(trigPin,LOW);
  delay(2);
  digitalWrite(trigPin,HIGH);
  delay(10);
  digitalWrite(trigPin,LOW);
  duration = pulseIn(echoPin, HIGH);
  distance = duration*0.034/2;
  return distance;
}

void setup()
{
  pinMode(trigPin , OUTPUT);
  pinMode(echoPin, INPUT);
  servo.attach(4);
  Serial.begin(9600);
}

void loop()
{
 int i ;
 for (i=15; i<=165; i++)
 {
  servo.write(i);
  delay(15);
  calculateDistance();
  Serial.print(i);
  Serial.print(",");
  Serial.print(distance);
  Serial.print(".");
 }
 for(i=165; i>=15; i--)
 {
  servo.write(i);
  delay(15);
  calculateDistance();
  Serial.print(i);
  Serial.print(",");
  Serial.print(distance);
  Serial.print(".");
  
 }

}
