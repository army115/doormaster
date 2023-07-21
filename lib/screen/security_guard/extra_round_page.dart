import 'package:doormster/components/girdManu/grid_menu.dart';
import 'package:doormster/screen/security_guard/extra_check_page.dart';
import 'package:doormster/screen/security_guard/scan_qr_check_page.dart';
import 'package:doormster/service/check_connected.dart';
import 'package:doormster/service/permission/permission_camera.dart';
import 'package:doormster/service/permission/permission_location.dart';
import 'package:flutter/material.dart';

class Extra_Round extends StatefulWidget {
  const Extra_Round({super.key});

  @override
  State<Extra_Round> createState() => _Extra_RoundState();
}

class _Extra_RoundState extends State<Extra_Round> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('ตรวจนอกรอบ')),
        body: Container(
          child: GridView.extent(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(30),
              primary: false,
              childAspectRatio: 2,
              crossAxisSpacing: 25,
              mainAxisSpacing: 25,
              maxCrossAxisExtent: 400,
              children: [
                Grid_Menu(
                    title: 'ตรวจตามจุด',
                    press: () {
                      permissionCamere(
                          context,
                          () => permissionLocation(
                              context,
                              () => checkInternet(
                                    context,
                                    ScanQR_Check(
                                      name: 'extra',
                                      roundName: 'นอกรอบ',
                                    ),
                                    true,
                                  )));
                    },
                    icon: Icons.qr_code_scanner_rounded),
                Grid_Menu(
                    title: 'ตรวจนอกจุด',
                    press: () {
                      permissionCamere(
                          context,
                          () => permissionLocation(
                              context,
                              () => checkInternet(
                                    context,
                                    const Extra_Check(
                                        title: 'ตรวจนอกจุด', type: 0),
                                    true,
                                  )));
                    },
                    icon: Icons.edit_calendar_outlined),
                Grid_Menu(
                    title: 'เหตุฉุกเฉิน',
                    press: () {
                      permissionCamere(
                          context,
                          () => permissionLocation(
                              context,
                              () => checkInternet(
                                    context,
                                    const Extra_Check(
                                        title: 'เหตุฉุกเฉิน', type: 1),
                                    true,
                                  )));
                    },
                    icon: Icons.warning_amber_rounded),
              ]),
        ));
  }
}
