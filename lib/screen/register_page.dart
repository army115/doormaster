import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/components/text_form/text_form.dart';
import 'package:doormster/components/text_form/text_form_password.dart';
import 'package:doormster/components/text_form/text_form_validator.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:checkbox_formfield/checkbox_formfield.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

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
  TextEditingController password = TextEditingController();
  TextEditingController passwordCon = TextEditingController();
  bool Checked = false;
  bool loading = false;
  bool redEye = true;
  bool redEyeCon = true;

  Future _register(Map<String, dynamic> values) async {
    try {
      setState(() {
        loading = true;
      });
      var url = '${Connect_api().domain}/register';
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: convert.jsonEncode(values));

      if (response.statusCode == 200) {
        print('Register Success');
        print(values);
        Navigator.pop(context, true);
        setState(() {
          loading = false;
        });
        snackbar(context, Theme.of(context).primaryColor, 'ลงทะเบียนสำเร็จ',
            Icons.check_circle_outline_rounded);
      } else {
        snackbar(context, Colors.red, 'ลงทะเบียนไม่สำเร็จ',
            Icons.highlight_off_rounded);
        print('Register not Success!!');
        print(response.body);
        setState(() {
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      snackbar(context, Colors.orange, 'กรุณาเชื่อมต่ออินเตอร์เน็ต',
          Icons.warning_amber_rounded);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('ลงทะเบียน'),
          ),
          body: SafeArea(
              child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Form(
                key: _formkey,
                child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        child: Image.asset(
                          'assets/images/qrlogo600.png',
                          scale: 3.5,
                        ),
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
                        icon: Icons.person,
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
                              // } else if (values.isEmpty ||
                              //     !values.contains("@")) {
                              //   return "รูปแบบอีเมลไม่ถูกต้อง";
                            } else {
                              return null;
                            }
                          }),
                      TextForm_Password(
                        controller: password,
                        title: 'รหัสผ่าน',
                        iconLaft: Icons.key,
                        error: (values) {
                          confirmPass = values;
                          if (values.isEmpty) {
                            return 'กรุณากรอกรหัสผ่าน';
                            // } else if (values.length < 8) {
                            //   return "รหัสผ่านอย่างน้อย 8 ตัว";
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
                      CheckboxListTileFormField(
                        activeColor: Theme.of(context).primaryColor,
                        title: Text(
                          'ยอมรับเงื่อนไขการใช้บริการ',
                          style: TextStyle(fontSize: 20),
                        ),
                        initialValue: Checked,
                        onChanged: (value) {
                          setState(() {
                            Checked = value;
                          });
                        },
                        validator: (values) {
                          if (values!) {
                            return null;
                          } else {
                            return 'กรุณายอมรับเงื่อนไขการใช้บริการ';
                          }
                        },
                      ),
                      Buttons(
                        title: 'ลงทะเบียน',
                        press: () {
                          if (_formkey.currentState!.validate()) {
                            Map<String, dynamic> valuse = Map();
                            valuse['name'] = username.text;
                            valuse['first_name'] = fname.text;
                            valuse['last_name'] = lname.text;
                            valuse['email'] = email.text;
                            valuse['position'] = 0;
                            valuse['password'] = passwordCon.text;
                            _register(valuse);
                          }
                        },
                      )
                    ]),
              ),
            ),
          )),
        ),
        loading ? Loading() : Container()
      ],
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
}
