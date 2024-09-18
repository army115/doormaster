// ignore_for_file: sort_child_properties_last, prefer_const_constructors, use_build_context_synchronously
import 'package:doormster/components/alertDialog/alert_dialog_twobutton_subtext.dart';
import 'package:doormster/components/bottomSheet/bottom_sheet.dart';
import 'package:doormster/components/bottombar/bottom_controller.dart';
import 'package:doormster/controller/logout_controller.dart';
import 'package:doormster/screen/main_screen/settings_page.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer({Key? key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String image = '';
  String fname = '';
  String lname = '';

  Future<void> getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    image = prefs.getString('image')!;
    fname = prefs.getString('fname')!;
    lname = prefs.getString('lname')!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColorLight,
          body: ListView(
            physics: ClampingScrollPhysics(),
            children: [
              Header(),
              Divider(
                color: Colors.white,
                thickness: 1,
                height: 0,
              ),
              Manu(),
            ],
          ),
          bottomNavigationBar: Footer(),
        ),
      ),
    );
  }

  Widget Header() {
    return Container(
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
        child: ListTile(
          contentPadding: EdgeInsets.only(),
          titleAlignment: ListTileTitleAlignment.titleHeight,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 33,
                  backgroundColor: Colors.white,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      Get.back();
                      bottomController.ontapItem(3);
                    },
                    child: CircleAvatar(
                      radius: 33,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[100],
                        child: image != ''
                            ? Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(imageDomain + image),
                                      onError: (exception, stackTrace) => Icon(
                                          Icons.broken_image_rounded,
                                          size: 140,
                                          color: Colors.grey)),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'assets/images/HIP Smart Community Icon-01.png')),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          subtitle: Text(
            '$fname $lname',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 0.5,
                color: Colors.white),
          ),
          trailing:
              // security == true
              //     ? Container()
              //     :
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
                    bottomSheet();
                  }),
        ));
  }

  Widget Manu() {
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: Column(
        children: [
          ListTile(
            onTap: () {
              Get.back();
              bottomController.ontapItem(3);
            },
            leading: Icon(
              Icons.person,
              size: 25,
              color: Colors.white,
            ),
            title: Text(
              'info'.tr,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: Colors.white),
            ),
            // tileColor: Colors.cyan,
          ),
          ListTile(
            onTap: () {
              Get.back();
              Get.toNamed('/setting');
            },
            leading: Icon(
              Icons.settings,
              size: 30,
              color: Colors.white,
            ),
            title: Text(
              'setting'.tr,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: Colors.white),
            ),
            // tileColor: Colors.cyan,
          ),
        ],
      ),
    );
  }

  Widget Footer() {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Wrap(
        children: [
          Divider(
            color: Colors.white,
            thickness: 1,
            height: 0,
          ),
          ListTile(
            onTap: () {
              dialogTwobutton_Subtitle(
                  title: 'logout'.tr,
                  subtitle: 'want_logout'.tr,
                  icon: Icons.warning_amber_rounded,
                  colorIcon: Colors.orange,
                  textButton1: 'yes'.tr,
                  press1: () {
                    logoutController.logout();
                  },
                  textButton2: 'no'.tr,
                  press2: () {
                    Get.back();
                  },
                  click: true,
                  willpop: true);
            },
            leading: Icon(
              Icons.logout,
              color: Colors.white,
              size: 30,
            ),
            title: Text('logout'.tr,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: Colors.white)),
            // tileColor: Colors.cyan,
          ),
        ],
      ),
    );
  }

  void bottomSheet() {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      context: context,
      builder: (context) {
        return BottomSheetContent();
      },
    );
  }
}
