import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/button/button_ontline.dart';
import 'package:flutter/material.dart';

void bottomsheet(context) {
  showModalBottomSheet<void>(
    isScrollControlled: true,
    backgroundColor: Theme.of(context).primaryColor,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10))),
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        height: 300,
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          bottomNavigationBar:
              Buttons_Outline(title: 'เพิ่มโครงการใหม่', press: () {}),
          body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              'สลับโครงการ',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) => InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(
                          Icons.home_work_sharp,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text('HIP Global',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                        Icon(
                          Icons.check_circle_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {},
                ),
              ),
            )
          ]),
        ),
      );
    },
  );
}
