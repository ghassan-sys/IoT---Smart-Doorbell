import 'package:firebase_core/firebase_core.dart';
import 'package:first_flutter_proj/app_pages/login_page.dart';
import 'package:first_flutter_proj/app_pages/sign_up_page.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // config it to my firebase
  await Firebase.initializeApp(options: FirebaseOptions(apiKey: 'AIzaSyCrSovJ1hoWk77iyIOTEQmrjsMmHVRIruo' , authDomain: "flutter-firebase-5ef08.firebaseapp.com",appId: "1:768430091594:web:54a801fd37825e1d58e5b3",
   messagingSenderId: "768430091594", projectId: "flutter-firebase-5ef08" , databaseURL: "https://flutter-firebase-5ef08-default-rtdb.europe-west1.firebasedatabase.app",storageBucket: "flutter-firebase-5ef08.appspot.com" ));

  runApp(MaterialApp(
    initialRoute: '/login',
    routes: {
      '/login': (context) => LoginPage(),
      '/signup': (context) => SignUpPage(),
    }
));
}