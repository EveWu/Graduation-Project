/*
  Analog Input
 Demonstrates analog input by reading an analog sensor on analog pin 0 and
 turning on and off a light emitting diode(LED)  connected to digital pin 13.
 The amount of time the LED will be on and off depends on
 the value obtained by analogRead().

 The circuit:
 * Potentiometer attached to analog input 0
 * center pin of the potentiometer to the analog pin
 * one side pin (either one) to ground
 * the other side pin to +5V
 * LED anode (long leg) attached to digital output 13
 * LED cathode (short leg) attached to ground

 * Note: because most Arduinos have a built-in LED attached
 to pin 13 on the board, the LED is optional.


 Created by David Cuartielles
 modified 30 Aug 2011
 By Tom Igoe

 This example code is in the public domain.

 http://www.arduino.cc/en/Tutorial/AnalogInput

 */
/*
int sensorPin0 = A0;    // select the input pin for the potentiometer
int sensorPin1 = A1; 
int sensorPin2 = A2;


int sensorValue0 = 0;  // variable to store the value coming from the sensor
int sensorValue1 = 0;
int sensorValue2 = 0;
*/

#define sample 12
#define input 3
int sensorPin = 2;
int sensorValue = 0;

void setup() {
  // declare the ledPin as an OUTPUT:
  //pinMode(ledPin, OUTPUT);
   pinMode(sensorPin, INPUT);
  /*
  int i;
  for (i = 0; i < input; i++) {
    pinMode(sensorPin[i], INPUT);
  }
  */
  /*
  pinMode(sensorPin0, INPUT);
  pinMode(sensorPin1, INPUT);
  pinMode(sensorPin2, INPUT);
  */
  Serial.begin(9600);
}

void loop() {
  // read the value from the sensor:
  sensorValue = analogRead(sensorPin);
  Serial.println(sensorValue);
  /*
  sensorValue0 = 1023 - analogRead(sensorPin0);
  sensorValue1 = 1023 - analogRead(sensorPin1);
  sensorValue2 = 1023 - analogRead(sensorPin2);
  //analogWrite(ledPin,sensorValue);
  Serial.print(sensorValue0);
  Serial.print(",");
  Serial.print(sensorValue1);
  Serial.print(",");
  Serial.println(sensorValue2);
  */
  /*
  int i, j, k;
  int value[input];
  for (i = 0; i < input; i++) {
    int temp[sample], sum = 0;
    for (j = 0; j < sample; j++) {
      temp[j] = 1023 - analogRead(sensorPin[i]);
    }
    for (j = 0; j < sample - 1; j++) {
      int minimum = j, exchange;
      for (k = j + 1; k < sample; k++) {
        if (temp[k] < temp[minimum]) {
          minimum = k;
        }
      }
      if (minimum != j) {
        exchange = temp[j];
        temp[j] = temp[minimum];
        temp[minimum] = exchange;
      }
    }
    for (j = 1; j < sample - 1; j++) {
      sum += temp[j];
    }
    value[i] = sum / (sample - 2);
  }

  for (i = 0; i < input - 1; i++) {
    Serial.print(value[i]);
    Serial.print(",");
  }
  Serial.println(value[i]);
  */
  delay(1000);

}
