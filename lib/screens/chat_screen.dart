import 'dart:async';
import 'package:channels/components/send_message_row.dart';
import 'package:channels/network/fire_store_services.dart';
import 'package:channels/network/real_time_data_base_services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:channels/components/message_block.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:channels/models/channel.dart';
import 'package:channels/models/message.dart';
import 'package:channels/constants.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final Channel channel;

  const ChatScreen({super.key, required this.channel});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController scrollController = ScrollController();
  late StreamSubscription<DatabaseEvent> listener;
  late DatabaseReference _messagesRef;
  late List<Message> messages;
  int newMessages = 0;

  @override
  void initState() {
    super.initState();

    messages = widget.channel.chat.messages;

    _messagesRef = RealTimeDataBaseServices.realTimeDB
        .ref()
        .child('chats/${widget.channel.chat.id}/messages');

    listener = _messagesRef.onChildAdded.listen((event) {
      final messageData = event.snapshot.value as Map;
      final message = Message(
        messageData['body'],
        messageData['userName'],
        Timestamp.fromMillisecondsSinceEpoch(messageData['date']),
      );

      if (mounted) {
        setState(() {
          if(!messages.contains(message)){
            messages.insert(0, message);
            ++newMessages;
          }
        });
      }
    });
  }

  void sendMessage(String body) async {
    final messageId = _messagesRef.push().key;

    final message = {
      'body': body,
      'userName': user.userName,
      'date': DateTime.now().millisecondsSinceEpoch,
    };

    await _messagesRef.child(messageId!).set(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        title: Text(
          'Chat ${widget.channel.name}',
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
            Expanded(
              child: ListView.builder(
                reverse: true,
                controller: scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return MessageBlock(message: messages[index]);
                },
              ),
            ),
            SendMessageRow(
              sendMessage: sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() async {
    super.dispose();

    listener.cancel();

    await FireStoreServices.addMessagesToFireStore(
      // new messages
      messages.sublist(0, newMessages),
      widget.channel.chat.id,
    );
  }
}