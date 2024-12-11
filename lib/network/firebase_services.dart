import 'dart:developer';
import 'package:channels/constants.dart';
import 'package:channels/models/channel.dart';
import 'package:channels/models/chat.dart';
import 'package:channels/models/message.dart';
import 'package:channels/models/user.dart';
import 'package:channels/network/firebase_auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseServices {
  static final FirebaseFirestore _fStore = FirebaseFirestore.instance;
  static final FirebaseDatabase _realTimeDB = FirebaseDatabase.instance;

  static Future<void> login(String userId) async {
    final userDoc = await _fStore.collection('users').doc(userId).get();

    List<Channel> channels = [];
    List channelRefs = userDoc.get('subscribedChannels');

    for (DocumentReference channelRef in channelRefs) {
      channels.add(await extractChannel(channelRef));
    }

    user = User(
        userName: userDoc.get('userName'),
        id: userDoc.get('id'),
        subscribedChannels: channels);

    initialized = true;
  }

  static Future<Channel> extractChannel(DocumentReference channelRef) async {
    String name = (await channelRef.get()).get('name');
    String id = (await channelRef.get()).get('id');
    String description = (await channelRef.get()).get('description');
    String imageUrl = (await channelRef.get()).get('imageUrl');

    DocumentReference chatRef = (await channelRef.get()).get('chat');

    return Channel(
        id: id,
        name: name,
        description: description,
        imageUrl: imageUrl,
        chat: await extractChat(chatRef));
  }

  static Future<Chat> extractChat(DocumentReference chatRef) async {
    String chatId = (await chatRef.get()).get('id');

    List messagesRefs = (await chatRef.get()).get('messages');
    List<Message> messages = [];

    for (DocumentReference messageRef in messagesRefs) {
      messages.add(await extractMessage(messageRef));
    }

    return Chat(chatId, messages);
  }

  static Future<Message> extractMessage(DocumentReference messageRef) async {
    String body = (await messageRef.get()).get('body');
    String userName = (await messageRef.get()).get('userName');
    Timestamp time = (await messageRef.get()).get('date');

    return Message(body, userName, time);
  }

  static Future<void> setAllChannels() async {
    List<Channel> temp = [];
    await _fStore.collection('channels').get().then(
          (value) async {
        for (var doc in value.docs) {
          Map<String, dynamic> channelData = doc.data();

          temp.add(Channel(
              id: channelData['id'],
              name: channelData['name'],
              description: channelData['description'],
              imageUrl: channelData['imageUrl'],
              chat: await extractChat(channelData['chat'])));
        }
      },
    );

    channels = temp;
  }

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

  static addMessagesToFireStore(List<Message> messages, String chatId) async {
    // Get a reference to the FireStore collection for messages
    CollectionReference messagesRef = _fStore.collection('messages');

    // Get a reference to the chat document where the messages will be stored
    DocumentReference chatDocRef = _fStore.collection('chats').doc(chatId);

    try {
      List<DocumentReference> messageRefs = [];

      // Loop through each message, store it as a document in the 'messages' collection
      for (var message in messages) {
        // Add the message to the global 'messages' collection
        DocumentReference messageRef = await messagesRef.add({
          'body': message.body,
          'date': message.time,
          'userName': message.userName,
        });

        // Add the message reference to the list
        messageRefs.add(messageRef);
      }

      // Update the 'messages' field in the chat document with references to the message documents
      await chatDocRef.update({
        'messages': FieldValue.arrayUnion(messageRefs),
      });
    } catch (e) {
      //
    }
  }

  static void updateSubscribedChannels() async {
    try {
      // Reference to the users collection and the specific user document
      DocumentReference userRef = _fStore.collection('users').doc(user.id);

      // Create a list of references to the subscribed channels
      List<DocumentReference> channelRefs = user.subscribedChannels
          .map((channel) => _fStore.collection('channels').doc(channel.id))
          .toList();

      // Replace the old list with the new one
      await userRef.update({
        'subscribedChannels': channelRefs,
        // Replace the list of subscribed channels
      });
    } catch (e) {
      //
    }
  }

  static void addChannel(Channel channel) async {
    try {
      DocumentReference chatRef =
      _fStore.collection('chats').doc(channel.chat.id);

      await chatRef.set({
        'messages': [],
      });

      await _fStore.collection('channels').doc(channel.id).set({
        'name': channel.name,
        'imageUrl': channel.imageUrl,
        'description': channel.description,
        'chat': chatRef,
      });

      log('Channel and chat added successfully with specific IDs.');
    } catch (e) {
      log('Error adding channel and chat: $e');
    }
  }

  static void removeChannel(Channel channel) async {
    DocumentReference channelRef = _fStore.collection('/channels').doc(
        channel.id);

    DocumentReference chatRef = _fStore.collection('/chats').doc(
        channel.chat.id);

    if (user.subscribedChannels.contains(channel)) {
      DocumentReference userDocRef = _fStore.collection('/users').doc(
          FirebaseAuthServices.getUserId);

      await userDocRef.update({
        'subscribedChannels': FieldValue.arrayRemove([
          _fStore.collection('/channels').doc(channel.id)
        ]),
      });
    }

    await channelRef.delete();
    await chatRef.delete();
  }

  static addUser(String userId, String userName) async {
    try {
      DocumentReference userDoc =
      FirebaseFirestore.instance.collection('/users').doc(userId);

      // Data to add
      Map<String, dynamic> userData = {
        'userName': userName,
        'id': userId,
        'subscribedChannels': []
      };

      await userDoc.set(userData);

      log("Document added with ID: $userId");
    } catch (e) {
      log("Error adding document: $e");
    }
  }
}