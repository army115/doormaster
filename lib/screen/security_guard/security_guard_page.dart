import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/drawer/drawer.dart';
import 'package:doormster/components/girdManu/gird_menu.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/screen/security_guard/check_point_page.dart';
import 'package:doormster/service/check_connected.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Security_Guard extends StatefulWidget {
  const Security_Guard({Key? key});
  static const String route = '/security';

  @override
  State<Security_Guard> createState() => _Security_GuardState();
}

class _Security_GuardState extends State<Security_Guard> {
  bool loading = false;

  var mobileRole;
  Future _getRole() async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mobileRole = await prefs.getInt('role') ?? "";
    print('mobileRole: ${mobileRole}');
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getRole();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Security Guard'),
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            }),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(children: [
            GridView.count(
              // scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              childAspectRatio: 1.0,
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                Gird_Menu(
                  title: 'บันทึกเหตุการณ์',
                  icon: Icons.assignment_outlined,
                  press: () {
                    // checkInternet(context, Check_Point());
                  },
                ),
                Gird_Menu(
                  title: 'ดูบันทึกเหตุการณ์ย้อนหลัง',
                  icon: Icons.event_note,
                  press: () {},
                ),
                Gird_Menu(
                  title: 'ประวัติส่วนตัว',
                  icon: Icons.person,
                  press: () {},
                ),
                Gird_Menu(
                    title: 'บันทึกเหตุการณ์เพิ่มเติม',
                    icon: Icons.assignment_rounded,
                    press: () {}),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
