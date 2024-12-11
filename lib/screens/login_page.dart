import 'package:channels/main.dart';
import 'package:channels/network/firebase_auth_services.dart';
import 'package:channels/components/custom_text_field.dart';
import 'package:channels/components/login_options.dart';
import 'package:channels/components/black_button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController(),
      password = TextEditingController();

  bool isLoading = false;
  String error = '';

  Future<void> loginProcess() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (email.text.isNotEmpty && password.text.isNotEmpty) {
        await FirebaseAuthServices.loginWithEmail(email.text, password.text);
        return;
      } else {
        error = 'Please fill all fields';
      }
    }
    catch(exception){
      error = 'Incorrect Email or Password';
    }

    setState(() {
      isLoading = false;
    });
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
                  Icons.login,
                  size: 180,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 50,
                ),
                Column(
                  children: [
                    CustomTextField(
                      controller: email,
                      icon: Icons.email,
                      label: 'Email',
                    ),
                    const SizedBox(
                      height: 30,
                    ),
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
                          navigationKey.currentState!
                              .pushReplacementNamed('/register');
                        },
                        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                        child: const Text('I don\'t have an account',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              decoration: TextDecoration.underline
                            ))),
                    const SizedBox(
                      height: 30,
                    ),
                    isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.black,
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: BlackButton(onTap: loginProcess, text: 'Login',),
                          ),
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