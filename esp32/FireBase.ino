#include <Firebase_ESP_Client.h>
#include "Arduino.h"
#include "WiFi.h"
#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"

/*********************************************************** Define Values ***********************************************************/
#define API_KEY "AIzaSyAC-kxiHT4fScIOFC72N4z2zZMPTb97xP8"
#define DATABASE_URL "https://iot21022024-default-rtdb.europe-west1.firebasedatabase.app/"
#define WIFI_SSID "Ghassan’s iPhone"
#define WIFI_PASSWORD "65022757aGhI"
/***********************************************************               ***********************************************************/

/*********************************************************** Define Variables ***********************************************************/
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
bool signupOK = false;
String owner;
float floatVal;
unsigned long sendDataPrevMillis = 0;
int MeetingsInRoom;
const int buttonPin = 13;
int buttonState = 0;
/***********************************************************                  ***********************************************************/


void initFirebase() {
  Serial.println("starting initFirebase");
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;

  // anonymous sign up.
  if (Firebase.signUp(&config, &auth, "", "")) {
    Serial.println("signUp OK");
    signupOK = true;
  } else {
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }

  config.token_status_callback = tokenStatusCallback;  //see addons/TokenHelper.h
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  Serial.print("Connected to FireBase");
  Serial.println();
}

void initWiFi() {
  Serial.println("starting initWiFi");
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...\n");
  }

  Serial.print("Connected to Wifi! With IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();
}

void readRoom(int room_index, String BasePath) {
  String curPath;
  curPath = BasePath + "Meet" + String(room_index) + "/";
  printf("got Room%d with roomPath = %s\n", room_index, curPath);
  if (Firebase.RTDB.getFloat(&fbdo, curPath + "start_time")) {
    if (fbdo.dataType() == "float") {
      floatVal = fbdo.floatData();
      Serial.printf("Read from FireBase SUCESS! got %sstart_time = ", curPath);
      Serial.println(floatVal);
    }
  } else {
    Serial.println(fbdo.errorReason());
  }

  if (Firebase.RTDB.getFloat(&fbdo, curPath + "end_time")) {
    if (fbdo.dataType() == "float") {
      floatVal = fbdo.floatData();
      Serial.printf("Read from FireBase SUCESS! got %send_time = ", curPath);
      Serial.println(floatVal);
    }
  } else {
    Serial.println(fbdo.errorReason());
  }

  if (Firebase.RTDB.getString(&fbdo, curPath + "owner")) {
    if (fbdo.dataType() == "string") {
      owner = fbdo.stringData();
      Serial.printf("Read from FireBase SUCESS! got %sowner = ", curPath);
      Serial.println(owner);
    }
  } else {
    Serial.println(fbdo.errorReason());
  }
}

void setup() {
  Serial.begin(9600);
  pinMode(buttonPin, INPUT_PULLUP);
  initWiFi();
  initFirebase();
}


void loop() {
  String room_index;
  String BasePath;

  room_index = "1";
  BasePath = "/Room1/";
  MeetingsInRoom = 0;
  buttonState = digitalRead(buttonPin);

  // if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 15000 || sendDataPrevMillis == 0)) {
  if (Firebase.ready() && signupOK && (buttonState == HIGH)){
    sendDataPrevMillis = millis();

    if (Firebase.RTDB.getInt(&fbdo, "/Room1/MeetingsInRoom")) {
      if (fbdo.dataType() == "int") {
        MeetingsInRoom = fbdo.intData();
        Serial.printf("Read from FireBase SUCESS! got MeetingsInRoom = %d", MeetingsInRoom);
      }
    } else {
      Serial.println(fbdo.errorReason());
    }
    for (int i = 1; i < MeetingsInRoom + 1; i++) {
      readRoom(i, BasePath);
    }
  }
}
