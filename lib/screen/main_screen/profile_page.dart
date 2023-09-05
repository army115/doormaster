// ignore_for_file: unrelated_type_equality_checks, prefer_const_constructors, use_build_context_synchronously, unused_import

import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

// import 'package:http/http.dart' as http;
// import 'dart:convert' as convert;
// import 'dart:async';
class Profile_Page extends StatefulWidget {
  const Profile_Page({Key? key});

  @override
  State<Profile_Page> createState() => _Profile_PageState();
}

class _Profile_PageState extends State<Profile_Page>
    with AutomaticKeepAliveClientMixin {
  final _formkey = GlobalKey<FormState>();
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController email = TextEditingController();
  String? imageProfile;

  bool loading = false;
  List<Data> profileInfo = [];
  var check;
  var uuId;

  Future _sharedInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('fname', fname.text);
    await prefs.setString('lname', lname.text);
    if (image != null) {
      await prefs.setString('image', image!);
    }
  }

  Future _getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uuId = prefs.getString('uuId');
    var userId = prefs.getString('userId');
    print('uuId: ${uuId}');
    print('userId: ${userId}');
    check = await Connectivity().checkConnectivity();
    try {
      setState(() {
        loading = true;
      });

      await Future.delayed(Duration(milliseconds: 500));

      var url = '${Connect_api().domain}/get/profile/$userId';
      var response = await Dio().get(
        url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        GetProfile getInfo = GetProfile.fromJson(response.data);
        setState(() {
          profileInfo = getInfo.data!;
          Controller();
          _sharedInfo();
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      await Future.delayed(Duration(milliseconds: 500));
      dialogOnebutton_Subtitle(context, 'found_error'.tr, 'connect_fail'.tr,
          Icons.warning_amber_rounded, Colors.orange, 'ok'.tr, () {
        Navigator.of(context, rootNavigator: true).pop();
        setState(() {
          _getInfo();
        });
      }, false, false);
      setState(() {
        loading = false;
      });
    }
  }

  Future _editProfile(Map<String, dynamic> values) async {
    try {
      setState(() {
        loading = true;
      });
      var url = '${Connect_api().domain}/edit/profile';
      var response = await Dio().post(url,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          }),
          data: values);
      var _response = response.toString().split(',').first.split(':').last;
      print(_response);
      if (_response == '200') {
        print('edit Success');
        print(values);
        print(response.data);

        snackbar(context, Theme.of(context).primaryColor, 'แก้ไขสำเร็จ',
            Icons.check_circle_outline_rounded);

        setState(() {
          loading = false;
          _sharedInfo();
        });
      } else {
        dialogOnebutton_Subtitle(context, 'edit_fail'.tr, 'again_pls'.tr,
            Icons.highlight_off_rounded, Colors.red, 'ตกลง', () {
          Navigator.of(context, rootNavigator: true).pop();
        }, false, false);
        print('checkIn not Success!!');
        print(response.data);
        setState(() {
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      dialogOnebutton_Subtitle(context, 'found_error'.tr, 'connect_fail'.tr,
          Icons.warning_amber_rounded, Colors.orange, 'ตกลง', () {
        Navigator.of(context, rootNavigator: true).pop();
      }, false, false);
      // snackbar(context, Colors.orange, 'กรุณาเชื่อมต่ออินเตอร์เน็ต',
      //     Icons.warning_amber_rounded);
      setState(() {
        loading = false;
      });
    }
  }

  Future Controller() async {
    fname = TextEditingController(text: profileInfo.single.firstName);
    lname = TextEditingController(text: profileInfo.single.surName);
    email = TextEditingController(text: profileInfo.single.email);
    imageProfile = profileInfo.single.image;
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
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('info'.tr),
            leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                }),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: loading
              ? Container()
              : Buttons(
                  title: 'save'.tr,
                  press: () {
                    if (_formkey.currentState!.validate()) {
                      Map<String, dynamic> valuse = Map();
                      valuse['uuid'] = uuId;
                      valuse['first_name'] = fname.text;
                      valuse['email'] = email.text;
                      valuse['sur_name'] = lname.text;

                      if (image != null) {
                        valuse['image'] = image;
                      } else {
                        valuse['image'] = imageProfile;
                      }

                      _editProfile(valuse);
                    }
                  }),
          body: RefreshIndicator(
            onRefresh: () async {
              _getInfo();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Form(
                key: _formkey,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                      20, 20, 20, MediaQuery.of(context).size.height * 0.15),
                  child: Column(children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 73,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.grey.shade100,
                              child: loading || profileInfo.isEmpty
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
                          right: 0,
                          child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 21,
                              child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: IconButton(
                                    splashRadius: 20,
                                    onPressed: () {
                                      editProfile();
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
                    Text_Form_NoBorder(
                      controller: fname,
                      title: 'fname'.tr,
                      icon: Icons.person,
                      error: 'enter_name_pls'.tr,
                      TypeInput: TextInputType.name,
                    ),
                    Text_Form_NoBorder(
                      controller: lname,
                      title: 'lname'.tr,
                      icon: Icons.person_outline_rounded,
                      error: 'enter_lname_pls'.tr,
                      TypeInput: TextInputType.name,
                    ),
                    Text_Form_NoBorder(
                      controller: email,
                      title: 'email'.tr,
                      icon: Icons.email_rounded,
                      error: 'enter_email_pls'.tr,
                      TypeInput: TextInputType.emailAddress,
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
        loading ? Loading() : Container()
      ],
    );
  }

  void editProfile() {
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
