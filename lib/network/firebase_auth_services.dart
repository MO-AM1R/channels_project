import 'dart:developer';
import 'package:channels/main.dart';
import 'package:channels/screens/otp_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> loginWithEmail(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> registerWithEmail(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  static Future<void> loginWithPhone(String phone) async {
    await _auth.signInWithPhoneNumber(phone);
  }

  static Future<void> registerWithPhone(String phone, Function errorFunc) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
        verificationFailed: (FirebaseAuthException error) {
          log("Verification failed: ${error.message}");
          errorFunc();
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          navigationKey.currentState!.pushReplacement(MaterialPageRoute(builder: (context) {
            return OtpPage(verificationId: verificationId);
          },));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          log('Timed out');
        },
      );
    } catch (exception) {
      log(exception.toString());
    }
  }

  static String get getUserId => _auth.currentUser!.uid;

  static void logout() async {
    await _auth.signOut();
  }
}
