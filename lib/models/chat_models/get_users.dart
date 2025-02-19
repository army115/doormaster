import 'package:cloud_firestore/cloud_firestore.dart';

class getUsers {
  String uid;
  String displayName;
  String email;
  String phoneNumber;
  String photoPath;
  List<dynamic> pushToken;
  DateTime createdAt;

  getUsers({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    required this.photoPath,
    required this.pushToken,
    required this.createdAt,
  });

  factory getUsers.fromDocumentSnapshot(DocumentSnapshot doc) {
    return getUsers(
      uid: doc['uid'],
      displayName: doc['displayName'],
      email: doc['email'],
      phoneNumber: doc['phoneNumber'],
      photoPath: doc['photoPath'],
      pushToken: doc['pushToken'],
      createdAt: (doc['createdAt'] as Timestamp).toDate(),
    );
  }
}
