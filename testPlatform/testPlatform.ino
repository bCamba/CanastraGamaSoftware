/*  Project Canastra (Team Gama) - Test Platform for the ground station
  The test platform is reading from potentiometers to simulate
  ground station received values being transmitted to the software.

  Values printed to serial are raw and need processing.

  Version 1.0
*/

// Variable Declarations
int Timestamp;
int TeamID;
int R_Temp_Ext;
int R_Temp_Int;
int R_Lum_Ext;
int R_Press_Ext;
int R_GPS_Lat;
int R_GPS_Elev;
int R_GPS_Long;

void setup() {
  //Initialize Serial Connection
  Serial.begin(19200);

  //Initialize variables
  Timestamp = 0;
  TeamID = 3;
}

void loop() {

  //Read from sensors
  R_Temp_Ext = analogRead(A0);
  R_Temp_Int = analogRead(A1);
  R_Lum_Ext = analogRead(A2);
  R_Press_Ext = analogRead(A3);
  R_GPS_Lat = analogRead(A4);
  R_GPS_Elev = analogRead(A5);
  R_GPS_Long = R_GPS_Lat; //GPS_Lat = GPS_Long for simplicity:
                          //using only 6 potentiometers.

  //Print to Serial
    Serial.println('#');
    printLabel("Timestamp: ", Timestamp);
    printLabel("TeamID: ", TeamID);
    printLabel("External Temperature: ", R_Temp_Ext);
    printLabel("Internal Temperature: ", R_Temp_Int);
    printLabel("External Luminosity: ", R_Lum_Ext);
    printLabel("External Pressure: ", R_Press_Ext);
    printLabel("GPS Latitude: ", R_GPS_Lat);
    printLabel("GPS Longitude: ", R_GPS_Long);
    printLabel("GPS Elevation: ", R_GPS_Elev);
    //Serial.println();

  //Update fake timestamp
  Timestamp = Timestamp + 1;
  delay(100);
}


//Function to print the Label followed by the sensor value
//in the same line.
void printLabel(String Label,int Sensor) {
  Label += Sensor;
  Serial.println(Label);
}
