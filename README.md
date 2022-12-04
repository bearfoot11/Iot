# 1. LED 

## 1.1 LED Arduino Code 설명

```C
void setup(){
  Serial.begin(9600);
  pinMode(13, OUTPUT); // 13번 핀에 LED.
}

void loop(){
  int dly = (Serial.readString()).toInt(); // 앱인벤터에서 프로세싱으로 보낸 시리얼 값을 받아 정수형으로 변환.
  digitalWrite(13, HIGH);
  delay(dly); 
  digitalWrite(13, LOW);
  delay(dly); // dly 값 만큼 딜레이를 걸어 led가 켜졌다 꺼지는 주기를 맞춤.
}
```
## 1.2 LED Processing Code 설명

```C
import processing.serial.*; // 시리얼 사용
import processing.net.*;

Serial p; // 시리얼로 아두이노 연결
Server s; // 서버로 앱인벤터 연결
Client c; // 앱인벤터(클라이언트)

void setup() {
  s = new Server(this, 1234); // 포트 암호 1234로 서버 생성.
  p = new Serial(this, "COM3", 9600); // 3번 포트에 있는 아두이노와 연결.
}
String msg;

void draw() {
  c = s.available();
  if (c!=null) {
    String m = c.readString(); // 앱인벤터에서 보낸 문자열을 받음.
    int n = m.indexOf("\r\n\r\n")+4; 
    m = m.substring(n);
    m += '\n';
    print(m);
    p.write(m);                     // LED가 깜빡이는 주기.
  }
  if (p.available()>0) { // 시리얼 통신이 될때
    String m = p.readStringUntil('\n');  // 엔터 전까지 읽어들임.
    if (m!=null) {
      msg = m;
      print(m);
    }
  }
}
```

## 1.3 LED App Inventor 설명

![image](https://user-images.githubusercontent.com/101939148/205499868-4c3f8e28-2738-48c4-bd9a-f6c16d4bde33.png)

1초마다 프로세싱으로 TextBox1에 입력한 값(아두이노 dly에 저장할 값)을 보낸다.

# 2. TMP

## 2.1 TMP Arduino Code 설명
```C
void setup(){
  Serial.begin(9600);
}

double th(int v) { // 온도 섭씨 변환 함수
  double t;
  t = log(((10240000/v) - 10000));
  t = 1 /(0.001129148 + (0.000234125*t) + (0.0000000876741*t*t*t));
  t = t - 273.15;
  return t;
}
void loop(){
  int a=analogRead(A0); // 온도센서로 측정한 온도 값 a에 저장.
  Serial.println(th(a)); // 섭씨로 변환된 온도값을 시리얼을 통해 서버로 보냄.
}
```

## 2.2 TMP Processing Code 설명
```C
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
  c.write("HTTP/1.1 200 OK\r\n"); // POST 규격
  c.write("Content-length: " + msg.length() + " \r\n\r\n"); // 데이터 길이
  c.write(msg);  // 온도값을 앱인벤터로 보냄.

  if (p.available()>0) {
    String m = p.readStringUntil('\n');
    if (m!=null) {
      msg = m;
      print(m);
    }
  }
}
```
## 2.3 TMP App Inventor 설명

![image](https://user-images.githubusercontent.com/101939148/205499838-807ea927-39f1-4748-a1b6-191c8dd396a2.png)

프로세싱으로부터 받은 온도 값을 Label1에 텍스트로 출력함.
