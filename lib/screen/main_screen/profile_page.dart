// ignore_for_file: unrelated_type_equality_checks, prefer_const_constructors, use_build_context_synchronously, unused_import

import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/controller/profile_controller.dart';
import 'package:doormster/screen/main_screen/profile_update_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert' as convert;

class Profile_Page extends StatefulWidget {
  const Profile_Page({Key? key});

  @override
  State<Profile_Page> createState() => _Profile_PageState();
}

class _Profile_PageState extends State<Profile_Page>
// with AutomaticKeepAliveClientMixin
{
  final ProfileController controller = Get.put(ProfileController());

  // @override
  // bool get wantKeepAlive => true;

  // @override
  // void initState() {
  //   _getInfo();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return Obx(() => Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text('info'.tr),
                leading: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    }),
                actions: [
                  IconButton(
                      icon: Icon(Icons.mode_edit_outlined),
                      onPressed: () {
                        Get.to(Profile_Update(
                          infoProfile: controller.profileInfo,
                        ));
                      })
                ],
              ),
              body: Column(
                children: [
                  Card(
                    shape: Border(),
                    margin: EdgeInsets.zero,
                    color: Colors.blue[700],
                    elevation: 5,
                    child: Container(
                      padding: EdgeInsetsDirectional.symmetric(vertical: 25),
                      width: double.infinity,
                      child: CircleAvatar(
                        radius: 73,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.grey.shade100,
                            child: controller.loading.isTrue
                                // || imageProfile == null
                                ? Container(
                                    child: Icon(Icons.person_rounded,
                                        size: 140, color: Colors.grey),
                                  )
                                : controller.imageProfile != null
                                    ? Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: MemoryImage(convert
                                                  .base64Decode(controller
                                                      .imageProfile!))),
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
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        controller.getInfo();
                      },
                      child: Container(
                        height: double.infinity,
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Column(children: [
                            ListTile(
                              title: Text(
                                'fname'.tr,
                                style: TextStyle(color: Get.theme.primaryColor),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5),
                                  controller.profileInfo.isEmpty
                                      ? Container()
                                      : Text(
                                          controller.profileInfo[0].firstName!,
                                          style:
                                              TextStyle(color: Colors.black)),
                                  SizedBox(height: 5),
                                  Divider(color: Colors.black),
                                  SizedBox(height: 5),
                                ],
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'lname'.tr,
                                style: TextStyle(color: Get.theme.primaryColor),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5),
                                  controller.profileInfo.isEmpty
                                      ? Container()
                                      : Text(controller.profileInfo[0].surName!,
                                          style:
                                              TextStyle(color: Colors.black)),
                                  SizedBox(height: 5),
                                  Divider(color: Colors.black),
                                  SizedBox(height: 5),
                                ],
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'email'.tr,
                                style: TextStyle(color: Get.theme.primaryColor),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5),
                                  controller.profileInfo.isEmpty
                                      ? Container()
                                      : Text(controller.profileInfo[0].email!,
                                          style:
                                              TextStyle(color: Colors.black)),
                                  SizedBox(height: 5),
                                  Divider(color: Colors.black),
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            controller.loading.isTrue ? Loading() : Container()
          ],
        ));
  }
}
