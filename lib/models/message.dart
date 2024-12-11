import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  final String body, userName;
  final Timestamp time;

  Message(this.body, this.userName, this.time);

  @override
  String toString() {
    return 'Message{body: $body, userName: $userName, time: $time}';
  }
}