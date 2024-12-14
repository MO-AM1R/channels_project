import 'dart:async';
import 'package:channels/components/black_button.dart';
import 'package:channels/components/custom_text_field.dart';
import 'package:channels/components/login_options.dart';
import 'package:channels/constants.dart';
import 'package:channels/main.dart';
import 'package:channels/models/user.dart';
import 'package:channels/network/firebase_auth_services.dart';
import 'package:channels/network/fire_store_services.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController email = TextEditingController(),
      password = TextEditingController(),
      userName = TextEditingController(),
      phone = TextEditingController();

  String selectedMethod = 'email';
  bool isLoading = false;
  String error = '';
  late Timer delay;

  Future<void> registerProcess() async {
    setState(() {
      isLoading = true;
    });

    if (selectedMethod == 'email') {
      if (email.text.isNotEmpty &&
          password.text.isNotEmpty &&
          userName.text.isNotEmpty) {
        try {
          await FirebaseAuthServices.registerWithEmail(
              email.text, password.text);
          await FireStoreServices.addUser(userName.text);

          user = User(
              userName: userName.text,
              id: FirebaseAuthServices.getUserId,
              subscribedChannels: []);

          initialized = true;

          navigationKey.currentState!.pushReplacementNamed('/home');
          return;
        } catch (exception) {
          if (password.text.length < 6) {
            error = 'Password should be at least 6 characters';
          } else {
            error = 'The account already exist';
          }
        }
      }
      else {
        error = 'Please fill all fields';
      }
    }
    else{
      if (phone.text.isNotEmpty) {
        try {
          await FirebaseAuthServices.registerWithPhone(phone.text, (){
            setState(() {
              error = "Verification failed. Please try again.";
            });
          });
        } catch (exception) {
          error = 'The phone number is incorrect';
        }
      }
      else {
        error = 'Please fill all fields';
      }
    }

    delay = Timer(const Duration(seconds: 2), () {
      setState(() {
        error = '';
      });
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    delay.cancel();
  }

  Widget buildEmailLogin() {
    return Column(
      children: [
        CustomTextField(
          controller: email,
          icon: Icons.email,
          label: 'Email',
        ),
        const SizedBox(height: 30),
        CustomTextField(
          controller: password,
          icon: Icons.password,
          obscureText: true,
          label: 'Password',
        ),
      ],
    );
  }

  Widget buildPhoneLogin() {
    return CustomTextField(
      controller: phone,
      icon: Icons.phone,
      textInputType: TextInputType.phone,
      label: 'Phone Number',
    );
  }

  Widget buildLoginContent() {
    switch (selectedMethod) {
      case 'phone':
        return buildPhoneLogin();
      case 'email':
      default:
        return buildEmailLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 80,
                ),
                const Icon(
                  Icons.app_registration,
                  size: 180,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 50,
                ),
                Column(
                  children: [
                    CustomTextField(
                      controller: userName,
                      icon: Icons.person,
                      label: 'User Name',
                    ),
                    const SizedBox(height: 20),
                    buildLoginContent(),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        error,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    LoginOptions(
                        option1Src: 'google.png',
                        option1Func: () {
                          setState(() {
                            /// TODO: google sign in
                          });
                        },
                        option2Func: () {
                          setState(() {
                            selectedMethod =
                                selectedMethod == 'email' ? 'phone' : 'email';
                          });
                        },
                        option2Src: selectedMethod == 'email'
                            ? 'phone.png'
                            : 'email.png'),
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                        onTap: () {
                          navigationKey.currentState!.pushReplacementNamed('/');
                        },
                        overlayColor:
                            const WidgetStatePropertyAll(Colors.transparent),
                        child: const Text('I have already an account',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                decoration: TextDecoration.underline))),
                    const SizedBox(
                      height: 30,
                    ),
                    isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.black,
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: BlackButton(
                              onTap: registerProcess,
                              text: selectedMethod == 'email'
                                  ? 'Register'
                                  : 'Send OTP',
                            ),
                          ),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}