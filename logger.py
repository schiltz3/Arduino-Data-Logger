import argparse
import time
import serial


class arduinoParser:
    def parse_args(self):
        parser = argparse.ArgumentParser()
        parser.add_argument("COM", help="the COM port. ex: COM3")
        parser.add_argument(
            "maxTime",
            type=int,
            help="the maximum amount of time you want the program to run for",
        )
        parser.add_argument("filename", help="the name of the log file")
        parser.add_argument("self.columns", help="the column names for the log file")
        parser.add_argument(
            "--debug",
            action="store_true",
            help="set to true to see more debugging information",
        )
        return parser.parse_args()

    def __init__(self) -> None:
        # initialize the variables used
        self.h = 0
        self.min = 0
        self.s = 0
        self.m = 0
        self.time = 0
        self.timeOffset = 0
        self.maxCharacters = 0
        self.loop = 0
        self.fileWrites = 0
        self.row = ""
        self.incomingString = ""
        self.incomingCharacters = ""
        self.characterCount = 0
        self.newData = False
        self.receiveInProgress = False
        self.overflow = False
        self.initialize = False

        args = self.parse_args()
        self.COM = args.COM
        self.maxTime = args.maxTime
        self.filename = args.filename
        self.columns = args.columns
        self.debug = args.debug

        # initialize, start, and end markers.
        self.startMarker = "<"
        self.endMarker = ">"
        self.initializeMarker = "^"

        # Sampling setup
        self.samples = 1000
        # maximum number of data self.samples you want
        maxChars = 56
        # set to one higher than the most characters transmitted

    def setup(self):
        self.update_time()
        output = self.create_writer(
            self.filename + str(self.min) + str(self.s) + ".csv"
        )
        ArduinoSerial = serial.Serial(self.COM, 115200)
        output.println(self.columns)
        self.update_time()
        self.timeOffset = (((min * 60) + self.s) * 1000) + self.m
        print("setup Complete")

    def draw(self):
        while time <= self.maxTime and self.loop < self.samples:
            self.update_time()
            self.receive_with_start_end_markers()
            if newData == True:
                print("Latest transmition:", self.row)
                newData = False
            self.update_time()
            time = ((((min * 60) + self.s) * 1000) + self.m) - self.timeOffset
        self.key_pressed()

    def receive_with_start_end_markers(self):
        character_count = 0
        while self.ArduinoSerial.available() > 0 and newData == False:
            incoming_characters = self.ArduinoSerial.readChar()
            incoming_string = str(incoming_characters)
            if self.debug:
                print("Incoming Serial:", incoming_string)
            if incoming_string != None:
                if receive_in_progress == True:
                    if incoming_characters != self.endMarker:
                        row += incoming_string
                        character_count += 1
                        if character_count > maxCharacters:
                            maxCharacters = character_count
                        if character_count >= self.maxChars:
                            if self.debug:
                                print(
                                    "character_count:",
                                    character_count,
                                    "                  Overflow",
                                )
                            overflow = True
                    else:
                        if self.debug:
                            print("self.endMarkerHit")
                        if overflow == False:
                            output.println(row)
                            file_writes += 1
                        receive_in_progress = False
                        character_count = 0
                        newData = True
                        overflow = False
                        self.loop += 1
                elif incoming_characters == self.startMarker and initialize == True:
                    if self.debug:
                        print("self.startMarkerHit")
                    row = ""
                    receive_in_progress = True
                elif incoming_characters == self.initializeMarker:
                    print("self.initializeMarkerHit")
                    row = ""
                    initialize = True
            else:
                if self.debug:
                    print("Incoming String = null")

    def key_pressed(self):
        output.flush()
        output.close()
        print("End of transmitions")
        if self.debug:
            print("Number of self.loops:", self.loop)
            print("Number of writes:", self.file_writes)
            print("Total program run time:", time, "ms")
            print("Longest transmition:", self.maxCharacters, "characters")
            print(
                "Set maxCharacters to",
                self.maxCharacters + 1,
                "to guard against overflows. Currently set at",
                self.maxChars,
            )
        exit()

    def update_time(self):
        # get the current time
        current_time = time.localtime()
        self.h = current_time.tm_hour
        self.min = current_time.tm_min
        self.s = current_time.tm_sec
        self.m = int(round(time.time() * 1000))
