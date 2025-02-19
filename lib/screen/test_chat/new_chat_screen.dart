import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doormster/models/chat_models/get_users.dart';
import 'package:doormster/screen/test_chat/auth_service.dart';
import 'package:doormster/screen/test_chat/chat_screen.dart';
import 'package:doormster/widgets/image/circle_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewChatScreen extends StatelessWidget {
  NewChatScreen({super.key});
  final auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Chat"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: auth.getListUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var users = snapshot.data!.docs;
          return ListView(
            children: users.map((DocumentSnapshot document) {
              getUsers user = getUsers.fromDocumentSnapshot(document);
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                leading: circleImage(
                  imageProfile: user.photoPath,
                  radiusCircle: 25,
                  typeImage: 'net',
                  backgroundColor: Get.theme.primaryColor,
                  iconImagenull: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 40,
                  ),
                  iconImageError:
                      const Icon(Icons.error, size: 40, color: Colors.white),
                ),
                title: Text(user.displayName),
                onTap: () {
                  Get.to(
                    () => ChatScreen(
                      receiverId: user.uid,
                      name: user.displayName,
                      image: user.photoPath,
                      pushToken: user.pushToken,
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
