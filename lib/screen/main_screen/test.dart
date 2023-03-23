import 'package:dio/dio.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/list_logo_opacity/logo_opacity.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/models/get_logs.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> originalItems = [
    'Apple',
    'Banana',
    'Cherry',
    'Durian',
    'Elderberry',
    'Fig',
    'Grapefruit',
    'Honeydew',
    'Imbe',
    'Jackfruit',
    'Kiwi',
    'Lemon',
    'Mango',
    'Nectarine',
    'Orange',
    'Papaya',
    'Quince',
    'Raspberry',
    'Strawberry',
    'Tangerine',
    'Ugli fruit',
    'Vanilla bean',
    'Watermelon',
    'Xigua (Chinese watermelon)',
    'Yellow passionfruit',
    'Zucchini'
  ];

  List<String> items = [];

  @override
  void initState() {
    super.initState();
    items = originalItems;
  }

  void _searchItems(String text) {
    setState(() {
      items = originalItems
          .where((item) => item.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Bar Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Search Bar Demo'),
        ),
        body: Column(
          children: [
            TextField(
              onChanged: (value) {
                _searchItems(value);
              },
              decoration: InputDecoration(
                hintText: 'ค้นหารายการ...',
                contentPadding: EdgeInsets.all(16.0),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(items[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
