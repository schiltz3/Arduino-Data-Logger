
import processing.serial.*;                            //import the required libraries
PrintWriter output;
Serial ArduinoSerial;

//initialize the variables used
int h, min, s, m;
int time;
int timeOffset;
int maxCharacters=0;
long loop=0;
long fileWtites=0;
String row = "";
String incomingString;
char incomingCharacters;
int characterCount = 0;
boolean newData = false;
boolean receiveInProgress = false;
boolean overflow = false;
boolean initialize = false;

String COM="COM6";               //setup COM port (look up in the arduino IDE Tools>Port)

//initialize, start, and end markers.
char startMarker = '<';
char endMarker = '>';
char initializeMarker = '^';

//Document setup
String filename = "Datta_Logger";
String columns = "Column1,Column2,Column3,Column4,LoopTime";

//Sampling setup
int maxTime = 2*30*1000;                                 //maximum amount of time you want the program to run for
int samples = 1000;                                      //maximum number of data samples you want
int maxChars = 56;                                       //set to one higher than the most characters transmitted
boolean debug = false;                                   //set to true to see more debugging information


void setup() {
  min = minute();
  int sec = second();
  output = createWriter(filename + str(min)+str(sec)+ ".csv");    // creats a file and saves it in the sketch folder
  ArduinoSerial = new Serial(this, COM, 115200);         //sets serial to listen on COM port 4 at 115200 baud
  output.println(columns);
  updateTime();                                          //updates time
  timeOffset = (((min*60) + s)*1000) +m;                 //sets a zero for the time
  println("setup Complete");
}

void draw() {
  while (time <= maxTime && loop < samples) {            //keeps reading samples untill a set number of samples are read or it hits a timer
    updateTime();
    receiveWithStartEndMarkers();                        //recieves transmition from Arduino
    if (newData == true) {                               //checks to see if a transmition is complete. This function loops may more times than the arduino sends data
      println("Latest transmition:", row);
      newData = false;                                   //sets to false to begin looking for new data
    }
    time = ((((min*60) + s)*1000) +m) - timeOffset;
  }
  keyPressed();                                                     //closes the file after while loop runs
}


void receiveWithStartEndMarkers() {
  characterCount = 0;
  while (ArduinoSerial.available() > 0 && newData == false) {
    incomingCharacters = ArduinoSerial.readChar();                  //reads incoming serial data and stores it as a character
    incomingString = str(incomingCharacters);                       //converts incoming characters to a string
    if (debug) {
      println("Incoming Serial:", incomingString);
    }
    if (incomingString != null) {                                   //check to make sure there is a value
      if (receiveInProgress == true) {

        if (incomingCharacters != endMarker) {              
          row += incomingString;                                    //adds incoming character to transmition
          characterCount++;
          if (characterCount > maxCharacters) {                     //increaces the maximum character count if any transmition is longer than any of the previous
            maxCharacters = characterCount;
          }
          if (characterCount >= maxChars) {                         //marks transmition as bad if there are too many characters
            if (debug) {
              println("characterCount:", characterCount, "                  Overflow");
            }
            overflow = true;
          }
        } else {                                         //runs once end marker is hit
          if (debug) {
            println("endMarkerHit");
          }
          if (overflow == false) {                       //only writes to file if transmition didn't overflow
            output.println(row);
            fileWtites++;                                //counts total number times the program writes transmitions to the file
          }
          receiveInProgress = false;                     //resets variables
          characterCount = 0;
          newData = true;
          overflow = false;
          loop++;                                        //counts total number of times the program loops
        }
      } else if (incomingCharacters == startMarker && initialize == true) { //only starts transmition if botht eh start and initialization markers are hit
        if (debug) {
          println("startMarkerHit");
        }
        row="";                                           //resets row
        receiveInProgress = true;
      } else if (incomingCharacters == initializeMarker) {
        println("initializeMarkerHit");
        row="";
        initialize = true;
      }
    } else {
      if (debug) {
        println("Incoming String = null");
      }
    }
  }
}


void keyPressed() {
  output.flush();                     // Writes the remaining data to the file
  output.close();                     // Finishes the file
  println("End of transmitions");
  if (debug) {
    println("Number of loops:", loop);
    println("Number of writes:", fileWtites);
    println("Total program run time:", time, "ms");
    println("Longest transmition:", maxCharacters, "characters");
    println("Set maxCharacters to", maxCharacters+1, "to guard against overflows. Currently set at", maxChars);
  }
  exit();                            // Stops the program
}


void updateTime() {                     //updates the time variables
  h = hour();
  min = minute();
  s = second();
  m = millis();
}
