// ignore_for_file: sort_child_properties_last, prefer_const_constructors, use_build_context_synchronously
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/alertDialog/alert_dialog_twobutton_subtext.dart';
import 'package:doormster/components/bottomSheet/bottom_sheet.dart';
import 'package:doormster/components/bottombar/bottom_controller.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/button/button_outline.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/controller/logout_controller.dart';
import 'package:doormster/controller/multi_company_controller.dart';
import 'package:doormster/models/get_multi_company.dart';
import 'package:doormster/models/login_model.dart';
import 'package:doormster/screen/main_screen/add_company_page.dart';
import 'package:doormster/screen/main_screen/login_page.dart';
import 'package:doormster/screen/main_screen/login_staff_page.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/notify/notify_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class MyDrawer extends StatefulWidget {
  MyDrawer({Key? key});

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

    setState(() {});

    // _getMultiCompany();
  }

  Future<void> _getMultiCompany() async {
    try {
      setState(() {
        loading = true;
      });

      await Future.delayed(Duration(seconds: 3));

      var url = '${Connect_api().domain}/get/multicompanymobile/$uuId';
      var response = await Dio().get(
        url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        multiCompany.assignAll(getMultiCompany.fromJson(response.data).data!);
      }
    } on DioError catch (error) {
      print(error);
      // dialogOnebutton_Subtitle(context, 'พบข้อผิดพลาด', 'ไม่สามารถเชื่อมต่อได้',
      //     Icons.warning_amber_rounded, Colors.orange, 'ตกลง', () {
      //   Navigator.popUntil(context, (route) => route.isFirst);
      // }, false);
    } finally {
      print(loading);
      setState(() {
        loading = false;
      });
    }
  }

  // Future<void> _selectCompany(uId, comId) async {
  //   try {
  //     setState(() {
  //       loading = true;
  //     });
  //     var url = '${Connect_api().domain}/loginmulticompany';
  //     var response = await Dio().post(url,
  //         options: Options(headers: {
  //           'Content-Type': 'application/json',
  //           'Accept': 'application/json',
  //         }),
  //         data: {
  //           "_id": uId,
  //           "company_id": comId,
  //         });
  //     var jsonRes = LoginModel.fromJson(response.data);
  //     print(response.data);
  //     if (jsonRes.status == 200) {
  //       var token = jsonRes.accessToken;
  //       List<User> data = jsonRes.user!; //ตัวแปร List จาก model

  //       //ลบค่า device token ของบริษัทก่อนหน้า
  //       Notify_Token().deletenotifyToken();

  //       // ส่งค่าตัวแปร
  //       await prefs.setString('token', token!);
  //       await prefs.setString('userId', data.single.sId!);
  //       await prefs.setString('companyId', data.single.companyId!);
  //       await prefs.setString('fname', data.single.firstName!);
  //       await prefs.setString('lname', data.single.surName!);
  //       await prefs.setInt('role', data.single.mobile!);
  //       await prefs.setString('uuId', data.single.userUuid!);

  //       if (data.single.image != null) {
  //         await prefs.setString('image', data.single.image!);
  //       }

  //       if (data.single.devicegroupUuid != null) {
  //         await prefs.setString('deviceId', data.single.devicegroupUuid!);
  //       }
  //       if (data.single.weigangroupUuid != null) {
  //         await prefs.setString('weiganId', data.single.weigangroupUuid!);
  //       }

  //       print('userId: ${data.single.sId}');
  //       print('Select Success');

  //       //เพิ่ม device token ของบริษัทนี้
  //       Notify_Token()
  //           .create_notifyToken(data.single.companyId, data.single.sId);

  //       Navigator.of(context).pop();
  //       Navigator.of(context).pop();

  //       bottomController.ontapItem(0);

  //       setState(() {
  //         loading = false;
  //       });

  //       // snackbar( Get.theme.primaryColor, 'เลือกสำเร็จ',
  //       //     Icons.check_circle_outline_rounded);
  //     } else {
  //       dialogOnebutton_Subtitle('select_fail'.tr, '${jsonRes.data}',
  //           Icons.highlight_off_rounded, Colors.red, 'ok'.tr, () {
  //         Navigator.of(context).pop();
  //       }, false, false);
  //       print('Select fail!!');
  //       print(response.data);
  //       setState(() {
  //         loading = false;
  //       });
  //     }
  //   } catch (error) {
  //     print(error);
  //     error_connected(() async {
  //       Navigator.of(context).pop();
  //     });
  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    getValueShared();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Scaffold(
          backgroundColor: Get.theme.primaryColorLight,
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
      color: Get.theme.primaryColor,
      padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
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
                  bottomController.ontapItem(3);
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
                                  image:
                                      MemoryImage(convert.base64Decode(image))),
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
                        bottomSheet();
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
    );
  }

  Widget Manu() {
    return Container(
      color: Get.theme.primaryColorLight,
      child: Column(
        children: [
          ListTile(
            onTap: () {
              Navigator.pop(context);
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
              Get.offAndToNamed('/setting');
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
      color: Get.theme.primaryColor,
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
                  'logout'.tr,
                  'want_logout'.tr,
                  Icons.warning_amber_rounded,
                  Colors.orange,
                  'yes'.tr,
                  () {
                    logoutController.logout();
                  },
                  'no'.tr,
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
      backgroundColor: Get.theme.primaryColor,
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
