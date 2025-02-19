import 'package:cloud_firestore/cloud_firestore.dart';

class getChats {
  String chatId;
  List<String> participants;
  String lastMessage;
  DateTime lastMessageTimestamp;
  String lastMessageSenderId;
  bool lastMessageRead;
  DateTime updatedAt;

  getChats({
    required this.chatId,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    required this.lastMessageSenderId,
    required this.lastMessageRead,
    required this.updatedAt,
  });

  factory getChats.fromDocumentSnapshot(DocumentSnapshot doc) {
    return getChats(
      chatId: doc['chatId'],
      participants: List<String>.from(doc['participants']),
      lastMessage: doc['lastMessage'],
      lastMessageTimestamp: (doc['lastMessageTimestamp'] as Timestamp).toDate(),
      lastMessageSenderId: doc['lastMessageSenderId'],
      lastMessageRead: doc['lastMessageRead'] ?? false,
      updatedAt: (doc['updatedAt'] as Timestamp).toDate(),
    );
  }
}
