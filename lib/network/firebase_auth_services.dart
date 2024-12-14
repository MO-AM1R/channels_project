import 'dart:developer';
import 'package:channels/constants.dart';
import 'package:channels/main.dart';
import 'package:channels/network/fire_store_services.dart';
import 'package:channels/screens/otp_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:channels/models/user.dart' as models;

class FirebaseAuthServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> loginWithEmail(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> registerWithEmail(String email, String password, String userName) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    await FireStoreServices.addUser(userName);

    user = models.User(
        userName: userName,
        id: FirebaseAuthServices.getUserId,
        subscribedChannels: []);
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
          navigationKey.currentState!.pushReplacement(MaterialPageRoute(
            builder: (context) {
              return OtpPage(verificationId: verificationId);
            },
          ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          log('Timed out');
        },
      );
    } catch (exception) {
      log(exception.toString());
    }
  }

  static Future<bool> signInWithGoogle() async {
    try{
      if(await GoogleSignIn().isSignedIn()){
        await GoogleSignIn().signOut();
      }

      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;

      final cred = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken,
      );

      await _auth.signInWithCredential(cred);

      String userName = googleUser!.displayName!;
      await FireStoreServices.addUser(userName);
      return true;
    }
    catch(error){
      log(error.toString());
    }
    return false;
  }

  static String get getUserId => _auth.currentUser!.uid;

  static void logout() async {
    await _auth.signOut();
  }
}
