import 'package:channels/models/chat.dart';

class Channel{
  final String id, name, description, imageUrl;
  final Chat chat;

  Channel({required this.id, required this.name, required this.description, required this.imageUrl, required this.chat});

  @override
  String toString() {
    return 'Channel{id: $id, name: $name, description: $description, imageUrl: $imageUrl, chat: $chat}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Channel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}