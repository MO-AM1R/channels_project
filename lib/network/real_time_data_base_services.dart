import 'package:channels/models/message.dart';
import 'package:firebase_database/firebase_database.dart';

class RealTimeDataBaseServices{
  static final FirebaseDatabase _realTimeDB = FirebaseDatabase.instance;

  static FirebaseDatabase get realTimeDB => _realTimeDB;

  static addMessage(Message message, String chatId, String messageId) {
    final realtimeDBRef = _realTimeDB.ref('chats/$chatId/messages');

    realtimeDBRef.child('message$messageId').set({
      "body": message.body,
      "date": message.time.millisecondsSinceEpoch,
      "userName": message.userName,
    });

    final chatMetaRef = _realTimeDB.ref('chats/$chatId');
    chatMetaRef.update({
      "id": chatId,
    });
  }
}