// ignore_for_file: prefer_const_declarations, unused_local_variable, prefer_const_constructors, unused_import

import 'dart:convert';
import 'dart:ffi';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/main.dart';
import 'package:doormster/service/notify/notify_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:doormster/components/drawer/drawer.dart';
import 'package:flutter/material.dart';

class Test_Page extends StatefulWidget {
  const Test_Page({Key? key});

  @override
  State<Test_Page> createState() => _Test_PageState();
}

class _Test_PageState extends State<Test_Page>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _textController = TextEditingController();
  final List<String> _messages = [];

  void _handleSubmitted(String text) {
    if (_textController.text.isEmpty) return;
    _textController.clear();
    setState(() {
      _messages.insert(0, text);
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('การแจ้งเตือน'),
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            }),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // NotificationService().showNotification(context);
          },
          child: Text('Show Notification'),
        ),
      ),
      // Logo_Opacity(title: 'ไม่มีการแจ้งเตือน')
      // Column(
      //   children: [
      //     Expanded(
      //       child: Container(
      //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      //         child: ListView.builder(
      //           shrinkWrap: true,
      //           reverse: true,
      //           itemCount: _messages.length,
      //           itemBuilder: (context, index) {
      //             return Column(
      //               mainAxisAlignment: MainAxisAlignment.end,
      //               crossAxisAlignment:
      //                   // current
      //                   //     ?
      //                   CrossAxisAlignment.end,
      //               // : CrossAxisAlignment.start,
      //               children: [
      //                 Container(
      //                   margin: EdgeInsets.symmetric(vertical: 5),
      //                   // constraints: BoxConstraints(
      //                   //   minHeight: 40,
      //                   //   maxHeight: 250,
      //                   //   maxWidth: Get.mediaQuery.size.width * 0.7,
      //                   //   minWidth: Get.mediaQuery.size.width * 0.1,
      //                   // ),
      //                   decoration: BoxDecoration(
      //                       color:
      //                           // current
      //                           // ?
      //                           Get.theme.primaryColor,
      //                       //     :
      //                       // Get.theme.primaryColorLight,
      //                       borderRadius:
      //                           // current
      //                           //     ?
      //                           BorderRadius.only(
      //                         topLeft: Radius.circular(12),
      //                         bottomLeft: Radius.circular(12),
      //                         topRight: Radius.circular(12),
      //                       )
      //                       //     :
      //                       //   BorderRadius.only(
      //                       // topLeft: Radius.circular(20),
      //                       // bottomRight: Radius.circular(20),
      //                       // topRight: Radius.circular(20),
      //                       // ),
      //                       ),
      //                   child: Container(
      //                     padding: const EdgeInsets.symmetric(
      //                         vertical: 5, horizontal: 10),
      //                     child: Text('${_messages[index]}',
      //                         style: TextStyle(color: Colors.white)),
      //                   ),
      //                 ),
      //               ],
      //             );
      //           },
      //         ),
      //       ),
      //     ),
      //     Container(
      //       padding: EdgeInsets.symmetric(vertical: 10),
      //       decoration: const BoxDecoration(
      //         color: Colors.white,
      //       ),
      //       child: Row(
      //         children: [
      //           IconButton(
      //             highlightColor: Colors.transparent,
      //             splashColor: Colors.transparent,
      //             icon:
      //                 Icon(Icons.image, color: Get.theme.primaryColor),
      //             iconSize: 30,
      //             onPressed: () {},
      //           ),
      //           Expanded(
      //             child: TextFormField(
      //               minLines: 1,
      //               maxLines: 5,
      //               controller: _textController,
      //               decoration: InputDecoration(
      //                 contentPadding:
      //                     EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      //                 hintText: 'Enter message',
      //                 border: OutlineInputBorder(
      //                   borderRadius: BorderRadius.circular(20),
      //                 ),
      //               ),
      //             ),
      //           ),
      //           IconButton(
      //             highlightColor: Colors.transparent,
      //             splashColor: Colors.transparent,
      //             icon: Icon(Icons.send, color: Get.theme.primaryColor),
      //             iconSize: 30,
      //             onPressed: () {
      //               _handleSubmitted(_textController.text);
      //               // sendMessageToOpenAI(_textController.text);
      //             },
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}


//chat
// Column(
      //   children: [
      //     Expanded(
      //       child: Container(
      //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      //         child: ListView.builder(
      //           shrinkWrap: true,
      //           reverse: true,
      //           itemCount: _messages.length,
      //           itemBuilder: (context, index) {
      //             return Column(
      //               mainAxisAlignment: MainAxisAlignment.end,
      //               crossAxisAlignment:
      //                   // current
      //                   //     ?
      //                   CrossAxisAlignment.end,
      //               // : CrossAxisAlignment.start,
      //               children: [
      //                 Container(
      //                   margin: EdgeInsets.symmetric(vertical: 5),
      //                   // constraints: BoxConstraints(
      //                   //   minHeight: 40,
      //                   //   maxHeight: 250,
      //                   //   maxWidth: Get.mediaQuery.size.width * 0.7,
      //                   //   minWidth: Get.mediaQuery.size.width * 0.1,
      //                   // ),
      //                   decoration: BoxDecoration(
      //                       color:
      //                           // current
      //                           // ?
      //                           Get.theme.primaryColor,
      //                       //     :
      //                       // Get.theme.primaryColorLight,
      //                       borderRadius:
      //                           // current
      //                           //     ?
      //                           BorderRadius.only(
      //                         topLeft: Radius.circular(12),
      //                         bottomLeft: Radius.circular(12),
      //                         topRight: Radius.circular(12),
      //                       )
      //                       //     :
      //                       //   BorderRadius.only(
      //                       // topLeft: Radius.circular(20),
      //                       // bottomRight: Radius.circular(20),
      //                       // topRight: Radius.circular(20),
      //                       // ),
      //                       ),
      //                   child: Container(
      //                     padding: const EdgeInsets.symmetric(
      //                         vertical: 5, horizontal: 10),
      //                     child: Text('${_messages[index]}',
      //                         style: TextStyle(color: Colors.white)),
      //                   ),
      //                 ),
      //               ],
      //             );
      //           },
      //         ),
      //       ),
      //     ),
      //     Container(
      //       padding: EdgeInsets.symmetric(vertical: 10),
      //       decoration: const BoxDecoration(
      //         color: Colors.white,
      //       ),
      //       child: Row(
      //         children: [
      //           IconButton(
      //             highlightColor: Colors.transparent,
      //             splashColor: Colors.transparent,
      //             icon:
      //                 Icon(Icons.image, color: Get.theme.primaryColor),
      //             iconSize: 30,
      //             onPressed: () {},
      //           ),
      //           Expanded(
      //             child: TextFormField(
      //               minLines: 1,
      //               maxLines: 5,
      //               controller: _textController,
      //               decoration: InputDecoration(
      //                 contentPadding:
      //                     EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      //                 hintText: 'Enter message',
      //                 border: OutlineInputBorder(
      //                   borderRadius: BorderRadius.circular(20),
      //                 ),
      //               ),
      //             ),
      //           ),
      //           IconButton(
      //             highlightColor: Colors.transparent,
      //             splashColor: Colors.transparent,
      //             icon: Icon(Icons.send, color: Get.theme.primaryColor),
      //             iconSize: 30,
      //             onPressed: () {
      //               _handleSubmitted(_textController.text);
      //               // sendMessageToOpenAI(_textController.text);
      //             },
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),










      