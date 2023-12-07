// ignore_for_file: prefer_const_declarations, unused_local_variable, prefer_const_constructors, unused_import

import 'dart:convert';
import 'dart:ffi';
// import 'dart:html';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/main.dart';
import 'package:doormster/models/get_checklist.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart' as http;
import 'package:doormster/components/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Notification_Page extends StatefulWidget {
  final title;
  final body;
  const Notification_Page({Key? key, this.title, this.body});

  @override
  State<Notification_Page> createState() => _Notification_PageState();
}

class _Notification_PageState extends State<Notification_Page>
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
        title: Text('notification'.tr),
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            }),
      ),
      body: Center(
        child: widget.body == null
            ? Logo_Opacity(title: 'no_notification'.tr)
            : Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        side:
                            BorderSide(width: 2, color: Get.theme.primaryColor),
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 10,
                    margin: EdgeInsets.all(13),
                    child: ListTile(
                      title: Text('${widget.title}'),
                      subtitle: Text("${widget.body}"),
                    ),
                  ),

                  // ElevatedButton(
                  //   onPressed: () {
                  //     // NotificationService().showNotification(context);
                  //   },
                  //   child: Text('Show Notification'),
                  // ),
                ],
              ),
      ),
    );
  }
}
