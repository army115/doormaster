import 'package:doormster/models/chat_models/get_messages.dart';
import 'package:doormster/screen/test_chat/auth_service.dart';
import 'package:doormster/screen/test_chat/chats_service.dart';
import 'package:doormster/utils/date_time_utils.dart';
import 'package:doormster/widgets/button/buttonback_appbar.dart';
import 'package:doormster/widgets/image/circle_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String? chatId;
  final String name;
  final String? image;
  final List<dynamic>? pushToken;

  const ChatScreen(
      {super.key,
      required this.receiverId,
      this.chatId,
      required this.name,
      this.image,
      this.pushToken});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final auth = AuthService();
  final ChatService _chatService = ChatService();

  void _sendMessage() {
    String message = _controller.text.trim();
    if (message.isNotEmpty) {
      _chatService.sendMessage(
          message: message,
          receiverId: widget.receiverId,
          name: widget.name,
          photoPath: widget.image,
          pushToken: widget.pushToken);
      _controller.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        leading: button_back(() {
          Get.until((route) => route.isFirst);
        }),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: _chatService.getMessages(widget.receiverId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (widget.chatId != null) {
                      _chatService.markMessagesAsRead(
                          widget.chatId!, auth.auth.currentUser!.uid);
                    }
                    var chats = snapshot.data!.docs;

                    return SingleChildScrollView(
                      reverse: true,
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                circleImage(
                                  imageProfile: widget.image,
                                  radiusCircle: 40,
                                  typeImage: 'net',
                                  backgroundColor: Get.theme.primaryColor,
                                  iconImagenull: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  iconImageError: const Icon(Icons.error,
                                      size: 50, color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(widget.name),
                              ],
                            ),
                          ),
                          ListView(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            reverse: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: chats
                                .map((documant) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: _buildMessageList(documant),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    );
                  })),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildMessageList(documant) {
    getMessages message = getMessages.fromDocumentSnapshot(documant);
    bool alignment = message.senderId == auth.auth.currentUser!.uid;
    final time = DateTimeUtils.format(message.timestamp.toString(), 'T');
    return Row(
      mainAxisAlignment:
          alignment ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment:
          alignment ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        if (!alignment) ...[
          circleImage(
            imageProfile: widget.image,
            radiusCircle: 20,
            typeImage: 'net',
            backgroundColor: Get.theme.primaryColor,
            iconImagenull: const Icon(
              Icons.person,
              color: Colors.white,
              size: 20,
            ),
            iconImageError:
                const Icon(Icons.error, size: 30, color: Colors.white),
          ),
          const SizedBox(width: 10)
        ],
        Column(
          crossAxisAlignment:
              alignment ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              constraints: BoxConstraints(
                minHeight: 20,
                maxHeight: 250,
                maxWidth: MediaQuery.of(context).size.width * 0.7,
                minWidth: MediaQuery.of(context).size.width * 0.1,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: alignment ? Get.theme.primaryColor : Colors.white,
                borderRadius: alignment
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
              ),
              child: Text(message.message,
                  style: TextStyle(
                      color: alignment ? Colors.white : Colors.black)),
            ),
            const SizedBox(
              height: 2,
            ),
            Row(
              children: [
                alignment && message.read
                    ? Text(
                        'อ่านแล้ว',
                        style: TextStyle(
                            fontSize: 12, color: Colors.black.withOpacity(0.5)),
                      )
                    : const SizedBox(),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  time,
                  style: TextStyle(
                      fontSize: 12, color: Colors.black.withOpacity(0.5)),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Row(
        children: <Widget>[
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.image,
                color: Get.theme.dividerColor,
                size: 35,
              )),
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: EdgeInsets.only(right: _controller.text.isEmpty ? 15 : 0),
              color: Colors.white,
              child: TextField(
                textInputAction: TextInputAction.newline,
                controller: _controller,
                minLines: 1,
                maxLines: 5,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    hintStyle: TextStyle(),
                    hintText: "ข้อความ..."),
              ),
            ),
          ),
          _controller.text.isEmpty
              ? const SizedBox()
              : IconButton(
                  icon: const Icon(
                    Icons.send,
                    size: 30,
                  ),
                  color: Get.theme.dividerColor,
                  onPressed: () {
                    _sendMessage();
                  },
                )
        ],
      ),
    );
  }
}
