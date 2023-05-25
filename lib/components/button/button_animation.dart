// ignore_for_file: must_be_immutable

import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:flutter/material.dart';

class Button_Animation extends StatelessWidget {
  String title;
  VoidCallback press;
  Button_Animation({Key? key, required this.title, required this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasyButton(
        type: EasyButtonType.elevated,
        idleStateWidget: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.normal,
            letterSpacing: 1,
          ),
        ),
        loadingStateWidget: const CircularProgressIndicator(
          color: Colors.white,
        ),
        elevation: 10,
        useWidthAnimation: true,
        useEqualLoadingStateWidgetDimension: true,
        width: MediaQuery.of(context).size.width * 0.5,
        height: 45,
        borderRadius: 10.0,
        contentGap: 5.0,
        buttonColor: Theme.of(context).primaryColor,
        onPressed: press);
  }
}
