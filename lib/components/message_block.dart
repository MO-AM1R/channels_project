import 'package:channels/constants.dart';
import 'package:channels/models/message.dart';
import 'package:flutter/material.dart';

class MessageBlock extends StatelessWidget {
  final Message message;

  const MessageBlock({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    DateTime time = message.time.toDate();

    return Align(
      alignment: message.userName == user.userName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      // Align the container in the center or adjust accordingly
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.person,
                  size: 20,
                ),
                Text(' ${message.userName}'),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                children: [
                  Text(
                    message.body,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '${time.hour}:${time.minute}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
