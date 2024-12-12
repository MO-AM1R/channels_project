import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  final String body, userName;
  final Timestamp time;

  Message(this.body, this.userName, this.time);

  @override
  String toString() {
    return 'Message{body: $body, userName: $userName, time: $time}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message &&
          runtimeType == other.runtimeType &&
          userName == other.userName &&
          time == other.time;

  @override
  int get hashCode => userName.hashCode ^ time.hashCode;
}