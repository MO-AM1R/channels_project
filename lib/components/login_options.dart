import 'package:channels/components/login_option.dart';
import 'package:flutter/material.dart';

class LoginOptions extends StatelessWidget {
  const LoginOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            const Divider(
              thickness: 2,
              height: 80,
            ),
            Text(
              ' or with ',
              style: TextStyle(
                backgroundColor: Colors.grey[300],
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoginOption(src: 'google.png', onTap: () {}),
            const SizedBox(width: 20),
            LoginOption(src: 'phone.png', onTap: () {}),
          ],
        ),
      ],
    );
  }
}