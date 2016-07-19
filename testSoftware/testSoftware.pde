// Canastra Project (Team Gama) Testing Software

import processing.serial.*;
import grafica.*;

Serial port;
String msg;
int numParam = 9; // Number of parameters to be received
GPlot plot;
GPointsArray points;
ArrayList<CanSatReading> readings;
CanSatReading receiving;

void setup() {
  size(850,660);
  background(150);
  // Open the port that the board is connected to and use the same speed
  port = new Serial(this,"/dev/ttyUSB0", 19200);
  port.bufferUntil('#'); //Stop buffer in the Header Character

  plot = new GPlot(this);
  plot.setPos(25, 25);
  plot.setDim(250,250);
  plot.setTitleText("CanSat Sensor Readings");
  plot.getXAxis().getAxisLabel().setText("Timestamp");
  plot.getYAxis().getAxisLabel().setText("GPS Elevation");
}

void draw() {
  background(255);
  if(receiving != null){
  plot.addPoint(float(receiving.Timestamp),float(receiving.GPS_Elev));
  plot.beginDraw();
  plot.drawBackground();
  plot.drawBox();
  plot.drawXAxis();
  plot.drawYAxis();
  plot.drawTitle();
  plot.drawGridLines(GPlot.BOTH);
  plot.drawLines();
  plot.drawPoints();
  plot.endDraw();}
  
}

void serialEvent(Serial p) {
  //Get a message with all parameters in a timestamp
  msg = p.readString(); //<>//

  if(msg != null){
    //Divide message to try to get each parameter
    String [] data = msg.split("\n");
    if(hasRightParameters(data)){
      receiving = new CanSatReading(data);
      

      receiving.display();
    }
  } //<>//
}



//Function to check if all parameters were received correctly.
boolean hasRightParameters(String[] data){ //<>//
  int count = 0;
  //Check against numParam + 2 because it will have
  //the first data as a newline character
  //and the last one as the header
  if(data.length == (numParam + 2)){
    if(data[1].indexOf("Timestamp") != -1) count++;
    if(data[2].indexOf("TeamID") != -1) count++;
    if(data[3].indexOf("External Temperature") != -1) count++;
    if(data[4].indexOf("Internal Temperature") != -1) count++;
    if(data[5].indexOf("External Luminosity") != -1) count++;
    if(data[6].indexOf("External Pressure") != -1) count++;
    if(data[7].indexOf("GPS Latitude") != -1) count++;
    if(data[8].indexOf("GPS Longitude") != -1) count++;
    if(data[9].indexOf("GPS Elevation") != -1) count++;
  } else return false;

  if(count == numParam) return true;
  else return false;
}


//Function to get a string in the format "name: value"
//and return the integer value.
int getParam(String data){
  String [] aux = data.split(":");
  
  return int(aux[1].substring(1).trim());
}

class CanSatReading{
  int Timestamp;
  int TeamID;
  int Temp_Ext;
  int Temp_Int;
  int Lum_Ext;
  int Press_Ext;
  int GPS_Lat;
  int GPS_Long;
  int GPS_Elev;

  //Creates a CanSatReading from a data received
  //in the format "name: value".
  CanSatReading(String [] data){
    Timestamp = getParam(data[1]);
    TeamID = getParam(data[2]);
    Temp_Ext = getParam(data[3]);
    Temp_Int = getParam(data[4]);
    Lum_Ext = getParam(data[5]);
    Press_Ext = getParam(data[6]);
    GPS_Lat = getParam(data[7]);
    GPS_Long = getParam(data[8]);
    GPS_Elev = getParam(data[9]);
  }

  //Method to display the Sensor Readings
  void display(){
    print("Timestamp: " + Timestamp + "\n");
    print("TeamID: " + TeamID+ "\n");
    print("External Temperature: ", Temp_Ext+ "\n");
    print("Internal Temperature: ", Temp_Int+ "\n");
    print("External Luminosity: ", Lum_Ext+ "\n");
    print("External Pressure: ", Press_Ext+ "\n");
    print("GPS Latitude: ", GPS_Lat+ "\n");
    print("GPS Longitude: ", GPS_Long+ "\n");
    print("GPS_Elev: ", GPS_Elev+ "\n");
  }
}