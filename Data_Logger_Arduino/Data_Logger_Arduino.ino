
unsigned long currentMillis = 0;
unsigned long previousMillis = 0;

int Column1 = 1;
int Column2 = 2;
int Column3 = 3;
int Column4 = 4;
float deltaT = 0;

char startMarker = '<';
char endMarker = '>';
char initializeMarker = '^';


void setup() {
  while (!Serial);
  Serial.begin(115200);
  Serial.print(initializeMarker);   //inializes the entire transmition
  delay(1000);
  previousMillis = millis();

}

void loop() {
  //*****************//
  //put programn here//
  //*****************//
  serialOutput();
  currentMillis = millis();
  deltaT = (currentMillis - previousMillis) * .001;
  previousMillis = millis();
  delay(10);                        //keep from overloading Serial port
}

void serialOutput() {
  Serial.print(startMarker);
  Serial.print(Column1);
  Serial.print(",");
  Serial.print(Column2);
  Serial.print(",");
  Serial.print(Column3);
  Serial.print(",");
  Serial.print(Column4);
  Serial.print(",");
  Serial.print(deltaT, 3);          //sends the time it takes the loop to run in seconds down to 3 decimal places
  Serial.print(endMarker);
}
