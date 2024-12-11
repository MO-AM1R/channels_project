import 'package:flutter/material.dart';

class SendMessageRow extends StatelessWidget {
  final Function sendMessage;
  const SendMessageRow({super.key, required this.sendMessage});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      color: Colors.black,
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white70)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white70)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white70)),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                hintText: 'Enter your message ...',
              ),
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () {
                sendMessage(controller.text);
              },
              icon: const Icon(
                Icons.send,
                size: 30,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}