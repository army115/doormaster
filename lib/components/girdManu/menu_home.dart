import 'package:flutter/material.dart';

class Menu_Home extends StatelessWidget {
  String title;
  final press;
  final icon;
  Menu_Home(
      {Key? key, required this.title, required this.press, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Card(
          elevation: 5,
          color: Theme.of(context).primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            splashColor: Colors.black12,
            highlightColor: Colors.transparent,
            onTap: () => Navigator.pushNamed(context, press),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Icon(
                  IconData(int.parse(icon), fontFamily: 'MaterialIcons'),
                  size: 45,
                  color: Colors.white),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                height: 1.3,
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.normal),
          ),
        ),
      ],
    );
  }
}
