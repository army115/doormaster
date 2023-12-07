// ignore_for_file: unrelated_type_equality_checks, prefer_const_constructors, use_build_context_synchronously, unused_import, prefer_typing_uninitialized_variables, camel_case_types

import 'package:doormster/components/text_form/text_form.dart';
import 'package:doormster/components/text_form/text_form_validator.dart';
import 'package:doormster/controller/profile_controller.dart';
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
import 'package:doormster/components/text_form/text_form_noborder.dart';
import 'package:doormster/models/profile_model.dart';
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
  final ProfileController controller = Get.put(ProfileController());

  final _formkey = GlobalKey<FormState>();
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController email = TextEditingController();
  String? imageProfile;

  List<Data> profileInfo = [];
  var uuId;

  Future Controller() async {
    fname = TextEditingController(text: profileInfo.single.firstName);
    lname = TextEditingController(text: profileInfo.single.surName);
    email = TextEditingController(text: profileInfo.single.email);
    imageProfile = profileInfo.single.image;
    uuId = profileInfo.single.userUuid;
  }

  final ImagePicker imgpicker = ImagePicker();
  String? image;

  Future<void> openImages(ImageSource TypeImage) async {
    try {
      // var pickedfiles = await imgpicker.pickMultiImage();
      final XFile? photo = await imgpicker.pickImage(
          source: TypeImage, maxHeight: 1080, maxWidth: 1080);
      List<int> imageBytes = await photo!.readAsBytes();
      var ImagesBase64 = convert.base64Encode(imageBytes);
      if (photo != (null)) {
        setState(() {
          image = ImagesBase64;
        });
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  @override
  void initState() {
    profileInfo = widget.infoProfile;
    Controller();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('edit_profile'.tr),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: controller.loading.isTrue
              ? Container()
              : Buttons(title: 'save'.tr, press: () {}),
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
                      Card(
                        elevation: 5,
                        shape: CircleBorder(
                            side: BorderSide(width: 3, color: Colors.white)),
                        child: CircleAvatar(
                            radius: 73,
                            backgroundColor: Colors.grey.shade100,
                            child: controller.loading.isTrue
                                // || imageProfile == null
                                ? Container(
                                    child: Icon(Icons.person_rounded,
                                        size: 140, color: Colors.grey),
                                  )
                                : image != null
                                    ? Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: MemoryImage(convert
                                                  .base64Decode(image!))),
                                        ),
                                      )
                                    : imageProfile != null
                                        ? Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: MemoryImage(
                                                      convert.base64Decode(
                                                          imageProfile!))),
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
                      ),
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
                                backgroundColor: Get.theme.primaryColor,
                                child: IconButton(
                                  splashRadius: 20,
                                  onPressed: () {
                                    editImgProfile();
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
                      SizedBox(height: 10),
                      Text('lname'.tr),
                      Text_Form(
                        controller: lname,
                        title: 'lname'.tr,
                        icon: Icons.person_outline_rounded,
                        error: 'enter_lname_pls'.tr,
                        TypeInput: TextInputType.name,
                      ),
                      SizedBox(height: 10),
                      Text('email'.tr),
                      Text_Form(
                        controller: email,
                        title: 'email'.tr,
                        icon: Icons.email_rounded,
                        error: 'enter_email_pls'.tr,
                        TypeInput: TextInputType.emailAddress,
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ),
        ),
        controller.loading.isTrue ? Loading() : Container()
      ],
    );
  }

  void editImgProfile() {
    showDialog(
      useRootNavigator: true,
      barrierDismissible: true,
      context: context,
      builder: (_) => AlertDialog(
        titlePadding: EdgeInsets.fromLTRB(30, 20, 20, 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          'change_picture'.tr,
          style: TextStyle(
              fontSize: 16, letterSpacing: 0.5, fontWeight: FontWeight.bold),
        ),
        actions: [
          ListTile(
              title: Text('camera'.tr,
                  style: TextStyle(fontSize: 15, letterSpacing: 0.5)),
              onTap: () {
                permissionCamere(context, () => openImages(ImageSource.camera));
                Navigator.of(context, rootNavigator: true).pop();
              }),
          ListTile(
            title: Text('photo'.tr,
                style: TextStyle(fontSize: 15, letterSpacing: 0.5)),
            onTap: () {
              if (Platform.isIOS) {
                permissionPhotos(context, openImages(ImageSource.gallery));
              } else {
                openImages(ImageSource.gallery);
              }
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          ListTile(
            title: Text('cancel'.tr,
                style: TextStyle(
                  fontSize: 15,
                  letterSpacing: 0.5,
                )),
            onTap: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ],
      ),
    );
  }
}
