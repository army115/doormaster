import 'package:dio/dio.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/dropdown/dropdown.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/screen/style/styleButton/ButtonStyle.dart';
import 'package:doormster/models/create_company_model.dart';
import 'package:doormster/models/get_company.dart';
import 'package:doormster/models/get_multi_company.dart';
import 'package:doormster/models/login_model.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:flutter/material.dart';
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
      dialogOnebutton_Subtitle(
          context,
          'พบข้อผิดพลาด',
          'ไม่สามารถเชื่อมต่อได้ กรุณาลองใหม่อีกครั้ง',
          Icons.warning_amber_rounded,
          Colors.orange,
          'ตกลง', () {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/bottom', (Route<dynamic> route) => false);
      }, false, false);
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
        snackbar(context, Theme.of(context).primaryColor, 'เพิ่มสำเร็จ',
            Icons.check_circle_outline_rounded);
      } else {
        dialogOnebutton_Subtitle(context, 'เพิ่มไม่สำเร็จ', '${jsonRes.status}',
            Icons.highlight_off_rounded, Colors.red, 'ตกลง', () {
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
      dialogOnebutton_Subtitle(
          context,
          'พบข้อผิดพลาด',
          'ไม่สามารถเชื่อมต่อได้ กรุณาลองใหม่อีกครั้ง',
          Icons.warning_amber_rounded,
          Colors.orange,
          'ตกลง', () {
        Navigator.of(context).pop();
      }, false, false);
      // snackbar(context, Colors.orange, 'กรุณาเชื่อมต่ออินเตอร์เน็ต',
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

        // ส่งค่าตัวแปร
        await prefs.setString('token', token!);
        await prefs.setString('userId', data.single.sId!);
        await prefs.setString('companyId', data.single.companyId!);
        await prefs.setInt('role', data.single.mobile!);
        await prefs.setString('uuId', data.single.userUuid!);

        if (data.single.devicegroupUuid != null) {
          await prefs.setString('deviceId', data.single.devicegroupUuid!);
        }
        if (data.single.devicegroupUuid != null) {
          await prefs.setString('weiganId', data.single.weigangroupUuid!);
        }
        print('loginMulti Success');
        print(response.data);

        Navigator.of(context).pushNamedAndRemoveUntil(
            '/bottom', (Route<dynamic> route) => false);
        setState(() {
          loading = false;
        });
        // snackbar(context, Theme.of(context).primaryColor, 'เลือกสำเร็จ',
        //     Icons.check_circle_outline_rounded);
      } else {
        dialogOnebutton_Subtitle(
            context,
            'เพิ่มไม่สำเร็จ',
            'กรุณาลองใหม่อีกครั้ง',
            Icons.highlight_off_rounded,
            Colors.red,
            'ตกลง', () {
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/bottom', (Route<dynamic> route) => false);
        return false;
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(title: Text('เพิ่มโครงการใหม่')),
            body: SingleChildScrollView(
              child: SafeArea(
                  child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Form(
                  key: _formkey,
                  child: Column(children: [
                    DropDownCompany(),
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

  var dropdownValue;
  Widget DropDownCompany() {
    return Dropdown(
      title: 'เลือกบริษัท',
      // deviceId == null ? 'ไม่มีอุปกรณ์' : 'เลือกอุปกรณ์',
      values: dropdownValue,
      listItem: listCompany.map((value) {
        return DropdownMenuItem(
          value: value.sId,
          child: Text(
            value.companyName == ""
                ? 'บริษัทไม่ทราบชื่อ'
                : '${value.companyName}',
          ),
        );
      }).toList(),
      leftIcon: Icons.home_work_rounded,
      validate: (values) {
        // if (deviceId != null) {
        if (values == null) {
          return 'กรุณาเลือกบริษัท';
        }
        return null;
        // }
        // return 'ไม่มีอุปกรณ์';
      },
      onChange: (value) {
        setState(() {
          _formkey.currentState?.validate();
          dropdownValue = value;
          print('company : ${value}');
        });
      },
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
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/bottom', (Route<dynamic> route) => false);
          },
          child: Text("ยกเลิก",
              style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 1,
                  color: Colors.black,
                  fontWeight: FontWeight.normal)),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formkey.currentState!.validate()) {
              if (multiCompany
                  .map((item) => item.companyId)
                  .contains(dropdownValue)) {
                dialogOnebutton_Subtitle(
                    context,
                    'ไม่สามารถเพิ่มได้',
                    'คุณมีบริษัทนี้อยู่แล้ว',
                    Icons.warning_amber_rounded,
                    Colors.orange,
                    'ตกลง', () {
                  Navigator.of(context).pop();
                }, false, false);
              } else {
                Map<String, dynamic> valuse = Map();
                valuse['id'] = userId;
                valuse['company_id'] = dropdownValue;
                _addCompany(valuse);
              }
            }
          },
          style: styleButtons(EdgeInsets.symmetric(horizontal: 40, vertical: 8),
              10.0, Theme.of(context).primaryColor, BorderRadius.circular(10)),
          child: const Text(
            "บันทึก",
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
