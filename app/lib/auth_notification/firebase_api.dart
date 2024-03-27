import 'package:firebase_messaging/firebase_messaging.dart';


Future<String?> initNotifications() async { // getting token device for enabling app notification
  final firebaseMessaging = FirebaseMessaging.instance;
  await firebaseMessaging.requestPermission();
  final fcmToken = await firebaseMessaging.getToken();
  return fcmToken;
}
