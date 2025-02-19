import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doormster/models/chat_models/get_chats.dart';
import 'package:doormster/models/chat_models/get_users.dart';
import 'package:doormster/screen/test_chat/auth_service.dart';
import 'package:doormster/screen/test_chat/chat_screen.dart';
import 'package:doormster/screen/test_chat/chats_service.dart';
import 'package:doormster/screen/test_chat/new_chat_screen.dart';
import 'package:doormster/widgets/image/circle_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
// with AutomaticKeepAliveClientMixin
{
  final auth = AuthService();
  final ChatService _chatService = ChatService();

  // @override
  // bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _chatService.getChatLists(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var chatsData = snapshot.data!.docs;

          if (chatsData.isEmpty) {
            return const Center(child: Text('No chats available.'));
          }

          return ListView.builder(
            itemCount: chatsData.length,
            itemBuilder: (context, index) {
              getChats chat = getChats.fromDocumentSnapshot(chatsData[index]);

              var participants = List<String>.from(chat.participants);
              String receiverId = participants
                  .firstWhere((uid) => uid != auth.auth.currentUser!.uid);
              bool islastMessageSender =
                  chat.lastMessageSenderId == auth.auth.currentUser!.uid;

              return FutureBuilder<DocumentSnapshot>(
                future: auth.getUsers(receiverId),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Get.theme.primaryColor,
                        child: const Icon(Icons.person,
                            size: 40, color: Colors.white),
                      ),
                      title: const Text('Loading...'),
                    );
                  }

                  var userData = userSnapshot.data!;
                  getUsers user = getUsers.fromDocumentSnapshot(userData);

                  return ListTile(
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
                        iconImageError: const Icon(Icons.error,
                            size: 40, color: Colors.white),
                      ),
                      title: Text(user.displayName,
                          style: TextStyle(color: Get.theme.dividerColor)),
                      subtitle: islastMessageSender
                          ? Text(
                              "คุณ: ${chat.lastMessage}",
                              style: const TextStyle(color: Colors.grey),
                            )
                          : Text(
                              chat.lastMessage ?? '',
                              style: TextStyle(
                                  color: chat.lastMessageRead == false
                                      ? Get.theme.dividerColor
                                      : Colors.grey),
                            ),
                      onTap: () {
                        Get.to(
                          () => ChatScreen(
                            receiverId: receiverId,
                            chatId: chat.chatId,
                            name: user.displayName,
                            image: user.photoPath,
                            pushToken: user.pushToken,
                          ),
                        );
                      });
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => NewChatScreen());
        },
        child: const Icon(Icons.edit_square),
      ),
    );
  }
}
