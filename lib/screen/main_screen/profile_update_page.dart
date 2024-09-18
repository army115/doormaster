// ignore_for_file: unrelated_type_equality_checks, prefer_const_constructors, use_build_context_synchronously, unused_import, prefer_typing_uninitialized_variables, camel_case_types, non_constant_identifier_names
import 'package:dio/dio.dart' as dio;
import 'package:doormster/components/actions/form_error_snackbar.dart';
import 'package:doormster/components/dropdown/dropdown.dart';
import 'package:doormster/components/text_form/text_form.dart';
import 'package:doormster/components/text_form/text_form_number.dart';
import 'package:doormster/components/text_form/text_form_validator.dart';
import 'package:doormster/controller/add_images_controller.dart';
import 'package:doormster/controller/profile_controller.dart';
import 'package:doormster/models/main_models/get_profile.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/drawer/drawer.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/permission/permission_camera.dart';
import 'package:doormster/service/permission/permission_photos.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class Profile_Update extends StatefulWidget {
  final infoProfile;
  const Profile_Update({super.key, required this.infoProfile});

  @override
  State<Profile_Update> createState() => _Profile_UpdateState();
}

class _Profile_UpdateState extends State<Profile_Update> {
  final image = addImagesController.listImage;

  final _formkey = GlobalKey<FormState>();
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController sex = TextEditingController();
  List<Map<String, String>> sexType = [
    {'value': 'male', 'label': 'male'.tr},
    {'value': 'female', 'label': 'female'.tr},
  ];
  String? imageProfile;

  Data profileInfo = Data();
  String? userId;
  String? dropdownValue;

  Future Controller() async {
    fname = TextEditingController(text: profileInfo.firstName);
    lname = TextEditingController(text: profileInfo.lastName);
    phone = TextEditingController(text: profileInfo.phone);
    email = TextEditingController(text: profileInfo.email);
    sex = TextEditingController(text: profileInfo.sex!.tr);
    imageProfile = profileInfo.profileImg;
    userId = profileInfo.employeeNo;
  }

  @override
  void initState() {
    profileInfo = widget.infoProfile;
    Controller();
    super.initState();
  }

  @override
  void dispose() {
    image.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text('edit_profile'.tr),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: connectApi.loading.isTrue
                ? Container()
                : Buttons(
                    title: 'save'.tr,
                    press: () async {
                      List<dio.MultipartFile> files = [];
                      for (int i = 0; i < image.length; i++) {
                        files.add(await dio.MultipartFile.fromFile(
                          image[i].path,
                          filename: image[i].name,
                        ));
                      }
                      if (_formkey.currentState!.validate()) {
                        Map<String, dynamic> values = Map();
                        values['employee_no'] = userId;
                        values['first_name'] = fname.text;
                        values['last_name'] = lname.text;
                        values['phone'] = phone.text;
                        values['email'] = email.text;
                        values['sex'] = dropdownValue;
                        if (files.isNotEmpty) {
                          values['profileImg'] = files;
                        }
                        profileController.edit_Complaint(values);
                      } else {
                        form_error_snackbar();
                      }
                    }),
            body: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Form(
                key: _formkey,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                      20, 20, 20, MediaQuery.of(context).size.height * 0.15),
                  child: Column(children: [
                    Stack(
                      children: [
                        Obx(() {
                          return Card(
                            elevation: 5,
                            shape: CircleBorder(
                                side:
                                    BorderSide(width: 3, color: Colors.white)),
                            child: CircleAvatar(
                                radius: 73,
                                backgroundColor: Colors.grey.shade100,
                                child: image.isNotEmpty
                                    ? Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: FileImage(
                                                  File(image.first.path))),
                                        ),
                                      )
                                    : imageProfile != null
                                        ? Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    imageDomain +
                                                        imageProfile!),
                                                onError: (exception,
                                                        stackTrace) =>
                                                    Icon(
                                                        Icons
                                                            .broken_image_rounded,
                                                        size: 140,
                                                        color: Colors.grey),
                                              ),
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
                                          )),
                          );
                        }),
                        Positioned(
                          bottom: 0,
                          right: 5,
                          child: Card(
                              elevation: 5,
                              shape: CircleBorder(
                                  side: BorderSide(
                                      color: Colors.white, width: 2.5)),
                              child: CircleAvatar(
                                  radius: 21,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: IconButton(
                                    splashRadius: 20,
                                    onPressed: () {
                                      addImagesController.selectType(
                                          context, "change_picture".tr);
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ))),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('fname'.tr),
                        Text_Form(
                            controller: fname,
                            title: 'fname'.tr,
                            icon: Icons.person,
                            error: 'enter_name_pls'.tr,
                            TypeInput: TextInputType.name),
                        Text('lname'.tr),
                        Text_Form(
                          controller: lname,
                          title: 'lname'.tr,
                          icon: Icons.person_outline_rounded,
                          error: 'enter_lname_pls'.tr,
                          TypeInput: TextInputType.name,
                        ),
                        Text('phone_number'.tr),
                        TextForm_Number(
                          controller: phone,
                          title: 'phone_number'.tr,
                          icon: Icons.phone,
                          type: TextInputType.name,
                          maxLength: 10,
                          error: (values) {
                            if (values.isEmpty) {
                              return 'enter_phone'.tr;
                            } else if (values.length < 10) {
                              return "phone_10char".tr;
                            } else {
                              return null;
                            }
                          },
                        ),
                        Text('email'.tr),
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
                        Text('sex'.tr),
                        Dropdown(
                          title: 'sex'.tr,
                          controller: sex,
                          listItem: sexType.map((e) => e['label']!).toList(),
                          onChanged: (value) {
                            final selected = sexType
                                .firstWhere((item) => item['label'] == value);
                            dropdownValue = selected['value'];
                          },
                        )
                      ],
                    ),
                  ]),
                ),
              ),
            ),
          ),
          connectApi.loading.isTrue ? Loading() : Container()
        ],
      ),
    );
  }
}
