import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/screens/mainscreen.dart';
import 'package:todo/screens/splash.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }

          if (snapshots.hasData) {
            return Mainscreen();
          }

          return const LoginScreen();
        });
  }
}
