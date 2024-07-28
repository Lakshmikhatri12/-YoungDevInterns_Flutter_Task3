import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/loginscreens/home.dart';

import 'package:myapp/loginscreens/login.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          storageBucket: "myapp-bbb95.appspot.com",
          apiKey: "AIzaSyC6oH69w5fJKcr1pgDC9Wpn5S6w2Y6oryU",
          appId: "1:979803369002:android:d2af53857c4a978c0ddd53",
          messagingSenderId: "979803369002",
          projectId: "myapp-bbb95"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return UploadPdfScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
