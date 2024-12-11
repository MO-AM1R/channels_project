import 'package:channels/network/firebase_services.dart';
import 'package:channels/screens/home_screen.dart';
import 'package:channels/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthHandler extends StatelessWidget {
  const AuthHandler({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      FirebaseServices.login(user.uid);
      return const HomeScreen();
    } else {
      return const LoginPage();
    }
  }
}