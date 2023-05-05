import 'package:doormster/components/button/button.dart';
import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      drawer: MyDrawer(
        selectedIndex: _selectedIndex,
        onItemTapped: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Text(
            'Index 0: Home',
            // style: optionStyle,
          ),
          Text(
            'Index 1: Business',
            // style: optionStyle,
          ),
          Text(
            'Index 2: School',
            // style: optionStyle,
          ),
          Text(
            'Index 2: test',
            // style: optionStyle,
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const MyDrawer(
      {Key? key, required this.selectedIndex, required this.onItemTapped})
      : super(key: key);

  Future<void> itemTab() async {
    onItemTapped(0);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Menu'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('First Item'),
            onTap: () {
              itemTab();
              // onItemTapped(0);
            },
            // selected: selectedIndex == 0,
          ),
          ListTile(
            title: Text('Second Item'),
            onTap: () {
              onItemTapped(1);
            },
            // selected: selectedIndex == 1,
          ),
          ListTile(
            title: Text('Third Item'),
            onTap: () {
              onItemTapped(2);
            },
            // selected: selectedIndex == 2,
          ),
          ListTile(
            title: Text('Fourth Item'),
            onTap: () {
              onItemTapped(3);
            },
            // selected: selectedIndex == 3,
          ),
        ],
      ),
    );
  }
}

class MyBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const MyBottomNavigationBar(
      {Key? key, required this.selectedIndex, required this.onItemTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: Colors.amber,
          ),
          label: 'First',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.business,
            color: Colors.amber,
          ),
          label: 'Second',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.school,
            color: Colors.amber,
          ),
          label: 'Third',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
            color: Colors.amber,
          ),
          label: 'Fourth',
        ),
      ],
    );
  }
}
