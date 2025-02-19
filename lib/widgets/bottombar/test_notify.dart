// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// final FlutterLocalNotificationsPlugin _notificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   const AndroidInitializationSettings androidSettings =
//       AndroidInitializationSettings('app_icon');
//   const InitializationSettings settings =
//       InitializationSettings(android: androidSettings);

//   await _notificationsPlugin.initialize(
//     settings,
//     onDidReceiveNotificationResponse: onNotificationTap,
//   );

//   runApp(const MyApp());
// }

// void onNotificationTap(NotificationResponse response) {
//   debugPrint("Tapped notification payload: ${response.payload}");
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Notification with Badge',
//       home: const BottomNavBar(),
//     );
//   }
// }

// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({super.key});

//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {
//   int _selectedIndex = 0;
//   int notificationCount = 0; // จำนวนแจ้งเตือน
//   final List<String> _notifications = []; // รายการแจ้งเตือนที่เข้ามา

//   final List<Widget> _pages = [];

//   @override
//   void initState() {
//     super.initState();
//     _pages.addAll([
//       const HomeScreen(),
//       NotificationScreen(notifications: _notifications),
//     ]);
//   }

//   // ฟังก์ชันแสดงแจ้งเตือน
//   void _showNotification() async {
//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//       'channel_id',
//       'General Notifications',
//       channelDescription: 'Notification Channel for General Use',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const NotificationDetails details =
//         NotificationDetails(android: androidDetails);

//     final String message = 'คุณมีการแจ้งเตือนใหม่';

//     // แสดงการแจ้งเตือน
//     await _notificationsPlugin.show(
//       DateTime.now().millisecondsSinceEpoch % 10000, // สร้าง id แบบสุ่ม
//       'แจ้งเตือนใหม่',
//       message,
//       details,
//     );

//     setState(() {
//       _notifications.add(message);
//       notificationCount++;
//     });
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;

//       // รีเซ็ตจำนวนแจ้งเตือนเมื่อเปิดหน้า Notifications
//       if (index == 1) {
//         notificationCount = 0;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notification with Badge'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications),
//             onPressed: _showNotification, // กดปุ่มนี้เพื่อสร้างแจ้งเตือน
//           ),
//         ],
//       ),
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Badge(
//               // label: Text('10'),
//               largeSize: 20,
//               child: Icon(Icons.notifications_none_rounded),
//             ),
//             label: 'Notifications',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text(
//         'Welcome to Home Page!',
//         style: TextStyle(fontSize: 24),
//       ),
//     );
//   }
// }

// class NotificationScreen extends StatelessWidget {
//   final List<String> notifications;

//   const NotificationScreen({super.key, required this.notifications});

//   @override
//   Widget build(BuildContext context) {
//     return notifications.isEmpty
//         ? const Center(
//             child: Text(
//               'No new notifications',
//               style: TextStyle(fontSize: 20),
//             ),
//           )
//         : ListView.builder(
//             itemCount: notifications.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 leading: const Icon(Icons.notifications),
//                 title: Text(notifications[index]),
//                 subtitle: Text('เวลา: ${DateTime.now()}'),
//               );
//             },
//           );
//   }
// }
