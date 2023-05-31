import 'package:flutter/material.dart';

Widget textIcon(text, icon) {
  return Row(
    children: [
      icon,
      SizedBox(width: 5),
      Text(text),
    ],
  );
  //     Text.rich(
  //   TextSpan(
  //     children: [
  //       WidgetSpan(
  //           child: Padding(
  //         padding: const EdgeInsets.only(right: 5),
  //         child: icon,
  //       )),
  //       TextSpan(text: text),
  //     ],
  //   ),
  // );
}
