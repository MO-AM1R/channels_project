import 'package:channels/network/fire_store_services.dart';
import 'package:channels/screens/home_screen.dart';
import 'package:channels/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthHandler extends StatefulWidget {
  const AuthHandler({super.key});

  @override
  State<AuthHandler> createState() => _AuthHandlerState();
}

class _AuthHandlerState extends State<AuthHandler> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      FireStoreServices.getUserInfo(user.uid);
      return const HomeScreen();
    } else {
      return LoginPage(loggedIn: () => setState(() {}),);
    }
  }
}
