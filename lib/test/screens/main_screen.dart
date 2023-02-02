// import 'package:common_bottom_navigation_bar/components/common_navigation_bar.dart';
import 'package:doormster/components/drawer/drawer.dart';
import 'package:doormster/components/menu/home_menu.dart';
import 'package:doormster/components/menu/message_menu.dart';
import 'package:doormster/components/menu/profile_menu.dart';
import 'package:doormster/screen/test.dart';
// import 'package:common_bottom_navigation_bar/components/bottom_bar_navigator.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>()
  ];
  // ignore: prefer_final_fields
  final _buildBody = [
    Home_Menu(),
    Message_Menu(),
    Profile_Menu(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return
        // WillPopScope(
        //   onWillPop: () async {
        //     final isFirstRouteInCurrentTab =
        //         !await _navigatorKeys[_selectedIndex].currentState!.maybePop();

        //     print(
        //         'isFirstRouteInCurrentTab: ' + isFirstRouteInCurrentTab.toString());

        //     // let system handle back button if we're on the first route
        //     return isFirstRouteInCurrentTab;
        //   },
        //   child:
        Scaffold(
            drawer: MyDrawer(),
            backgroundColor: Colors.white,
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.amber,
              // shape: CircularNotchedRectangle(),
              // notchMargin: 5,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: 'หน้าหลัก',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.message_rounded),
                  label: 'ข้อความ',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.school),
                  label: 'โปรไฟล์',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: (value) {
                // Respond to item press.
                setState(() => _selectedIndex = value);
              },
              // child: Padding(
              //   padding: const EdgeInsets.only(left: 15),
              //   child: AnimatedBottomNav(
              //       currentIndex: _selectedIndex,
              //       onChange: (index) {
              //         setState(() {
              //           _selectedIndex = index;
              //         });
              //       }),
              // ),
            ),
            // bottomNavigationBar: BottomNavigationBar(
            //   currentIndex: _selectedIndex,
            //   // showSelectedLabels: false,
            //   // showUnselectedLabels: false,
            //   items: const [
            //     BottomNavigationBarItem(
            //       icon: Icon(
            //         Icons.home,
            //       ),
            //       label: 'HOME',
            //     ),
            //     BottomNavigationBarItem(
            //       icon: Icon(
            //         Icons.calendar_month,
            //       ),
            //       label: 'CALENDAR',
            //     ),
            //     BottomNavigationBarItem(
            //       icon: Icon(
            //         Icons.person,
            //       ),
            //       label: 'PROFILE',
            //     ),
            //   ],
            //   onTap: (index) {
            //     setState(() {
            //       _selectedIndex = index;
            //     });
            //   },
            // ),
            body: IndexedStack(
              index: _selectedIndex,
              children: _buildBody,
            )
            // Stack(
            //   children: [
            //     _Home(),
            //     _Massage(),
            //     _Profile(),
            //   ],
            // ),
            // ),
            );
  }

  // getPage(int index) {
  //   switch (index) {
  //     case 0:
  //       return Home_Page();
  //     case 1:
  //       return Massages_Page();
  //     case 2:
  //       return Profile_Page();
  //   }
  // }
}

// class AnimatedBottomNav extends StatelessWidget {
//   final currentIndex;
//   final onChange;
//   const AnimatedBottomNav({Key? key, this.currentIndex, this.onChange})
//       : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: kToolbarHeight,
//       // decoration: BoxDecoration(color: Colors.amber),
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             child: InkWell(
//               onTap: () => onChange(0),
//               child: Icon(Icons.home),
//             ),
//           ),
//           Expanded(
//             child: InkWell(
//               onTap: () => onChange(1),
//               child: Icon(
//                 Icons.message,
//               ),
//             ),
//           ),
//           Expanded(
//             child: InkWell(
//                 onTap: () => onChange(2),
//                 child: Icon(
//                   Icons.person,
//                 )),
//           ),
//         ],
//       ),
//     );
//   }
// }
