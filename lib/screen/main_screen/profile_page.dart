// ignore_for_file: unrelated_type_equality_checks, prefer_const_constructors, use_build_context_synchronously, unused_import, non_constant_identifier_names

import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/controller/profile_controller.dart';
import 'package:doormster/models/main_models/get_profile.dart';
import 'package:doormster/screen/main_screen/profile_update_page.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      profileController.get_Profile(loadingTime: 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      if (profileController.profileInfo.value.data == null) {
        return Info_null();
      }
      final info = profileController.profileInfo.value.data!;

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
              actions: [
                IconButton(
                    icon: Icon(Icons.mode_edit_outlined),
                    onPressed: () {
                      Get.to(() => Profile_Update(
                            infoProfile: info,
                          ));
                    })
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                await profileController.get_Profile(loadingTime: 100);
              },
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                  children: [
                    Card(
                      shape: Border(),
                      margin: EdgeInsets.zero,
                      color: Theme.of(context).primaryColor.withAlpha(200),
                      elevation: 5,
                      shadowColor: Colors.black,
                      child: Container(
                        padding: EdgeInsetsDirectional.symmetric(vertical: 25),
                        width: double.infinity,
                        child: CircleAvatar(
                          radius: 73,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.grey.shade100,
                              child: connectApi.loading.isTrue
                                  ? Icon(Icons.person_rounded,
                                      size: 140, color: Colors.grey)
                                  : (info.profileImg != null ||
                                          info.profileImg == '')
                                      ? Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    imageDomain +
                                                        info.profileImg!),
                                                onError: (exception,
                                                        stackTrace) =>
                                                    Icon(
                                                        Icons
                                                            .broken_image_rounded,
                                                        size: 140,
                                                        color: Colors.grey)),
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
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Column(children: [
                        Info_User(
                            title: '${'fname'.tr} - ${'lname'.tr}',
                            name: "${info.firstName} ${info.lastName ?? ''}"),
                        Info_User(title: 'email'.tr, name: info.email!),
                        Info_User(title: 'phone_number'.tr, name: info.phone!),
                        Info_User(title: 'sex'.tr, name: info.sex!.tr),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
          connectApi.loading.isTrue ? Loading() : Container()
        ],
      );
    });
  }

  Widget Info_null() {
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
          body: RefreshIndicator(
            onRefresh: () async {
              await profileController.get_Profile(loadingTime: 100);
            },
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                children: [
                  Card(
                    shape: Border(),
                    margin: EdgeInsets.zero,
                    color: Theme.of(context).primaryColor.withAlpha(200),
                    elevation: 5,
                    shadowColor: Colors.black,
                    child: Container(
                      padding: EdgeInsetsDirectional.symmetric(vertical: 25),
                      width: double.infinity,
                      child: CircleAvatar(
                        radius: 73,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.grey.shade100,
                            child: Icon(Icons.person_rounded,
                                size: 140, color: Colors.grey)),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Column(children: [
                      Info_User(
                          title: '${'fname'.tr} - ${'lname'.tr}', name: ''),
                      Info_User(title: 'email'.tr, name: ''),
                      Info_User(title: 'phone_number'.tr, name: ''),
                      Info_User(title: 'sex'.tr, name: ''),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
        connectApi.loading.isTrue ? Loading() : Container()
      ],
    );
  }

  Widget Info_User({required String title, required String name}) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            title,
            style: TextStyle(color: Theme.of(context).primaryColorDark),
          ),
          subtitle: connectApi.loading.isTrue || name == ''
              ? null
              : Text(
                  name,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
        ),
        Divider(),
      ],
    );
  }
}
