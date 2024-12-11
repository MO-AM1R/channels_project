import 'package:channels/models/channel.dart';

class User{
  final String userName, id;
  final List<Channel> subscribedChannels;

  User({required this.userName, required this.id, required this.subscribedChannels});

  @override
  String toString() {
    return 'User{userName: $userName, id: $id, subscribedChannels: $subscribedChannels}';
  }
}