import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/button/button_ontline.dart';
import 'package:doormster/components/dropdown/dropdown.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/models/create_company_model.dart';
import 'package:doormster/models/get_company.dart';
import 'package:doormster/models/get_multi_company.dart';
import 'package:doormster/models/login_model.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

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

  Future _getCompany() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    companyId = prefs.getString('companyId');

    print('userId: ${userId}');
    print('companyId: ${companyId}');
    try {
      setState(() {
        loading = true;
      });
      var url = '${Connect_api().domain}/getcompanyactive';
      var response = await http.get(Uri.parse(url), headers: {
        'Connect-type': 'application/json',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        getCompany company =
            getCompany.fromJson(convert.jsonDecode(response.body));
        setState(() {
          listCompany = company.data!;
          loading = false;
          _getMultiCompany();
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
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => BottomBar()),
            (Route<dynamic> route) => false);
      }, false);
      setState(() {
        loading = false;
      });
    }
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
          'ไม่สามารถเชื่อมต่อได้ กรุณาลองใหม่อีกครั้ง',
          Icons.warning_amber_rounded,
          Colors.orange,
          'ตกลง', () {
        Navigator.popUntil(context, (route) => route.isFirst);
      }, false);
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
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: convert.jsonEncode(values));
      var jsonRes = createCompany.fromJson(convert.jsonDecode(response.body));
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
        }, false);
        print('add not Success!!');
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
          'ตกลง', () {
        Navigator.of(context).pop();
      }, false);
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
        print('loginMulti Success');
        print(response.body);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => BottomBar()),
            (Route<dynamic> route) => false);
        setState(() {
          loading = false;
        });
        // snackbar(context, Theme.of(context).primaryColor, 'เลือกสำเร็จ',
        //     Icons.check_circle_outline_rounded);
      } else {
        dialogOnebutton_Subtitle(context, 'เพิ่มไม่สำเร็จ', '${jsonRes.data}',
            Icons.highlight_off_rounded, Colors.red, 'ตกลง', () {
          Navigator.of(context).pop();
        }, false);
        print('loginMulti fail!!');
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
          'ตกลง', () {
        Navigator.of(context).pop();
      }, false);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCompany();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => BottomBar()),
            (Route<dynamic> route) => false);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: Text('เพิ่มโครงการใหม่')),
        body: SafeArea(
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
        RaisedButton(
          elevation: 5,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => BottomBar()),
                (Route<dynamic> route) => false);
          },
          child: Text("ยกเลิก",
              style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 1,
                  color: Colors.black,
                  fontWeight: FontWeight.normal)),
        ),
        RaisedButton(
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
                }, false);
              } else {
                Map<String, dynamic> valuse = Map();
                valuse['id'] = userId;
                valuse['company_id'] = dropdownValue;
                _addCompany(valuse);
              }
            }
          },
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.symmetric(horizontal: 45, vertical: 8),
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Text(
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
