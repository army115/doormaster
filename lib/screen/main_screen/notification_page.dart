// ignore_for_file: prefer_const_declarations, unused_local_variable, prefer_const_constructors

import 'dart:convert';
import 'dart:ffi';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:doormster/components/drawer/drawer.dart';
import 'package:flutter/material.dart';

class Notification_Page extends StatefulWidget {
  const Notification_Page({Key? key});

  @override
  State<Notification_Page> createState() => _Notification_PageState();
}

class _Notification_PageState extends State<Notification_Page> {
  Future<void> _showNotification() async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'test_01',
      'แจ้งเตือนปกติ',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: DefaultStyleInformation(true, true),
    );

    DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        badgeNumber: 1, subtitle: 'test notification ios');

    NotificationDetails generalNotificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'ทดสอบ',
      'การแจ้งเตือน',
      generalNotificationDetails,
      payload: 'Test Payload',
    );
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Massages'),
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            }),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showNotification();
          },
          child: Text('Show Notification'),
        ),
      ),
      // Logo_Opacity(title: 'ไม่มีแจ้งเตือน')
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
      //                   //   maxWidth: MediaQuery.of(context).size.width * 0.7,
      //                   //   minWidth: MediaQuery.of(context).size.width * 0.1,
      //                   // ),
      //                   decoration: BoxDecoration(
      //                       color:
      //                           // current
      //                           // ?
      //                           Theme.of(context).primaryColor,
      //                       //     :
      //                       // Theme.of(context).primaryColorLight,
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
      //                 Icon(Icons.image, color: Theme.of(context).primaryColor),
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
      //             icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
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