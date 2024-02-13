// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/actions/form_error_snackbar.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottom_controller.dart';
import 'package:doormster/components/dropdown/dropdonw_search.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/notify/notify_token.dart';
import 'package:doormster/style/styleButton/ButtonStyle.dart';
import 'package:doormster/models/create_company_model.dart';
import 'package:doormster/models/get_company.dart';
import 'package:doormster/models/get_multi_company.dart';
import 'package:doormster/models/login_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';

class Add_Company extends StatefulWidget {
  const Add_Company({Key? key});

  @override
  State<Add_Company> createState() => _Add_CompanyState();
}

class _Add_CompanyState extends State<Add_Company> {
  final _formkey = GlobalKey<FormState>();
  var userId;
  var companyId;
  var uuId;
  bool loading = false;
  List<DataCom> listCompany = [];
  List<Data> multiCompany = [];
  late SharedPreferences prefs;
  TextEditingController controller = TextEditingController();
  String? onItemSelect;

  Future getValueShared() async {
    prefs = await SharedPreferences.getInstance();

    userId = prefs.getString('userId');
    companyId = prefs.getString('companyId');
    uuId = prefs.getString('uuId');

    print('userId: ${userId}');
    print('companyId: ${companyId}');
    print('uuId: ${uuId}');

    _getCompany();
  }

  Future _getCompany() async {
    try {
      setState(() {
        loading = true;
      });

      //call api get campany
      var urlCompany = '${Connect_api().domain}/getcompanyactive';
      var responseCompany = await Dio().get(
        urlCompany,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      );

      //call api get Muticampany
      var urlMutiCompany =
          '${Connect_api().domain}/get/multicompanymobile/$uuId';
      var responseMutiCompany = await Dio().get(
        urlMutiCompany,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      );

      if (responseCompany.statusCode == 200 &&
          responseMutiCompany.statusCode == 200) {
        getCompany company = getCompany.fromJson(responseCompany.data);

        getMultiCompany Muticompany =
            getMultiCompany.fromJson(responseMutiCompany.data);
        setState(() {
          listCompany = company.data!;
          multiCompany = Muticompany.data!;
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      error_connected(() {
        Navigator.of(context).popAndPushNamed('/bottom');
      });
      setState(() {
        loading = false;
      });
    }
  }

  Future _addCompany(Map<String, dynamic> values) async {
    try {
      setState(() {
        loading = true;
      });
      var url = '${Connect_api().domain}/create/createMultiCompanyforMobile';
      var response = await Dio().post(url,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          }),
          data: values);
      var jsonRes = createCompany.fromJson(response.data);
      if (jsonRes.status == 200) {
        print('add Success');
        print(values);
        print(jsonRes.status);
        _multiCompany(context, jsonRes.sId, jsonRes.companyId);
        setState(() {
          loading = false;
        });
        snackbar(Get.theme.primaryColor, 'add_success'.tr,
            Icons.check_circle_outline_rounded);
      } else {
        dialogOnebutton_Subtitle('add_fail'.tr, '${jsonRes.status}',
            Icons.highlight_off_rounded, Colors.red, 'ok'.tr, () {
          Navigator.of(context).pop();
        }, false, false);
        print('add not Success!!');
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
      // snackbar( Colors.orange, 'กรุณาเชื่อมต่ออินเตอร์เน็ต',
      //     Icons.warning_amber_rounded);
      setState(() {
        loading = false;
      });
    }
  }

  Future _multiCompany(context, uId, comId) async {
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

        print('userId: ${data.single.sId}');
        print('token: ${token}');
        print('login success');

        //ลบค่า device token ของบริษัทก่อนหน้า
        Notify_Token().deletenotifyToken();

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
        print('loginMulti Success');
        print(response.data);

        //เพิ่ม device token ของบริษัทนี้
        Notify_Token()
            .create_notifyToken(data.single.companyId, data.single.sId);

        Navigator.of(context).pushReplacementNamed('/bottom');
        bottomController.ontapItem(0);

        setState(() {
          loading = false;
        });
        // snackbar( Get.theme.primaryColor, 'เลือกสำเร็จ',
        //     Icons.check_circle_outline_rounded);
      } else {
        dialogOnebutton_Subtitle('add_fail'.tr, 'again_pls'.tr,
            Icons.highlight_off_rounded, Colors.red, 'ok'.tr, () {
          Navigator.of(context).pop();
        }, false, false);
        print('loginMulti fail!!');
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
  void initState() {
    super.initState();
    getValueShared();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popAndPushNamed('/bottom');

        return false;
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text('add_company'.tr),
              automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                  child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Form(
                  key: _formkey,
                  child: Column(children: [
                    Dropdown_Search(
                      title: 'company'.tr,
                      controller: controller,
                      leftIcon: Icons.home_work_rounded,
                      onChanged: (value) {
                        final index = listCompany
                            .indexWhere((item) => item.companyName == value);
                        if (index > -1) {
                          onItemSelect = listCompany[index].sId;
                        }
                        print(index);
                      },
                      error: 'select_company_pls'.tr,
                      listItem: listCompany
                          .map((value) => value.companyName.toString())
                          .toList(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    button()
                  ]),
                ),
              )),
            ),
          ),
          loading ? Loading() : Container()
        ],
      ),
    );
  }

  Widget button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          style: styleButtons(EdgeInsets.symmetric(horizontal: 40, vertical: 8),
              10.0, Colors.white, BorderRadius.circular(10)),
          onPressed: () {
            Navigator.of(context).popAndPushNamed('/bottom');
          },
          child: Text("cancel".tr,
              style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 1,
                  color: Colors.black,
                  fontWeight: FontWeight.normal)),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formkey.currentState!.validate()) {
              if (
                  //เช็คว่า companyId(onItemSelect) ที่เลือก มีอยู่ใน list multiCompany.companyId รึป่าว??
                  multiCompany
                      .map((item) => item.companyId)
                      .contains(onItemSelect)) {
                dialogOnebutton_Subtitle('cannot_add'.tr, 'have_company'.tr,
                    Icons.warning_amber_rounded, Colors.orange, 'ok'.tr, () {
                  Navigator.of(context).pop();
                }, false, false);
              } else {
                Map<String, dynamic> valuse = Map();
                valuse['id'] = userId;
                valuse['company_id'] = onItemSelect;
                _addCompany(valuse);
              }
            } else {
              form_error_snackbar();
            }
          },
          style: styleButtons(EdgeInsets.symmetric(horizontal: 40, vertical: 8),
              10.0, Get.theme.primaryColor, BorderRadius.circular(10)),
          child: Text(
            "save".tr,
            style: TextStyle(
                fontSize: 16,
                letterSpacing: 1,
                color: Colors.white,
                fontWeight: FontWeight.normal),
          ),
        )
      ],
    );
  }
}
