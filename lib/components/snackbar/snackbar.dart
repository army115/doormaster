import 'package:flutter/material.dart';

void snackbar(
  context,
  color,
  title,
  icon,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      // action: SnackBarAction(
      //   label: 'Action',
      //   onPressed: () {
      //     // Code to execute.
      //   },
      // ),
      content: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
          SizedBox(
            width: 3,
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 17, fontFamily: 'Kanit'),
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 1700),
      // padding: const EdgeInsets.symmetric(
      //   vertical: 10,
      //   horizontal: 10,
      // ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
  );
}
