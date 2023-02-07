import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/alertDialog/alert_dialog_twobutton_subtext.dart';
import 'package:doormster/components/button/button_ontline.dart';
import 'package:doormster/models/get_multi_company.dart';
import 'package:doormster/models/login_model.dart';
import 'package:doormster/screen/main_screen/add_company_page.dart';
import 'package:doormster/screen/main_screen/login_page.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MyDrawer extends StatefulWidget {
  final pressProfile;
  MyDrawer({Key? key, this.pressProfile});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  var uuId;
  var companyId;
  bool loading = false;
  List<Data> multiCompany = [];

  Future _Logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Login_Page()),
        (Route<dynamic> route) => false);
    print('logout success');
  }

  Future _getMultiCompany() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uuId = prefs.getString('uuId');
    companyId = prefs.getString('companyId');
    print(uuId);
    try {
      setState(() {
        loading = true;
      });
      var url = '${Connect_api().domain}/get/multicompanymobile/$uuId';
      var response = await http.get(Uri.parse(url), headers: {
        'Connect-type': 'application/json',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        getMultiCompany company =
            getMultiCompany.fromJson(convert.jsonDecode(response.body));
        setState(() {
          multiCompany = company.data!;
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      dialogOnebutton_Subtitle(
        context,
        'พบข้อผิดพลาด',
        'ไม่สามารถเชื่อมต่อได้',
        Icons.warning_amber_rounded,
        Colors.orange,
        'ตกลง',
        () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      );
      setState(() {
        loading = false;
      });
    }
  }

  Future _selectCompany(context, uId, comId) async {
    try {
      setState(() {
        loading = true;
      });
      var url = '${Connect_api().domain}/loginmulticompany';
      var response = await http.post(Uri.parse(url), body: {
        "_id": uId,
        "company_id": comId,
      });
      var jsonRes = LoginModel.fromJson(convert.jsonDecode(response.body));
      if (jsonRes.status == 200) {
        var token = jsonRes.accessToken;
        List<User> data = jsonRes.user!; //ตัวแปร List จาก model

        print('userId: ${data.single.sId}');
        print('token: ${token}');
        print('login success');

        // ส่งค่าตัวแปร
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token!);
        await prefs.setString('userId', data.single.sId!);
        await prefs.setString('companyId', data.single.companyId!);
        await prefs.setInt('role', data.single.mobile!);
        await prefs.setString('uuId', data.single.userUuid!);

        if (data.single.devicegroupUuid != null) {
          await prefs.setString('deviceId', data.single.devicegroupUuid!);
        }
        print('Select Success');
        print(response.body);
        Navigator.popUntil(context, ModalRoute.withName('/bottom'));
        setState(() {
          loading = false;
        });
        // snackbar(context, Theme.of(context).primaryColor, 'เลือกสำเร็จ',
        //     Icons.check_circle_outline_rounded);
      } else {
        dialogOnebutton_Subtitle(
          context,
          'เลือกไม่สำเร็จ',
          '${jsonRes.data}',
          Icons.highlight_off_rounded,
          Colors.red,
          'ตกลง',
          () {
            Navigator.of(context).pop();
          },
        );
        print('Select fail!!');
        print(response.body);
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
        'ตกลง',
        () {
          Navigator.of(context).pop();
        },
      );
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getMultiCompany();
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
                              onTap: widget.pressProfile,
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
                                  bottomsheet();
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
                          onTap: widget.pressProfile,
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

  void bottomsheet() {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      context: context,
      builder: (context) {
        return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.3,
            minChildSize: 0.3,
            maxChildSize: 0.5,
            builder: (context, scrollController) => Scaffold(
                  backgroundColor: Colors.transparent,
                  bottomNavigationBar: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Buttons_Outline(
                        title: 'เพิ่มโครงการใหม่',
                        press: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Add_Company(),
                              ));
                        }),
                  ),
                  body: SingleChildScrollView(
                    controller: scrollController,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'สลับโครงการ',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            ListView.builder(
                              controller: scrollController,
                              shrinkWrap: true,
                              itemCount: multiCompany.length,
                              itemBuilder: (context, index) => InkWell(
                                child: Padding(
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
                                onTap: () {
                                  _selectCompany(
                                      context,
                                      multiCompany[index].sId,
                                      multiCompany[index].companyId);
                                  // Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ]),
                    ),
                  ),
                ));
      },
    );
  }
}
