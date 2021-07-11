# Note:
While the folowing method works, you will have much more sucess installing ![RealTerm](https://sourceforge.net/projects/realterm/) to monitor and log the serial terminal
Then saving the log to open in either your text editor, excel, or in this ![CSV Plotter](https://github.com/schiltz3/csv-plotter)
### Arduino
The Arduino code will look something like this to print each row data.
```C
void serialOutput(){
  Serial.print(Column1);
  Serial.print(',');
  Serial.print(Column2);
  Serial.print(',');
  Serial.print(Column3);
  Serial.print(',');
  Serial.print(Column4);
}
```

### Another alternative is to follow ![this](https://miscircuitos.com/plot-real-time-signal-coming-arduino/) guide

# ~~Data Logger for Arduino~~

~~Easy to use set of programs that saves data from an Arduino to a spreadsheet. **Only uses Serial.print();**
The programs are written using Processing and the Arduino IDE, meaning they are cross platform compatible(Windows, Mac, & Linux), and records serial data sent from an Arduino to a PC in a comma separated values file (.csv) which can then be opened using a spreadsheet editor such as Excel Spreadsheets or WPS Spreadsheets.~~

## Getting Started

### Prerequisites

You will need the Arduino IDE and Processing to run the two programs. Links to where you can download them can be found under **Built With** 


### Installing

Simply download and unzip the folder, and you are ready to go. Upload the Data_Logger_Arduino to your Arduino before you run the Processing code.

Modify the Data_Logger_Arduino file to add in sensors to collect data where indicated in the program.

## Bugs
When running Arduino sketch for the first time, the first couple lines from the Arduino will be garbage but they will be sent after the initiation marker so processing will put them into the csv file. To avoid this, run the Processing sketch for a couple seconds, stop it, then run it again, this time it should work perfectly. Note, this only has to be done the first time you run the Processing sketch directly after you upload a new sketch to the Arduino.

## Screenshots
![picture](https://github.com/JSchiltz19/Arduino-Data-Logger/blob/master/Screenshots/Arduino_Capture.png)
![picture](https://github.com/JSchiltz19/Arduino-Data-Logger/blob/master/Screenshots/Spreadsheet_Capture.png)

## Built With

* [Processing](https://processing.org/) - Used to receive the data on the computer side.
* [Arduino IDE](https://www.arduino.cc/en/main/software/) - Used to format and send data to the computer.

## Contributing

Please read [CONTRIBUTING.md](https://github.com/JSchiltz19/Arduino-Data-Logger/blob/master/CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.


## Authors

* **John Schiltz**  - [JSchiltz19](https://github.com/JSchiltz19)



## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

Big thank you to Robin2 who's program I used as a the beginning framework for my work from his post in the Arduino forum [Serial Input Basics contd](https://forum.arduino.cc/index.php?topic=288234.msg2016582#msg2016582).

