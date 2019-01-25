
unsigned long currentMillis = 0;
unsigned long previousMillis = 0;

byte Column1 = 1;
byte Column2 = 2;
byte Column3 = 3;
byte Column4 = 4;
float deltaT = 0;

char startMarker = '<';
char endMarker = '>';
char initializeMarker = '^';


void setup() {
  Serial.begin(115200);
  while (!Serial);
  Serial.print(initializeMarker);   //inializes the entire transmition
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
