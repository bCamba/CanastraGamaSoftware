import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 
import grafica.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class testSoftware extends PApplet {




Serial port;
String msg;
int numParam = 9; // Number of parameters to be received
GPlot plot;
ArrayList<CanSatReading> readings;

public void setup() {
  
  background(150);
  // Open the port that the board is connected to and use the same speed
  port = new Serial(this,"/dev/ttyUSB0", 19200);
  port.bufferUntil('#'); //Stop buffer in the Header Character

  plot = new GPlot(this);
  plot.setPos(25, 25);
  plot.setDim(250,250);
  plot.setTitleText("CanSat Sensor Readings");
}

public void draw() {
}

public void serialEvent(Serial p) {
  //Get a message with all parameters in a timestamp
  msg = p.readString();

  if(msg != null){
    //Divide message to try to get each parameter
    String [] data = msg.split("\n");

    if(hasRightParameters(data)){

      for(int i = 1; i < data.length-1; i++){
        //try to split each parameter by name and value
        String [] param = data[i].split(":");
        String name = param[0];
        int value = PApplet.parseInt(param[1].substring(1).trim());

        print(name + ":" + value);
        delay(1000);
      }
    }
  }
     //<>//
}



//Function to check if all parameters were received correctly.
public boolean hasRightParameters(String[] data){
   //<>//
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

  CanSatReading(){
  }

  public void display(){
    print("Timestamp: " + Timestamp);
    print("TeamID: " + TeamID);
    print("External Temperature: ", Temp_Ext);
    print("Internal Temperature: ", Temp_Int);
    print("External Luminosity: ", Lum_Ext);
    print("External Pressure: ", Press_Ext);
    print("GPS Latitude: ", GPS_Lat);
    print("GPS Longitude: ", GPS_Long);
    print("GPS_Elev: ", GPS_Elev);
  }
}
  public void settings() {  size(800,600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "testSoftware" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
