// ignore_for_file: prefer_const_declarations

import 'dart:convert';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:http/http.dart' as http;
import 'package:doormster/components/drawer/drawer.dart';
import 'package:flutter/material.dart';

class Messages_Page extends StatefulWidget {
  const Messages_Page({Key? key});

  @override
  State<Messages_Page> createState() => _Messages_PageState();
}

class _Messages_PageState extends State<Messages_Page> {
  Future<String> sendMessageToOpenAI(String message) async {
    final apiKey = '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';
    final openaiEndpoint =
        'https://api.openai.com/v1/engines/davinci-codex/completions';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };
    final data = {
      'prompt': message,
      'max_tokens': 150,
      'temperature': 0.7,
    };
    final response = await http.post(Uri.parse(openaiEndpoint),
        headers: headers, body: json.encode(data));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final chatBotResponse = data.toString();
      print('show $chatBotResponse');
      return chatBotResponse;
    } else {
      throw Exception('Failed to send message to OpenAI');
    }
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
        body: Logo_Opacity(title: 'ไม่มีข้อมูล')
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
