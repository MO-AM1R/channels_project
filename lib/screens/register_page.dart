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
      userName = TextEditingController();

  bool isLoading = false;
  String error = '';
  late Timer delay;

  Future<void> registerProcess() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (email.text.isNotEmpty &&
          password.text.isNotEmpty &&
          userName.text.isNotEmpty) {

        await FirebaseAuthServices.registerWithEmail(email.text, password.text);

        await FireStoreServices.addUser(
            FirebaseAuthServices.getUserId, userName.text);

        user = User(
            userName: userName.text,
            id: FirebaseAuthServices.getUserId,
            subscribedChannels: []);

        initialized = true;

        navigationKey.currentState!.pushReplacementNamed('/home');
        return;
      } else {
        error = 'Please fill all fields';
      }
    } catch (exception) {
      if (password.text.length < 6) {
        error = 'Password should be at least 6 characters';
      } else {
        error = 'The account already exist';
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
                    CustomTextField(
                      controller: email,
                      icon: Icons.email,
                      label: 'Email',
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: password,
                      icon: Icons.password,
                      obscureText: true,
                      label: 'Password',
                    ),
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
                    const LoginOptions(),
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
                                onTap: registerProcess, text: 'Register'),
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