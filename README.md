# SmartMeet Doorbell

The SmartMeet Doorbell is an innovative project that transforms the way meeting rooms are managed. It's designed as a smart doorbell system for meeting room doors, allowing users to reserve rooms through an Android app built with Flutter and Dart. The system ensures that rooms are only reserved when available, supporting multiple users to efficiently manage meeting space.

## Features

- **Room Availability**: Users can check real-time availability and reserve meeting rooms.
- **Multi-user Support**: Allows multiple users to interact with the system simultaneously.
- **Smart Notifications**:
  - When person presses the button outside the Room at a time where the room has an ongoing meeting, a notification will be sent to the meeting owner.
  - Sends alerts when a room is successfully reserved.
- **Display**: the OLED screen will present the status of the meeting - sad emoji when the Room is occupied, happy emoji when the room is empty. In addition to that, pressing the button will display more information about the current owner of the meeting (if exist).
- **WiFi** - The ESP32 will be connected to WiFi via CP2102 controller. in HW, if there is a WiFi loss, an RGB light will blink with Blue Colors. 
- **Easy Integration**: Designed to be integrated with existing meeting room management systems.

## Getting Started

To get started with the SmartMeet Doorbell, you'll need the following hardware:

- ESP32 with CP2102 module
- OLED display module
- Push button
- RGB light.
- Power Bank or any 5V power source

Follow the instructions in the `Connections` section below to assemble the hardware.

## Connections

**Bold and Bright Schematic for Assembly:**

![connections](https://github.com/ghassan-sys/IoT---Smart-Doorbell/assets/77061886/f54c2b30-54ef-4614-a98b-7e422cfdc460)

Ensure each component is connected as shown in the schematic. The power source should be capable of supplying 5V to ensure stable operation of the ESP32 module.

## Software Installation

1. Clone the repository to your local machine.
2. Open the project in your Flutter development environment.
3. Configure the ESP32 module with the provided Arduino sketch.
4. Deploy the app to your Android device.

## Configuration

To configure the SmartMeet Doorbell:

1. Pair the ESP32 with your Android device via Bluetooth.
2. Send the Wi-Fi credentials from the Android app to the ESP32 to connect it to the network.
3. Set up room reservation details and timings through the app interface.

## Application:
![image](https://github.com/ghassan-sys/IoT---Smart-Doorbell/assets/77061886/42374189-c3ba-46fd-8848-86aae677cdfd)

## Contributions:
- **Students**: Ameer Giryes, Maher Odeh, Ghassan Shaheen
- **Supervisor**: Gilad Shmerler
