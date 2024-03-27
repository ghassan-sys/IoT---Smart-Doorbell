# SmartMeet Doorbell

The SmartMeet Doorbell is an innovative project that transforms the way meeting rooms are managed. It's designed as a smart doorbell system for meeting room doors, allowing users to reserve rooms through an Android app built with Flutter and Dart. The system ensures that rooms are only reserved when available, supporting multiple users to efficiently manage meeting space.

## Features

- **Room Availability**: Users can check real-time availability and reserve meeting rooms.
- **Multi-user Support**: Allows multiple users to interact with the system simultaneously.
- **Smart Notifications**: Sends alerts when a room is successfully reserved or when reservations are upcoming.
- **Display**: the OLED screen will present the status of the meeting - sad emoji when the Room is occupied, happy emoji when the room is empty. In addition to that, pressing the button will display more information about the current owner of the meeting (if exist)
- **Notifications**: When person presses the button outside the Room at a time where the room has an ongoing meeting, a notification will be sent to the meeting owner.
- **Easy Integration**: Designed to be integrated with existing meeting room management systems.

## Getting Started

To get started with the SmartMeet Doorbell, you'll need the following hardware:

- ESP32 with CP2102 module
- OLED display module
- Push button
- Power Bank or any 5V power source

Follow the instructions in the `Connections` section below to assemble the hardware.

## Connections

**Bold and Bright Schematic for Assembly:**

![SmartMeet Doorbell Schematic](image.png)

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

## Usage

After installation and configuration:

1. Users can reserve a meeting room through the app.
2. The OLED display will show the status of the meeting room door.
3. The push button can be used to simulate a doorbell for the meeting room.

## Contributing

If you would like to contribute to the development of the SmartMeet Doorbell, please fork the repository and submit a pull request with your suggested changes.

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.

## Acknowledgments

- Thanks to all contributors who have helped to build this project.
- Special thanks to the open-source community for providing invaluable resources.

