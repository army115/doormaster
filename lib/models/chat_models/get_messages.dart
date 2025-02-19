import 'package:cloud_firestore/cloud_firestore.dart';

class getMessages {
  String senderId;
  String receiverId;
  String message;
  DateTime timestamp;
  bool read;

  getMessages({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    required this.read,
  });

  factory getMessages.fromDocumentSnapshot(DocumentSnapshot doc) {
    return getMessages(
      senderId: doc['senderId'],
      receiverId: doc['receiverId'],
      message: doc['message'],
      timestamp: (doc['timestamp'] as Timestamp).toDate(),
      read: doc['read'] ?? false,
    );
  }
}
