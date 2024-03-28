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
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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
                        Get.to(() => Profile_Update(
                              infoProfile: Profilecontroller.profileInfo,
                            ));
                      })
                ],
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  Profilecontroller.getInfo(500);
                },
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Column(
                    children: [
                      Card(
                        shape: Border(),
                        margin: EdgeInsets.zero,
                        color: Get.theme.primaryColor.withAlpha(200),
                        elevation: 5,
                        shadowColor: Colors.black,
                        child: Container(
                          padding:
                              EdgeInsetsDirectional.symmetric(vertical: 25),
                          width: double.infinity,
                          child: CircleAvatar(
                            radius: 73,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                                radius: 70,
                                backgroundColor: Colors.grey.shade100,
                                child: Profilecontroller.loading.isTrue
                                    // || imageProfile == null
                                    ? Container(
                                        child: Icon(Icons.person_rounded,
                                            size: 140, color: Colors.grey),
                                      )
                                    : Profilecontroller.imageProfile != null
                                        ? Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: MemoryImage(
                                                      convert.base64Decode(
                                                          Profilecontroller
                                                              .imageProfile!))),
                                            ),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                      'assets/images/HIP Smart Community Icon-01.png')),
                                            ),
                                          )),
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Column(children: [
                          ListTile(
                            title: Text(
                              'fname'.tr,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorDark),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Profilecontroller.profileInfo.isEmpty
                                    ? Container()
                                    : Text(
                                        Profilecontroller
                                            .profileInfo[0].firstName!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2),
                                SizedBox(height: 5),
                                Divider(),
                                SizedBox(height: 5),
                              ],
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'lname'.tr,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorDark),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Profilecontroller.profileInfo.isEmpty
                                    ? Container()
                                    : Text(
                                        Profilecontroller
                                            .profileInfo[0].surName!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2),
                                SizedBox(height: 5),
                                Divider(),
                                SizedBox(height: 5),
                              ],
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'email'.tr,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorDark),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Profilecontroller.profileInfo.isEmpty
                                    ? Container()
                                    : Text(
                                        Profilecontroller.profileInfo[0].email!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2),
                                SizedBox(height: 5),
                                Divider(),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Profilecontroller.loading.isTrue ? Loading() : Container()
          ],
        ));
  }
}
