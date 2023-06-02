// ignore_for_file: unused_field, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/alertDialog/alert_dialog_twobutton_subtext.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/screen/main_screen/login_page.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Settings_Page extends StatefulWidget {
  const Settings_Page({super.key});

  @override
  State<Settings_Page> createState() => _Settings_PageState();
}

class menuItem {
  IconData icon;
  String title;
  VoidCallback ontap;
  Color color;
  menuItem(this.icon, this.title, this.ontap, this.color);
}

class _Settings_PageState extends State<Settings_Page> {
  late SharedPreferences prefs;
  var uuId;
  bool loading = false;
  PackageInfo? packageInfo;

  Future getValueShared() async {
    final info = await PackageInfo.fromPlatform();
    prefs = await SharedPreferences.getInstance();
    uuId = prefs.getString('uuId');
    print('uuId: ${uuId}');
    setState(() {
      packageInfo = info;
    });
  }

  Future _Logout() async {
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Login_Page()),
        (Route<dynamic> route) => false);
    print('logout success');
  }

  Future _blockUser() async {
    try {
      setState(() {
        loading = true;
      });
      var url = '${Connect_api().domain}/blockUser';
      var response = await Dio().post(url,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          }),
          data: {"uuid": uuId, "Block": 1});
      var _response = response.toString().split(',').first.split(':').last;
      print(_response);
      if (_response == '200') {
        print('block Success');
        print(response.data);

        _Logout();

        snackbar(context, Theme.of(context).primaryColor, 'ปิดการใช้งานสำเร็จ',
            Icons.check_circle_outline_rounded);

        setState(() {
          loading = false;
        });
      } else {
        dialogOnebutton_Subtitle(
            context,
            'ปิดการใช้งานไม่สำเร็จ',
            'กรุณาลองใหม่อีกครั้ง',
            Icons.highlight_off_rounded,
            Colors.red,
            'ตกลง', () {
          Navigator.of(context, rootNavigator: true).pop();
        }, false, false);
        print('checkIn not Success!!');
        print(response.data);
        setState(() {
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      dialogOnebutton_Subtitle(
          context,
          'พบข้อผิดพลาด',
          'ไม่สามารถเชื่อมต่อได้ กรุณาลองใหม่อีกครั้ง',
          Icons.warning_amber_rounded,
          Colors.orange,
          'ตกลง', () {
        Navigator.of(context, rootNavigator: true).pop();
      }, false, false);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    getValueShared();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<menuItem> _menu = [
      // menuItem(Icons.person, 'ข้อมูลบัญชี', () {}, Colors.black),
      menuItem(Icons.lock, 'เปลี่ยนรหัสผ่าน', () {
        Navigator.of(context).popAndPushNamed('/password');
      }, Colors.black),
      menuItem(Icons.no_accounts_rounded, 'ปิดการใช้งานบัญชี', () {
        dialogTwobutton_Subtitle(
            context,
            'ปิดการใช้งานบัญชี',
            'หากคุณต้องการปิดการใช้งานบัญชีนี้ โปรดยืนยันคำสั่ง',
            Icons.warning_amber_rounded,
            Colors.orange,
            'ยกเลิก',
            () {
              Navigator.pop(context);
            },
            'ตกลง',
            () {
              _blockUser();
            },
            true,
            true);
      }, Colors.red),
      menuItem(
          Icons.app_settings_alt_rounded,
          'เวอร์ชันปัจจุบัน ${packageInfo?.version}',
          () {},
          Colors.grey.shade600)
    ];
    return Scaffold(
      appBar: AppBar(title: Text('การตั้งค่า')),
      body: Container(
        child: ListView.separated(
          itemCount: _menu.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: _menu[index].ontap,
              leading: Icon(
                _menu[index].icon,
                size: 30,
                color: Colors.grey.shade700,
              ),
              title: Text(
                _menu[index].title,
                style: TextStyle(letterSpacing: 0.5, color: _menu[index].color),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              color: Colors.black,
              // height: 10,
            );
          },
        ),
      ),
    );
  }
}
