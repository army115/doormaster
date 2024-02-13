import 'package:flutter/material.dart';
import 'package:get/get.dart';

// void snackbar(
//   context,
//   color,
//   title,
//   icon,
// ) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       dismissDirection: DismissDirection.none,
//       backgroundColor: color,
//       // action: SnackBarAction(
//       //   label: 'Action',
//       //   onPressed: () {
//       //     // Code to execute.
//       //   },
//       // ),
//       content: Row(
//         children: [
//           Icon(
//             icon,
//             color: Colors.white,
//             size: 30,
//           ),
//           SizedBox(
//             width: 3,
//           ),
//           Expanded(
//             child: Text(
//               title,
//               style: TextStyle(fontSize: 16, fontFamily: 'Kanit'),
//             ),
//           ),
//         ],
//       ),
//       duration: const Duration(milliseconds: 1700),
//       // padding: const EdgeInsets.symmetric(
//       //   vertical: 10,
//       //   horizontal: 10,
//       // ),
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(5),
//       ),
//     ),
//   );
// }

void snackbar(
  color,
  title,
  icon,
) {
  Get.showSnackbar(GetSnackBar(
    icon: Icon(
      icon,
      color: Colors.white,
      size: 30,
    ),
    messageText: Text(
      title,
      style: TextStyle(fontSize: 16, color: Colors.white),
    ),
    backgroundColor: color,
    borderRadius: 5,
    dismissDirection: DismissDirection.none,
    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    shouldIconPulse: false,
    duration: const Duration(milliseconds: 1700),
    animationDuration: Duration(milliseconds: 700),
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    reverseAnimationCurve: Curves.fastOutSlowIn,
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        spreadRadius: 3,
        blurRadius: 5,
        offset: Offset(0, 2),
      ),
    ],
  ));
}
