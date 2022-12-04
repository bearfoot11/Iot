import processing.serial.*;
import processing.net.*;

Serial p;
Server s;
Client c;

void setup() {
  s = new Server(this, 1234);
  p = new Serial(this, "COM3", 9600);
}
String msg;

void draw() {
  c = s.available();
  if (c!=null) {
    String m = c.readString();
    int n = m.indexOf("\r\n\r\n")+4;
    m = m.substring(n);
    m += '\n';
    print(m);
    p.write(m);
  }
  if (p.available()>0) {
    String m = p.readStringUntil('\n');
    if (m!=null) {
      msg = m;
      print(m);
    }
  }
}
