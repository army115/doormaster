import 'package:dio/dio.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/alertDialog/alert_dialog_twobutton_subtext.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/button/button_ontline.dart';
import 'package:doormster/models/get_multi_company.dart';
import 'package:doormster/models/login_model.dart';
import 'package:doormster/screen/main_screen/add_company_page.dart';
import 'package:doormster/screen/main_screen/login_page.dart';
import 'package:doormster/screen/main_screen/login_staff_page.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
// import 'package:http/http.dart' as http;

class MyDrawer extends StatefulWidget {
  final pressProfile;
  MyDrawer({Key? key, this.pressProfile});

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

  Future _Logout() async {
    prefs = await SharedPreferences.getInstance();
    if (security == true) {
      prefs.clear();
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
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Login_Page()),
          (Route<dynamic> route) => false);
    }
    print('logout success');
  }

  Future getValueShared() async {
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

  Future _getMultiCompany() async {
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

  Future _selectCompany(context, uId, comId) async {
    prefs.clear();
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
      if (jsonRes.status == 200) {
        var token = jsonRes.accessToken;
        List<User> data = jsonRes.user!; //ตัวแปร List จาก model

        // ส่งค่าตัวแปร
        await prefs.setString('token', token!);
        await prefs.setString('userId', data.single.sId!);
        await prefs.setString('companyId', data.single.companyId!);
        await prefs.setInt('role', data.single.mobile!);
        await prefs.setString('uuId', data.single.userUuid!);

        if (data.single.devicegroupUuid != null) {
          await prefs.setString('deviceId', data.single.devicegroupUuid!);
        }
        if (data.single.weigangroupUuid != null) {
          await prefs.setString('weiganId', data.single.weigangroupUuid!);
        }

        print('userId: ${data.single.sId}');
        print('Select Success');
        print(response.data);

        Navigator.of(context).pop();
        Navigator.of(context).pop();

        setState(() {
          homeKey.currentState?.popAndPushNamed('/');
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
            initialChildSize: multiCompany.length == 0 ? 0.2 : 0.3,
            minChildSize: multiCompany.length == 0 ? 0.2 : 0.3,
            maxChildSize: 0.5,
            builder: (context, scrollController) => Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    toolbarHeight: 40,
                    automaticallyImplyLeading: false,
                    centerTitle: false,
                    title: Container(
                      width: double.infinity,
                      child: SingleChildScrollView(
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
                              SizedBox(height: 23),
                              Text(
                                'สลับโครงการ',
                                style: TextStyle(height: 0),
                              )
                            ],
                          )),
                    ),
                    elevation: 0,
                  ),
                  backgroundColor: Colors.transparent,
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
                  body: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: multiCompany.length == 0
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
                                // color: Colors.amber,
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
                              onTap: () {
                                if (companyId ==
                                    multiCompany[index].companyId) {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                } else {
                                  _selectCompany(
                                      context,
                                      multiCompany[index].sId,
                                      multiCompany[index].companyId);
                                }
                              },
                            ),
                          ),
                  ),
                ));
      },
    );
  }
}
