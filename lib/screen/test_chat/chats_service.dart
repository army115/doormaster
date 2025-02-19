import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> sendMessage({
    required String message,
    required String receiverId,
    String? name,
    String? photoPath,
    List<dynamic>? pushToken,
  }) async {
    String senderId = auth.currentUser!.uid;
    List<String> ids = [senderId, receiverId]..sort();
    String chatId = ids.join("-");
    Timestamp timeStamp = Timestamp.now();
    DocumentReference chatDoc = firestore.collection('chats').doc(chatId);

    try {
      await chatDoc.set({
        'chatId': chatId,
        'participants': [senderId, receiverId],
        'lastMessage': message,
        'lastMessageTimestamp': timeStamp,
        'lastMessageSenderId': senderId,
        'lastMessageRead': false,
        'updatedAt': timeStamp,
      }, SetOptions(merge: true));

      await chatDoc.collection('messages').add({
        'senderId': senderId,
        'receiverId': receiverId,
        'message': message,
        'timestamp': timeStamp,
        'read': false,
      });

      await chatNotification(chatId, name!, message, pushToken!);
    } catch (e) {
      debugPrint("Error sending message: $e");
    }
  }

  Future chatNotification(String chatId, String name, String message,
      List<dynamic> pushToken) async {
    try {
      var url = 'http://localhost:3000/chat-notification';
      var token =
          "ya29.c.c0ASRK0GYpJYcFhNCyvvDEEfJdxfmAlxBFPItcAncIBTPbrAJ3sSAB_pmUIiE4rcbdPrpw6MXWFrrSo0_xUh7I-FchSgsbOhHntTlDVqmO23M6p8i259G8u2zIg2azsm6KomUAbvyJ2XXhrZHGXglBvwls7ui_98-U9tkzjF_9zd2RVTwl0r4fn3Rz6sGJmDtdfmf-USUuXDpmijWRttPsloK8mmzvNrHxkPhbWihMpbXPJaSBJQjHYu-UmYH_LpcecaNxCPZkm1JfFWD2DlkCFEHN1bTHmnqsuzg62M3N6kGMc8bifvAYzfxPhS8JO4qFHthInLF4FnjS_bBscgJMSxj_Iak2iZmKf_lcsijbFLkHis-h0RjoR8WdG385Km9pajMjp9g2WxU7YkSOr_8jhOkiwjgZuWrWJeVdv7ib-FxyZ1ysdi94tBV33h77Ur6BJdhJFeRVn1VZVIk_R5q1macUb1Z15ZlYqqkarZZq_FMdBecM3MYpjJu1npyZfXeVgOS9lcRtRthO00ya_JfRzUFq83aiIBh8ymn8mySQ3Oppq-FVBzjittZzSXO6WgJp8Of85-fhk945lmJtvI82gu8_6Qkq9Bl90qF7ao3SlqcgMpqBQbdJ9mq8wb_Bnc5jU43sc9OOunrdFnhmozh-cIItJlJzlMyXb206lc3Iz2W7YkOIWVnJ1q-c32iYdcr21Bk1novQw597XWBRw6iQujfQ8JF3mR2ZYpe3J95thM75BgMomRQRRxzYMJdbBMJJ_IrkO7h1hraYtumvsSo7B2_juv2zaJ2cuawUuSO_Zw5ojOJnQihQOUUrn1ty9ns4m4v1plp8Rt9MrBQ4bFJls-qFySfMfFBkY3b150Bg9zXey582Xd91WqQlj5dbzFVibXdwjkjZvznIs_lwvts9aukYJqnxq7UajRi43ZqX7jer7IU-gIUb_7cFzB01-9ZR7rrBRvB209Yfmeh1Qjb7qYUxwsucxRImx49fin0bbO28w6gvOeXJcnI";
      for (var isToken in pushToken) {
        var response = await Dio().post(url,
            options: Options(headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token'
            }),
            data: {
              "targetToken": isToken,
              "title": name,
              "body": message,
              "payload": {"data": chatId, "route": "/chat"}
            }).timeout(const Duration(seconds: 7));
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint('Success');
          return response.data;
        }
      }
    } on DioError catch (error) {
      debugPrint(" error: ${error.message}");
      return error.message;
    } finally {}
  }

  Future<void> markMessagesAsRead(String chatId, String receiverId) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('receiverId', isEqualTo: receiverId)
        .where('read', isEqualTo: false)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      List<DocumentSnapshot> messages = querySnapshot.docs;
      DocumentSnapshot latestMessage = messages.first;
      Timestamp latestMessageTimestamp = latestMessage['timestamp'];

      for (DocumentSnapshot doc in messages) {
        await doc.reference.update({'read': true});
      }

      await firestore.collection('chats').doc(chatId).update({
        'lastMessageRead': true,
        'lastMessageTimestamp': latestMessageTimestamp,
      });
    }
  }

  Stream<QuerySnapshot> getMessages(String receiverId) {
    String senderId = auth.currentUser!.uid;
    List<String> ids = [senderId, receiverId]..sort();
    String chatId = ids.join("-");

    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getChatLists() {
    String senderId = auth.currentUser!.uid;

    return firestore
        .collection('chats')
        .where('participants', arrayContains: senderId)
        .snapshots();
  }
}
