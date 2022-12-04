void setup(){
  Serial.begin(9600);
  pinMode(13, OUTPUT);
}

}
void loop(){
  int dly = (Serial.readString()).toInt();
  digitalWrite(13, HIGH);
  delay(dly);
  digitalWrite(13, LOW);
  delay(dly);
}
