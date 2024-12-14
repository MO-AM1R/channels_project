import 'dart:async';
import 'package:channels/main.dart';
import 'package:channels/network/firebase_auth_services.dart';
import 'package:channels/components/custom_text_field.dart';
import 'package:channels/components/login_options.dart';
import 'package:channels/components/black_button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function loggedIn;

  const LoginPage({
    super.key,
    required this.loggedIn,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController(),
      password = TextEditingController(),
      phone = TextEditingController();

  String selectedMethod = 'email';
  bool isLoading = false;
  String error = '';
  late Timer delay;

  Future<void> loginProcess() async {
    setState(() {
      isLoading = true;
    });

    if (selectedMethod == 'email') {
      if (email.text.isNotEmpty && password.text.isNotEmpty) {
        try {
          await FirebaseAuthServices.loginWithEmail(email.text, password.text);
          widget.loggedIn();
        } catch (_) {
          error = 'Incorrect password or email';
        }
      } else {
        error = 'Please fill all fields';
      }
    } else {
      if (phone.text.isNotEmpty) {
        try {
          await FirebaseAuthServices.loginWithPhone(phone.text);
          widget.loggedIn();
        } catch (_) {
          error = 'Incorrect phone number';
        }
      } else {
        error = 'Please fill all fields';
      }
    }
    setState(() {});

    delay = Timer(const Duration(seconds: 2), () {
      setState(() {
        error = '';
      });
    });

    setState(() {
      isLoading = false;
    });
  }

  Future<void> loginInWithGoogle() async {
    bool loggedIn = await FirebaseAuthServices.signInWithGoogle();

    if (!loggedIn) {
      setState(() {
        error = 'Error hav been occurred';
      });
    } else {
      widget.loggedIn();
    }
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
                const SizedBox(height: 80),
                const Icon(Icons.login, size: 180, color: Colors.black),
                const SizedBox(height: 50),
                buildLoginContent(),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    error,
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 20),
                LoginOptions(
                    option1Src: 'google.png',
                    option1Func: () {
                      loginInWithGoogle();
                    },
                    option2Func: () {
                      setState(() {
                        selectedMethod =
                            selectedMethod == 'email' ? 'phone' : 'email';
                      });
                    },
                    option2Src:
                        selectedMethod == 'email' ? 'phone.png' : 'email.png'),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    navigationKey.currentState!
                        .pushReplacementNamed('/register');
                  },
                  overlayColor:
                      const WidgetStatePropertyAll(Colors.transparent),
                  child: const Text(
                    'I don\'t have an account',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                isLoading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : BlackButton(
                        onTap: loginProcess,
                        text: 'Login',
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
