import 'package:channels/models/message.dart';

class Chat{
  final String id;
  late List<Message> messages;

  Chat(this.id, this.messages);

  @override
  String toString() {
    return 'Chat{id: $id, messages: $messages}';
  }
}