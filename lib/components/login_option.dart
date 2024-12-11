import 'package:flutter/material.dart';

class LoginOption extends StatelessWidget {
  final String src;
  final Function onTap;
  const LoginOption({super.key, required this.src, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onTap();
      },
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      child: Container(
        width: 48,
        height: 48,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(
          'assets/images/$src',
        ),
      ),
    );
  }
}