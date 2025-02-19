import 'package:doormster/widgets/girdManu/grid_menu.dart';
import 'package:doormster/screen/security_guard/extra_page/extra_check_page.dart';
import 'package:doormster/screen/security_guard/scan_qr_check_page.dart';
import 'package:doormster/service/connected/check_connected.dart';
import 'package:doormster/service/permission/permission_camera.dart';
import 'package:doormster/service/permission/permission_location.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Extra_Round extends StatefulWidget {
  const Extra_Round({super.key});

  @override
  State<Extra_Round> createState() => _Extra_RoundState();
}

class _Extra_RoundState extends State<Extra_Round> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('check_extra_round'.tr)),
        body: Container(
          child: GridView.count(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(30),
              primary: false,
              childAspectRatio: 2,
              crossAxisSpacing: 25,
              mainAxisSpacing: 25,
              crossAxisCount: 1,
              // maxCrossAxisExtent: 400,
              children: [
                Grid_Menu(
                    title: 'by_point'.tr,
                    press: () {
                      permissionCamere(
                          context,
                          () => permissionLocation(
                              context,
                              () => checkInternet(
                                      page: ScanQR_Check(
                                    name: 'extra',
                                    roundName: 'extra_round'.tr,
                                  ))));
                    },
                    icon: Icons.qr_code_scanner_rounded),
                Grid_Menu(
                    title: 'extra_checkpoint'.tr,
                    press: () {
                      permissionCamere(
                          context,
                          () => permissionLocation(
                              context,
                              () => checkInternet(
                                    page: const Extra_Check(
                                        title: 'extra_checkpoint', type: 0),
                                  )));
                    },
                    icon: Icons.edit_calendar_outlined),
                Grid_Menu(
                    title: 'emergency'.tr,
                    press: () {
                      permissionCamere(
                          context,
                          () => permissionLocation(
                              context,
                              () => checkInternet(
                                    page: const Extra_Check(
                                        title: 'emergency', type: 1),
                                  )));
                    },
                    icon: Icons.warning_amber_rounded),
              ]),
        ));
  }
}
