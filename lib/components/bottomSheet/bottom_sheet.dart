// ignore_for_file: sort_child_properties_last, prefer_const_constructors, unused_import
import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottom_controller.dart';
import 'package:doormster/components/button/button_outline.dart';
import 'package:doormster/models/login_model.dart';
import 'package:doormster/screen/main_screen/add_company_page.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/notify/notify_token.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'dart:convert' as convert;
import 'package:doormster/models/get_multi_company.dart';

class BottomSheetContent extends StatefulWidget {
  @override
  BottomSheetContentState createState() => BottomSheetContentState();
}

class BottomSheetContentState extends State<BottomSheetContent> {
  bool loading = true;
  List<Data> multiCompany = [];
  var companyId;

  @override
  void initState() {
    super.initState();
    _getMultiCompany();
  }

  Future<void> _getMultiCompany() async {
    final prefs = await SharedPreferences.getInstance();
    final uuId = prefs.getString('uuId');
    companyId = prefs.getString('companyId');
    try {
      setState(() {
        loading = true;
      });

      await Future.delayed(Duration(milliseconds: 700));

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
        final prefs = await SharedPreferences.getInstance();
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

        bottomController.ontapItem(0);

        setState(() {
          loading = false;
        });

        // snackbar( Theme.of(context).primaryColor, 'เลือกสำเร็จ',
        //     Icons.check_circle_outline_rounded);
      } else {
        dialogOnebutton_Subtitle('select_fail'.tr, '${jsonRes.data}',
            Icons.highlight_off_rounded, Colors.red, 'ok'.tr, () {
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
      error_connected(() async {
        Navigator.of(context).pop();
      });
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        minChildSize: 0.5,
        maxChildSize: 0.7,
        builder: (context, scrollController) => loading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Scaffold(
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
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                            multiCompany.isEmpty
                                ? Container()
                                : Text('switch_company'.tr)
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
                          child: Text('check_connect'.tr,
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
                              onTap: companyId == multiCompany[index].companyId
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
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
                  child: multiCompany.isEmpty
                      ? Container(height: 0)
                      : Buttons_Outline(
                          title: 'add_company'.tr,
                          press: () {
                            Navigator.pop(context);
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => Add_Company(),
                            ));
                          }),
                ),
              ));
  }
}
