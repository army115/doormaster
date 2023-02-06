import 'package:doormster/components/alertDialog/alert_dialog_twobutton_subtext.dart';
import 'package:doormster/components/bottomSheet/bottom_sheet.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/screen/login_page.dart';
import 'package:doormster/screen/profile_page.dart';
import 'package:doormster/screen/reset_password_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  final scaffoldKey;
  MyDrawer({Key? key, this.scaffoldKey});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  Future _Logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Login_Page()),
        (Route<dynamic> route) => false);
    print('logout success');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.only(
        //         bottomRight: Radius.circular(150),
        //         topRight: Radius.circular(150))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: () {
                                // widget.scaffoldKey.currentState.setState(() {
                                //   // Update the bottom navigation bar's index to 2.
                                // });
                                // Navigator.of(
                                //   context,
                                // ).pop();
                                // Navigator.of(
                                //   context,
                                // ).push(MaterialPageRoute(
                                //   builder: (context) => BottomBar(
                                //       // page: 2,
                                //       ),
                                //   maintainState: true,
                                // ));
                              },
                              child: CircleAvatar(
                                radius: 33,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.grey[100],
                                    backgroundImage: const AssetImage(
                                        'assets/images/HIP Smart Community Icon-03.png')),
                              ),
                            ),
                            IconButton(
                                constraints: BoxConstraints(),
                                splashRadius: 20,
                                padding: EdgeInsets.zero,
                                iconSize: 30,
                                color: Colors.white,
                                icon: const Icon(
                                  Icons.more_vert_rounded,
                                ),
                                onPressed: () {
                                  bottomsheet(context);
                                }),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'HIP Smart Community',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              letterSpacing: 0.5,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                    thickness: 1,
                    height: 0,
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          onTap: () {
                            // Navigator.of(
                            //   context,
                            // ).pushReplacement(MaterialPageRoute(
                            //     builder: (context) => BottomBar(
                            //           page: 2,
                            //         )));
                          },
                          leading: Icon(
                            Icons.person,
                            size: 25,
                            color: Colors.white,
                          ),
                          title: Text(
                            'ข้อมูลส่วนตัว',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 0.5,
                                color: Colors.white),
                          ),
                          // tileColor: Colors.cyan,
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.of(context).popAndPushNamed('/password');
                          },
                          leading: Icon(
                            Icons.key_sharp,
                            size: 30,
                            color: Colors.white,
                          ),
                          title: Text(
                            'เปลี่ยนรหัสผ่าน',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 0.5,
                                color: Colors.white),
                          ),
                          // tileColor: Colors.cyan,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.white,
              thickness: 1,
              height: 0,
            ),
            ListTile(
              onTap: () {
                dialogTwobutton_Subtitle(
                  context,
                  'ออกจากระบบ',
                  'คุณต้องการออกจากระบบ\nใช่ หรือ ไม่',
                  Icons.warning_amber_rounded,
                  Colors.orange,
                  'ใช่',
                  () {
                    _Logout();
                  },
                  'ไม่ใช่',
                  () {
                    Navigator.pop(context);
                  },
                );
              },
              leading: Icon(
                Icons.logout,
                color: Colors.white,
                size: 30,
              ),
              title: Text('ออกจากระบบ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.5,
                      color: Colors.white)),
              // tileColor: Colors.cyan,
            )
          ],
        ),
      ),
    );
  }
}
