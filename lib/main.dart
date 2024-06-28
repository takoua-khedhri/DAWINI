import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pageAcceuil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDfz5uNS0jkRF0m1N40N7zLaFJY19RBxm0",
      authDomain: "dawini-cbec3.firebaseapp.com",
      projectId: "dawini-cbec3",
      storageBucket: "gs://dawini-cbec3.appspot.com",
      appId: "1:1087969584794:android:448204428274fc0702a123",
      messagingSenderId: "1087969584794",
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
