// ignore_for_file: unrelated_type_equality_checks

import 'dart:io';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/drawer/drawer.dart';
import 'package:doormster/components/text_form/text_form.dart';
import 'package:doormster/components/text_form/text_form_noborder.dart';
import 'package:doormster/models/profile_model.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert' as convert;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Profile_Page extends StatefulWidget {
  const Profile_Page({Key? key});

  @override
  State<Profile_Page> createState() => _Profile_PageState();
}

class _Profile_PageState extends State<Profile_Page> {
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController email = TextEditingController();

  bool loading = false;
  List<Data> profileInfo = [];

  Future _getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');
    print('userId: ${userId}');

    try {
      setState(() {
        loading = true;
      });
      var url = '${Connect_api().domain}/get/profile/$userId';
      var response = await http.get(Uri.parse(url), headers: {
        'Connect-type': 'application/json',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        GetProfile getInfo =
            GetProfile.fromJson(convert.jsonDecode(response.body));
        setState(() {
          profileInfo = getInfo.data!;
          Controller();
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
        'ตกลง',
        () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      );
      setState(() {
        loading = false;
      });
    }
  }

  Future Controller() async {
    fname = TextEditingController(text: profileInfo.single.firstName);
    lname = TextEditingController(text: profileInfo.single.surName);
    email = TextEditingController(text: profileInfo.single.email);
  }

  final ImagePicker imgpicker = ImagePicker();
  XFile? image;

  openImages(ImageSource TypeImage) async {
    try {
      // var pickedfiles = await imgpicker.pickMultiImage();
      final XFile? photo = await imgpicker.pickImage(source: TypeImage);
      //you can use ImageCourse.camera for Camera capture
      if (photo != null) {
        // imagefiles = pickedfiles;
        setState(() {
          image = photo;
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
    super.initState();
    _getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('ข้อมูลส่วนตัว'),
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            }),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: Column(children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 73,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.grey[100],
                        child: image != null
                            ? Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(File(image!.path))),
                                ),
                              )
                            : Container(),
                        backgroundImage: AssetImage(
                            'assets/images/HIP Smart Community Icon-03.png')),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 21,
                        child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: IconButton(
                              splashRadius: 20,
                              onPressed: () {
                                openImages(ImageSource.gallery);
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
                title: 'ชื่อ',
                icon: Icons.person,
                error: 'กรุณากรอกชื่อ',
                TypeInput: TextInputType.name,
              ),
              Text_Form_NoBorder(
                controller: lname,
                title: 'นามสกุล',
                icon: Icons.person_outline_rounded,
                error: 'กรุณากรอกชื่อ',
                TypeInput: TextInputType.name,
              ),
              Text_Form_NoBorder(
                controller: email,
                title: 'อีเมล',
                icon: Icons.email_rounded,
                error: 'กรุณากรอกชื่อ',
                TypeInput: TextInputType.emailAddress,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
