// ignore_for_file: unrelated_type_equality_checks, prefer_const_constructors, use_build_context_synchronously, unused_import, prefer_typing_uninitialized_variables, camel_case_types, non_constant_identifier_names
import 'package:dio/dio.dart' as dio;
import 'package:doormster/widgets/actions/form_error_snackbar.dart';
import 'package:doormster/widgets/dropdown/dropdown.dart';
import 'package:doormster/widgets/image/circle_image.dart';
import 'package:doormster/widgets/text/text_double_colors.dart';
import 'package:doormster/widgets/text_form/text_form.dart';
import 'package:doormster/widgets/text_form/text_form_number.dart';
import 'package:doormster/widgets/text_form/text_form_validator.dart';
import 'package:doormster/controller/image_controller/add_images_controller.dart';
import 'package:doormster/controller/main_controller/home_controller.dart';
import 'package:doormster/controller/main_controller/profile_controller.dart';
import 'package:doormster/utils/scroll_field.dart';
import 'package:doormster/models/main_models/get_profile.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/widgets/bottombar/bottombar.dart';
import 'package:doormster/widgets/button/button.dart';
import 'package:doormster/widgets/drawer/drawer.dart';
import 'package:doormster/widgets/loading/loading.dart';
import 'package:doormster/widgets/snackbar/snackbar.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/permission/permission_camera.dart';
import 'package:doormster/service/permission/permission_photos.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Profile_Update extends StatefulWidget {
  // final infoProfile;
  const Profile_Update({
    super.key,
    // required this.infoProfile
  });

  @override
  State<Profile_Update> createState() => _Profile_UpdateState();
}

class _Profile_UpdateState extends State<Profile_Update> {
  final image = addImagesController.listImage;
  final ProfileController profileController = Get.find<ProfileController>();

  final _formkey = GlobalKey<FormState>();
  final List<GlobalKey<FormFieldState>> _fieldKeys =
      List.generate(5, (index) => GlobalKey<FormFieldState>());
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

  Future getInfo() async {
    profileInfo = profileController.profileInfo.value.data!;
    fname = TextEditingController(text: profileInfo.firstName);
    lname = TextEditingController(text: profileInfo.lastName);
    phone = TextEditingController(text: profileInfo.phone);
    email = TextEditingController(text: profileInfo.email);
    sex = TextEditingController(text: profileInfo.sex!.tr);
    dropdownValue = profileInfo.sex;
    imageProfile = profileInfo.profileImg;
    debugPrint(imageProfile);
    userId = profileInfo.employeeNo;
  }

  @override
  void initState() {
    getInfo();
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
      () => Scaffold(
        appBar: AppBar(
          title: Text('edit_profile'.tr),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: connectApi.loading.isTrue
            ? Container()
            : Buttons(
                title: 'save'.tr,
                width: Get.mediaQuery.size.width * 0.6,
                press: () async {
                  if (_formkey.currentState!.validate()) {
                    Map<String, dynamic> values = {};
                    values['role_id'] = homeController.roleId.value;
                    values['employee_no'] = userId;
                    values['first_name'] = fname.text;
                    values['last_name'] = lname.text;
                    values['phone'] = phone.text;
                    values['email'] = email.text;
                    values['sex'] = dropdownValue;

                    if (image.isNotEmpty) {
                      final files = await dio.MultipartFile.fromFile(
                        image.last.path,
                        filename: image.last.name,
                      );
                      values['profileImg'] = files.length;
                    }
                    debugPrint("values: $values");
                    profileController.edit_Profile(values);
                  } else {
                    for (var key in _fieldKeys) {
                      if (!key.currentState!.validate()) {
                        scrollToField(key);
                        break;
                      }
                    }
                    form_error_snackbar();
                  }
                }),
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Form(
            key: _formkey,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  15, 15, 15, MediaQuery.of(context).size.height * 0.15),
              child: Column(children: [
                circleImage(
                    typeImage: 'net',
                    fileImage: image,
                    imageProfile: imageProfile,
                    radiusCircle: 73,
                    borderSide: 3,
                    iconImagenull: Icon(
                      Icons.person,
                      color: Colors.grey,
                      size: 140,
                    ),
                    iconImageError:
                        const Icon(Icons.error, size: 50, color: Colors.grey),
                    editImage: () {
                      addImagesController.selectType(
                          context, "change_picture".tr);
                    }),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textDoubleColors(
                      text1: 'fname'.tr,
                      text2: '*',
                      color2: Colors.red,
                    ),
                    Text_Form(
                        fieldKey: _fieldKeys[0],
                        controller: fname,
                        title: 'fname'.tr,
                        icon: Icons.person,
                        error: 'enter_name_pls'.tr,
                        TypeInput: TextInputType.name),
                    textDoubleColors(
                      text1: 'lname'.tr,
                      text2: '*',
                      color2: Colors.red,
                    ),
                    Text_Form(
                      fieldKey: _fieldKeys[1],
                      controller: lname,
                      title: 'lname'.tr,
                      icon: Icons.person_outline_rounded,
                      error: 'enter_lname_pls'.tr,
                      TypeInput: TextInputType.name,
                    ),
                    textDoubleColors(
                      text1: 'phone_number'.tr,
                      text2: '*',
                      color2: Colors.red,
                    ),
                    TextForm_Number(
                      fieldKey: _fieldKeys[2],
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
                    textDoubleColors(
                      text1: 'email'.tr,
                      text2: '*',
                      color2: Colors.red,
                    ),
                    TextForm_validator(
                        fieldKey: _fieldKeys[3],
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
                    textDoubleColors(
                      text1: 'sex'.tr,
                      text2: '*',
                      color2: Colors.red,
                    ),
                    Dropdown(
                      title: 'sex'.tr,
                      controller: sex,
                      listItem: sexType.map((e) => e['label']!).toList(),
                      onChanged: (value) {
                        final selected = sexType
                            .firstWhere((item) => item['label'] == value);
                        dropdownValue = selected['value'];
                      },
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
