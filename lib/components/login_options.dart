import 'package:channels/components/login_option.dart';
import 'package:flutter/material.dart';

class LoginOptions extends StatelessWidget {
  final String option1Src, option2Src;
  final Function option1Func, option2Func;

  const LoginOptions({
    super.key,
    required this.option1Src,
    required this.option1Func,
    required this.option2Func,
    required this.option2Src,
  });

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
            LoginOption(src: option1Src, onTap: () {
              option1Func();
            }),
            const SizedBox(width: 20),
            LoginOption(src: option2Src, onTap: () {
              option2Func();
            }),
          ],
        ),
      ],
    );
  }
}
