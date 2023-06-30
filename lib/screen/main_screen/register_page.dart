// ignore_for_file: unused_import

import 'package:dio/dio.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/button/buttonback_appbar.dart';
import 'package:doormster/components/checkBox/checkbox_formfield.dart';
import 'package:doormster/components/dropdown/dropdonw_search.dart';
import 'package:doormster/components/dropdown/dropdown.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/components/text_form/text_form.dart';
import 'package:doormster/components/text_form/text_form_password.dart';
import 'package:doormster/components/text_form/text_form_validator.dart';
import 'package:doormster/models/get_company.dart';
import 'package:doormster/models/regis_response.dart';
import 'package:doormster/screen/main_screen/login_page.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'package:http/http.dart' as http;
// import 'dart:convert' as convert;

class Register_Page extends StatefulWidget {
  Register_Page({Key? key}) : super(key: key);

  @override
  State<Register_Page> createState() => _Register_PageState();
}

class _Register_PageState extends State<Register_Page> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController company = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordCon = TextEditingController();
  String? onItemSelect;

  bool Checked = false;
  bool loading = false;
  bool redEye = true;
  bool redEyeCon = true;
  List<DataCom> listCompany = [];

  Future _getCompany() async {
    try {
      setState(() {
        loading = true;
      });
      var url = '${Connect_api().domain}/getcompanyactive';
      var response = await Dio().get(
        url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        getCompany company = getCompany.fromJson(response.data);
        setState(() {
          listCompany = company.data!;
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      dialogOnebutton_Subtitle(context, 'พบข้อผิดพลาด', 'ไม่สามารถเชื่อมต่อได้',
          Icons.warning_amber_rounded, Colors.orange, 'ตกลง', () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Login_Page()),
            (Route<dynamic> route) => false);
      }, false, false);
      setState(() {
        loading = false;
      });
    }
  }

  Future _register(Map<String, dynamic> values) async {
    try {
      setState(() {
        loading = true;
      });
      var url = '${Connect_api().domain}/registermobile';
      var response = await Dio().post(url,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          }),
          data: values);
      var jsonRes = RegisResponse.fromJson(response.data);
      if (jsonRes.status == 200) {
        print('Register Success');
        print(values);
        print(jsonRes.status);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Login_Page()),
            (Route<dynamic> route) => false);
        setState(() {
          loading = false;
        });
        snackbar(context, Theme.of(context).primaryColor, 'ลงทะเบียนสำเร็จ',
            Icons.check_circle_outline_rounded);
      } else {
        dialogOnebutton_Subtitle(
            context,
            'ลงทะเบียนไม่สำเร็จ',
            '${jsonRes.result}',
            Icons.highlight_off_rounded,
            Colors.red,
            'ตกลง', () {
          Navigator.of(context).pop();
        }, false, false);
        print('Register not Success!!');
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
            MaterialPageRoute(builder: (BuildContext context) => Login_Page()),
            (Route<dynamic> route) => false);
        return false;
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Scaffold(
            appBar: AppBar(
              leading: button_back(() {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => Login_Page()),
                    (Route<dynamic> route) => false);
              }),
              title: Text('ลงทะเบียน'),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Buttons(
              title: 'ลงทะเบียน',
              press: () {
                if (_formkey.currentState!.validate()) {
                  Map<String, dynamic> valuse = Map();
                  valuse['user_name'] = username.text;
                  valuse['first_name'] = fname.text;
                  valuse['sur_name'] = lname.text;
                  valuse['email'] = email.text;
                  valuse['role'] = "0";
                  valuse['created_by'] = "0";
                  valuse['company_id'] = onItemSelect;
                  valuse['user_password'] = passwordCon.text;
                  _register(valuse);
                }
              },
            ),
            body: SafeArea(
                child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 80),
                child: Form(
                  key: _formkey,
                  child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Smart Community Logo.png',
                          scale: 4.5,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text_Form(
                          controller: username,
                          title: 'ชื่อผู้ใช้',
                          icon: Icons.account_circle_rounded,
                          error: 'กรุณากรอกชื่อผู้ใช้',
                          TypeInput: TextInputType.name,
                        ),
                        Text_Form(
                          controller: fname,
                          title: 'ชื่อ',
                          icon: Icons.person_outline_rounded,
                          error: 'กรุณากรอกชื่อ',
                          TypeInput: TextInputType.name,
                        ),
                        Text_Form(
                          controller: lname,
                          title: 'นามสกุล',
                          icon: Icons.person,
                          error: 'กรุณากรอกชื่อนามสกุล',
                          TypeInput: TextInputType.name,
                        ),
                        TextForm_validator(
                            controller: email,
                            title: 'อีเมล',
                            icon: Icons.email,
                            TypeInput: TextInputType.emailAddress,
                            error: (values) {
                              if (values.isEmpty) {
                                return 'กรุณากรอกอีเมล';
                              } else if (values.isEmpty ||
                                  !values.contains("@")) {
                                return "รูปแบบอีเมลไม่ถูกต้อง";
                              } else {
                                return null;
                              }
                            }),
                        Dropdown_Search(
                          title: 'เลือกบริษัท',
                          controller: company,
                          leftIcon: Icons.home_work_rounded,
                          onChanged: (value) {
                            final index = listCompany.indexWhere(
                                (item) => item.companyName == value);
                            if (index > -1) {
                              onItemSelect = listCompany[index].sId;
                            }
                            print(onItemSelect);
                          },
                          error: 'กรุณากเลือกบริษัท',
                          listItem: listCompany
                              .map((value) => value.companyName.toString())
                              .toList(),
                        ),
                        TextForm_Password(
                          controller: password,
                          title: 'รหัสผ่าน',
                          iconLaft: Icons.key,
                          error: (values) {
                            confirmPass = values;
                            if (values.isEmpty) {
                              return 'กรุณากรอกรหัสผ่าน';
                            } else if (values.length < 8) {
                              return "รหัสผ่านอย่างน้อย 8 ตัว";
                            } else {
                              return null;
                            }
                          },
                        ),
                        TextForm_Password(
                          controller: passwordCon,
                          title: 'ยืนยันรหัสผ่าน',
                          iconLaft: Icons.key,
                          error: (values) {
                            if (values.isEmpty) {
                              return 'กรุณายืนยันรหัสผ่าน';
                            } else if (values != confirmPass) {
                              return "รหัสผ่านไม่ตรงกัน";
                            } else {
                              return null;
                            }
                          },
                        ),
                        CheckBox_FormField(
                          title: 'ยอมรับเงื่อนไขการใช้บริการ',
                          value: Checked,
                          validator: 'กรุณายอมรับเงื่อนไขการใช้บริการ',
                        ),
                      ]),
                ),
              ),
            )),
          ),
          loading ? Loading() : Container()
        ],
      ),
    );
  }

  var confirmPass;
  Widget _password(controller, title, icon, error) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
          style: TextStyle(fontSize: 20),
          controller: controller,
          decoration: InputDecoration(
            prefixIconColor: Colors.green,
            contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
            // labelText: 'Username',
            hintText: title,
            hintStyle: TextStyle(fontSize: 20),
            errorStyle: TextStyle(fontSize: 18),
            // ignore: prefer_const_constructors
            prefixIcon: icon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          validator: error),
    );
  }

  // var dropdownValue;
  // Widget DropDownCompany() {
  //   return Dropdown_Search(
  //     title: 'เลือกบริษัท',
  //     // deviceId == null ? 'ไม่มีอุปกรณ์' : 'เลือกอุปกรณ์',
  //     values: dropdownValue,
  //     width: 0.85,
  //     height: 300,
  //     listItem: listCompany.map((value) {
  //       return DropdownMenuEntry(
  //         style: ButtonStyle(
  //             textStyle: MaterialStateProperty.all(
  //                 TextStyle(fontWeight: FontWeight.w500))),
  //         value: value.sId,
  //         label: value.companyName == ""
  //             ? 'บริษัทไม่ทราบชื่อ'
  //             : '${value.companyName}',
  //       );
  //     }).toList(),
  //     leftIcon: Icons.home_work_rounded,
  //     // validate: (values) {
  //     //   // if (deviceId != null) {
  //     //   if (values == null) {
  //     //     return 'กรุณาเลือกบริษัท';
  //     //   }
  //     //   return null;
  //     //   // }
  //     //   // return 'ไม่มีอุปกรณ์';
  //     // },
  //     onSelected: (value) {
  //       setState(() {
  //         dropdownValue = value;
  //         print('company : ${value}');
  //       });
  //     },
  //   );
  // }
}
