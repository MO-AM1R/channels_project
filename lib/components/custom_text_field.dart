import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final bool obscureText;
  final String label;

  const CustomTextField(
      {super.key,
        required this.controller,
        required this.icon,
        required this.label,
        this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
        prefixIcon: Icon(icon, color: Colors.black),
      ),
      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
      obscureText: obscureText,
    );
  }
}