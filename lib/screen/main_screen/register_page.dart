// ignore_for_file: unused_import, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/actions/form_error_snackbar.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/button/button_theme.dart';
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
import 'package:doormster/service/connected/connect_api.dart';
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
        });
      }
    } catch (error) {
      print(error);
      error_connected(() {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Login_Page()),
            (Route<dynamic> route) => false);
      });
    } finally {
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
        snackbar(Get.theme.primaryColor, 'register_success'.tr,
            Icons.check_circle_outline_rounded);
      } else {
        dialogOnebutton_Subtitle('register_fail'.tr, '${jsonRes.result}',
            Icons.highlight_off_rounded, Colors.red, 'ok'.tr, () {
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
              title: Text('register_title'.tr),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Buttons(
              title: 'submit'.tr,
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
                } else {
                  form_error_snackbar();
                }
              },
            ),
            body: Obx(() => SafeArea(
                    child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 80),
                    child: Form(
                      key: _formkey,
                      child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              themeController.isDarkMode == true
                                  ? 'assets/images/Smart Logo White.png'
                                  : 'assets/images/Smart Community Logo.png',
                              scale: 4.5,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text_Form(
                              controller: username,
                              title: 'username'.tr,
                              icon: Icons.account_circle_rounded,
                              error: 'enter_username_pls'.tr,
                              TypeInput: TextInputType.name,
                            ),
                            Text_Form(
                              controller: fname,
                              title: 'fname'.tr,
                              icon: Icons.person_outline_rounded,
                              error: 'enter_name_pls'.tr,
                              TypeInput: TextInputType.name,
                            ),
                            Text_Form(
                              controller: lname,
                              title: 'lname'.tr,
                              icon: Icons.person,
                              error: 'enter_lname_pls'.tr,
                              TypeInput: TextInputType.name,
                            ),
                            TextForm_validator(
                                controller: email,
                                title: 'email'.tr,
                                icon: Icons.email,
                                TypeInput: TextInputType.emailAddress,
                                error: (values) {
                                  if (values.isEmpty) {
                                    return 'enter_email_pls'.tr;
                                  } else if (!RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                      .hasMatch(values)) {
                                    return "email_error".tr;
                                  } else {
                                    return null;
                                  }
                                }),
                            Dropdown_Search(
                              title: 'company'.tr,
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
                              error: 'select_company_pls'.tr,
                              listItem: listCompany
                                  .map((value) => value.companyName.toString())
                                  .toList(),
                            ),
                            TextForm_Password(
                              controller: password,
                              title: 'password'.tr,
                              iconLaft: Icons.key,
                              error: (values) {
                                confirmPass = values;
                                if (values.isEmpty) {
                                  return 'enter_password_pls'.tr;
                                } else if (values.length < 8) {
                                  return "password_8char".tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                            TextForm_Password(
                              controller: passwordCon,
                              title: 'confirm_password'.tr,
                              iconLaft: Icons.key,
                              error: (values) {
                                if (values.isEmpty) {
                                  return 'confirm_password_pls'.tr;
                                } else if (values != confirmPass) {
                                  return "password_no_match".tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                            CheckBox_FormField(
                              title: 'accept_terms'.tr,
                              value: Checked,
                              validator: 'accept_terms_pls'.tr,
                            ),
                          ]),
                    ),
                  ),
                ))),
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
}
