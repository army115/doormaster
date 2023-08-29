// ignore_for_file: sort_child_properties_last, prefer_const_constructors
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/alertDialog/alert_dialog_twobutton_subtext.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/button/button_outline.dart';
import 'package:doormster/models/get_multi_company.dart';
import 'package:doormster/models/login_model.dart';
import 'package:doormster/screen/main_screen/add_company_page.dart';
import 'package:doormster/screen/main_screen/login_page.dart';
import 'package:doormster/screen/main_screen/login_staff_page.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:doormster/service/notify_token.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class MyDrawer extends StatefulWidget {
  final ontapItem;
  MyDrawer({Key? key, this.ontapItem});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  var uuId;
  var companyId;
  var security;
  var image;
  var fname;
  var lname;

  bool loading = false;
  List<Data> multiCompany = [];
  late SharedPreferences prefs;

  Future<void> _Logout() async {
    //ลบ token device notify
    await Notify_Token().deletenotifyToken();
    Set<String> allKeys = prefs.getKeys();

    if (security == true) {
      for (String key in allKeys) {
        if (key != 'notifyToken') {
          prefs.remove(key);
        }
      }
      log(allKeys.toString());
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Login_Staff()),
          (Route<dynamic> route) => false);
    } else {
      prefs.remove('token');
      prefs.remove('role');
      prefs.remove('deviceId');
      prefs.remove('weiganId');
      prefs.remove('security');
      prefs.remove('image');
      prefs.remove('fname');
      prefs.remove('lname');
      log(allKeys.toString());
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Login_Page()),
          (Route<dynamic> route) => false);
    }
    print('logout success');
  }

  Future<void> getValueShared() async {
    prefs = await SharedPreferences.getInstance();
    uuId = prefs.getString('uuId');
    companyId = prefs.getString('companyId');
    security = prefs.getBool('security');
    image = prefs.getString('image');
    fname = prefs.getString('fname');
    lname = prefs.getString('lname');

    print('uuId: ${uuId}');
    print('companyId: ${companyId}');
    print('security: ${security}');

    _getMultiCompany();
  }

  Future<void> _getMultiCompany() async {
    try {
      setState(() {
        loading = true;
      });
      var url = '${Connect_api().domain}/get/multicompanymobile/$uuId';
      var response = await Dio().get(
        url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        getMultiCompany company = getMultiCompany.fromJson(response.data);
        setState(() {
          multiCompany = company.data!;
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      // dialogOnebutton_Subtitle(context, 'พบข้อผิดพลาด', 'ไม่สามารถเชื่อมต่อได้',
      //     Icons.warning_amber_rounded, Colors.orange, 'ตกลง', () {
      //   Navigator.popUntil(context, (route) => route.isFirst);
      // }, false);
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _selectCompany(uId, comId) async {
    try {
      setState(() {
        loading = true;
      });
      var url = '${Connect_api().domain}/loginmulticompany';
      var response = await Dio().post(url,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          }),
          data: {
            "_id": uId,
            "company_id": comId,
          });
      var jsonRes = LoginModel.fromJson(response.data);
      print(response.data);
      if (jsonRes.status == 200) {
        var token = jsonRes.accessToken;
        List<User> data = jsonRes.user!; //ตัวแปร List จาก model

        //ลบค่า device token ของบริษัทก่อนหน้า
        Notify_Token().deletenotifyToken();

        // ส่งค่าตัวแปร
        await prefs.setString('token', token!);
        await prefs.setString('userId', data.single.sId!);
        await prefs.setString('companyId', data.single.companyId!);
        await prefs.setString('fname', data.single.firstName!);
        await prefs.setString('lname', data.single.surName!);
        await prefs.setInt('role', data.single.mobile!);
        await prefs.setString('uuId', data.single.userUuid!);

        if (data.single.image != null) {
          await prefs.setString('image', data.single.image!);
        }

        if (data.single.devicegroupUuid != null) {
          await prefs.setString('deviceId', data.single.devicegroupUuid!);
        }
        if (data.single.weigangroupUuid != null) {
          await prefs.setString('weiganId', data.single.weigangroupUuid!);
        }

        print('userId: ${data.single.sId}');
        print('Select Success');

        //เพิ่ม device token ของบริษัทนี้
        Notify_Token()
            .create_notifyToken(data.single.companyId, data.single.sId);

        Navigator.of(context).pop();
        Navigator.of(context).pop();

        homeKey.currentState?.popAndPushNamed('/');
        widget.ontapItem(0);

        setState(() {
          loading = false;
        });

        // snackbar(context, Theme.of(context).primaryColor, 'เลือกสำเร็จ',
        //     Icons.check_circle_outline_rounded);
      } else {
        dialogOnebutton_Subtitle(context, 'เลือกไม่สำเร็จ', '${jsonRes.data}',
            Icons.highlight_off_rounded, Colors.red, 'ตกลง', () {
          Navigator.of(context).pop();
        }, false, false);
        print('Select fail!!');
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
        Navigator.of(context).pop();
      }, false, false);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getValueShared();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
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
                                Navigator.pop(context);
                                widget.ontapItem(3);
                                profileKey.currentState?.popAndPushNamed('/');
                              },
                              child: CircleAvatar(
                                radius: 33,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.grey[100],
                                  child: image != null
                                      ? Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: MemoryImage(convert
                                                    .base64Decode(image!))),
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                    'assets/images/HIP Smart Community Icon-03.png')),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            security == true
                                ? Container()
                                : IconButton(
                                    constraints: BoxConstraints(),
                                    splashRadius: 20,
                                    padding: EdgeInsets.zero,
                                    iconSize: 30,
                                    color: Colors.white,
                                    icon: const Icon(
                                      Icons.more_vert_rounded,
                                    ),
                                    onPressed: () {
                                      bottomsheet();
                                    }),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${fname} ${lname}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            widget.ontapItem(3);
                            profileKey.currentState?.popAndPushNamed('/');
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
                                letterSpacing: 0.5,
                                color: Colors.white),
                          ),
                          // tileColor: Colors.cyan,
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.of(context).popAndPushNamed('/setting');
                          },
                          leading: Icon(
                            Icons.settings,
                            size: 30,
                            color: Colors.white,
                          ),
                          title: Text(
                            'การตั้งค่า',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
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
                    true,
                    true);
              },
              leading: Icon(
                Icons.logout,
                color: Colors.white,
                size: 30,
              ),
              title: Text('ออกจากระบบ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: Colors.white)),
              // tileColor: Colors.cyan,
            )
          ],
        ),
      ),
    );
  }

  void bottomsheet() {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      context: context,
      builder: (context) {
        return DraggableScrollableSheet(
            expand: false,
            initialChildSize: multiCompany.isEmpty ? 0.25 : 0.5,
            minChildSize: multiCompany.isEmpty ? 0.25 : 0.5,
            maxChildSize: 0.7,
            builder: (context, scrollController) => Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    toolbarHeight: 45,
                    automaticallyImplyLeading: false,
                    centerTitle: false,
                    title: Container(
                      width: double.infinity,
                      child: SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          primary: false,
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                    height: 4,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                              Text('สลับโครงการ')
                            ],
                          )),
                    ),
                    elevation: 0,
                  ),
                  backgroundColor: Colors.transparent,
                  body: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: multiCompany.isEmpty
                        ? Center(
                            child: Text('โปรดตรวจสอบการเชื่อมต่อ',
                                style: TextStyle(color: Colors.white)),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            shrinkWrap: true,
                            itemCount: multiCompany.length,
                            itemBuilder: (context, index) => InkWell(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        Icons.home_work_sharp,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                            '${multiCompany[index].companyName}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white)),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      companyId == multiCompany[index].companyId
                                          ? Icon(
                                              Icons.check_circle_rounded,
                                              size: 20,
                                              color: Colors.white,
                                            )
                                          : Container()
                                    ],
                                  ),
                                ),
                                onTap:
                                    companyId == multiCompany[index].companyId
                                        ? () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          }
                                        : () {
                                            _selectCompany(
                                              multiCompany[index].sId,
                                              multiCompany[index].companyId,
                                            );
                                          }),
                          ),
                  ),
                  bottomNavigationBar: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Buttons_Outline(
                        title: 'เพิ่มโครงการใหม่',
                        press: () {
                          Navigator.pop(context);
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => Add_Company(),
                          ));
                        }),
                  ),
                ));
      },
    );
  }
}
