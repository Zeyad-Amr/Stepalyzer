int fsrPin = 0;//Green    // the FSR and 10K pulldown are connected to a0
int fsrReading;      // the analog reading from the FSR resistor divider
#define vcc 12

void setup(void) {
  Serial.begin(9600);   
   pinMode(vcc, OUTPUT);
  digitalWrite(vcc,HIGH); 
}
 
void loop(void) {

  fsrReading = analogRead(fsrPin); 
  //sending temp
  String x=",";
  String z= x+ ""+String(fsrReading);
  Serial.print(z);
  delay(100);

 
//  Serial.print("Analog reading = ");
//  Serial.print(fsrReading);     // print the raw analog reading
 
//  if (fsrReading < 10) {
//    Serial.println(" - No pressure");
//  } else if (fsrReading < 200) {
//    Serial.println(" - Light touch");
//  } else if (fsrReading < 500) {
//    Serial.println(" - Light squeeze");
//  } else if (fsrReading < 800) {
//    Serial.println(" - Medium squeeze");
//  } else {
//    Serial.println(" - Big squeeze");
//  }

}
