// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, overridden_fields, must_call_super

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 3, vsync: this, animationDuration: Duration(seconds: 0));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _ontapItem(int value) {
    setState(() {
      _tabController.animateTo(value);
      // _selectedIndex = value;
    });
  }

  final buildBody = [
    const PageOne(),
    const PageTwo(),
    const PageThree(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: buildBody,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabController.index,
        onTap: _ontapItem,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Page One',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Page Two',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Page Three',
          ),
        ],
      ),
    );
  }
}

class PageOne extends StatefulWidget {
  const PageOne({Key? key}) : super(key: key);

  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> with AutomaticKeepAliveClientMixin {
  bool load = false;

  @override
  bool get wantKeepAlive => true;

  Future _getInfo() async {
    setState(() {
      load = true;
    });
    await Future.delayed(Duration(milliseconds: 300));
    print('1111');
    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    _getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);

    Future _getLogs() async {
      try {
        //call api
        var url = 'https://192.168.9.124:7082/api/User/admin/admin';
        var response = await Dio().get(
          url,
          options: Options(headers: {'accept': 'text/plain'}),
        );
        log('uri : ${url}');
        log("print : ${response.data}");
      } catch (error) {
        log("$error");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('111111'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: load
            ? Loading()
            : Buttons(
                title: 'test',
                press: () {
                  _getLogs();
                }),
      ),
    );
  }
}

class PageTwo extends StatefulWidget {
  const PageTwo({Key? key}) : super(key: key);

  @override
  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> with AutomaticKeepAliveClientMixin {
  bool load = false;

  @override
  bool get wantKeepAlive => true;

  Future _getInfo() async {
    setState(() {
      load = true;
    });
    await Future.delayed(Duration(milliseconds: 300));
    print('22222');
    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    _getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('2222'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: load ? Loading() : TextField(),
      ),
    );
  }
}

class PageThree extends StatefulWidget {
  const PageThree({Key? key}) : super(key: key);

  @override
  _PageThreeState createState() => _PageThreeState();
}

class _PageThreeState extends State<PageThree>
    with AutomaticKeepAliveClientMixin {
  bool load = false;

  @override
  bool get wantKeepAlive => true;

  Future _getInfo() async {
    setState(() {
      load = true;
    });
    await Future.delayed(Duration(milliseconds: 300));
    print('3333');
    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    _getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('33333'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: load ? Loading() : TextField(),
      ),
    );
  }
}
