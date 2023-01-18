// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:doormster/components/drawer/drawer.dart';
import 'package:doormster/screen/home_page.dart';
import 'package:doormster/screen/messages_page.dart';
import 'package:doormster/screen/opendoor_page.dart';
import 'package:doormster/screen/profile_page.dart';
import 'package:doormster/screen/scan_qrcode_page.dart';
import 'package:doormster/screen/visitor_page.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  BottomBar({Key? key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  final _pageOptions = [Home_Page(), Massages_Page(), Profile_Page()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: _pageOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'โฮม',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_rounded),
            label: 'ข้อความ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'ฉัน',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
