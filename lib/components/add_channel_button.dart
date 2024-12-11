import 'package:flutter/material.dart';

class AddChannelButton extends StatelessWidget {
  final Function onTap;

  const AddChannelButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.black),
          foregroundColor: WidgetStatePropertyAll(
            Colors.white,
          ),
          padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: 10, horizontal: 20))),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add Channel',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          SizedBox(
            width: 50,
          ),
          Icon(
            Icons.add,
            size: 40,
          ),
        ],
      ),
    );
  }
}