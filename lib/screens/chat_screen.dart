import 'package:channels/components/message_block.dart';
import 'package:channels/components/send_message_row.dart';
import 'package:channels/constants.dart';
import 'package:channels/models/channel.dart';
import 'package:channels/models/message.dart';
import 'package:channels/network/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Channel? channel;
  int? newMessagesIndex;

  void sendMessage(String body) async{
    List<Message> messages = channel!.chat.messages;
    Message message = Message(body, user.userName, Timestamp.now());
    messages.add(message);
    setState(() {});

    await FirebaseServices.addMessage(message, channel!.chat.id, messages.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    channel ??= ModalRoute.of(context)?.settings.arguments as Channel;
    newMessagesIndex ??= channel!.chat.messages.length;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        title: Text(
          '${channel!.name} Chat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
            fontSize: 25,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: channel!.chat.messages.length,
                itemBuilder: (context, index) {
                  return MessageBlock(message: channel!.chat.messages[index]);
                },
              ),
            ),
            SendMessageRow(sendMessage: sendMessage),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() async{
    super.dispose();

    await FirebaseServices.addMessagesToFireStore(channel!.chat.messages
    .sublist(newMessagesIndex!), channel!.chat.id);
  }
}