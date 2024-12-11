import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> loginWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (exception) {
      log(exception.toString());
    }
  }

  static Future<void> registerWithEmail(String email, String password) async{
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  static Future<void> loginWithPhone(String phone) async {
    try {
      await _auth.signInWithPhoneNumber(phone);
    } catch (exception) {
      log(exception.toString());
    }
  }

  static Future<void> registerWithPhone(String phone) async {
    try {
      // await _auth.verifyPhoneNumber(
      //     phoneNumber: phone,
      //     verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {});
    } catch (exception) {
      log(exception.toString());
    }
  }

  static String get getUserId => _auth.currentUser!.uid;

  static void logout() async {
    await _auth.signOut();
  }
}