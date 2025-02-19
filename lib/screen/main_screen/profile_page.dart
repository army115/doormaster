// ignore_for_file: unrelated_type_equality_checks, prefer_const_constructors, use_build_context_synchronously, unused_import, non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doormster/widgets/image/circle_image.dart';
import 'package:doormster/widgets/loading/circle_loading.dart';
import 'package:doormster/widgets/loading/loading.dart';
import 'package:doormster/controller/main_controller/profile_controller.dart';
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

class _Profile_PageState extends State<Profile_Page> {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final profileInfo = profileController.profileInfo.value.data;

      return Scaffold(
        appBar: AppBar(
          title: Text('info'.tr),
          // leading: IconButton(
          //   icon: Icon(Icons.menu),
          //   onPressed: () {
          //     Scaffold.of(context).openDrawer();
          //   },
          // ),
          actions: [
            IconButton(
              icon: Icon(Icons.mode_edit_outlined),
              onPressed: () {
                Get.to(() => Profile_Update());
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await profileController.get_Profile(loadingTime: 100);
          },
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            child: Column(
              children: [
                Card(
                  shape: const Border(),
                  margin: EdgeInsets.zero,
                  color: Theme.of(context).primaryColor.withAlpha(200),
                  elevation: 5,
                  shadowColor: Colors.black,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    width: double.infinity,
                    child: Center(
                      child: circleImage(
                        typeImage: 'net',
                        imageProfile: profileInfo?.profileImg,
                        borderSide: 3,
                        radiusCircle: 73,
                        iconImagenull: Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 140,
                        ),
                        iconImageError: const Icon(Icons.error,
                            size: 50, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    children: [
                      Info_User(
                        title: '${'fname'.tr} - ${'lname'.tr}',
                        name:
                            "${profileInfo?.firstName ?? ''} ${profileInfo?.lastName ?? ''}",
                      ),
                      Info_User(
                        title: 'email'.tr,
                        name: profileInfo?.email ?? '',
                      ),
                      Info_User(
                        title: 'phone_number'.tr,
                        name: profileInfo?.phone ?? '',
                      ),
                      Info_User(
                        title: 'sex'.tr,
                        name: profileInfo?.sex?.tr ?? '',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
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
          subtitle:
              connectApi.loading.isTrue || name.isEmpty ? null : Text(name),
        ),
        const Divider(),
      ],
    );
  }
}
