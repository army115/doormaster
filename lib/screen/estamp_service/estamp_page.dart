import 'package:doormster/widgets/bottombar/navigation_ids.dart';
import 'package:doormster/widgets/girdManu/grid_menu.dart';
import 'package:doormster/controller/estamp_controller/store_controller.dart';
import 'package:doormster/screen/estamp_service/estamp_logs.dart';
import 'package:doormster/screen/estamp_service/scan_qr_estamp.dart';
import 'package:doormster/service/connected/check_connected.dart';
import 'package:doormster/service/permission/permission_camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Estamp_Page extends StatefulWidget {
  const Estamp_Page({super.key});

  @override
  _Estamp_PageState createState() => _Estamp_PageState();
}

class _Estamp_PageState extends State<Estamp_Page> {
  final StoreController storeController = Get.put(StoreController());

  @override
  void dispose() {
    Get.delete<StoreController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Stamp'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GridView.count(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(30),
            primary: false,
            childAspectRatio: 2,
            crossAxisSpacing: 25,
            mainAxisSpacing: 25,
            crossAxisCount: 1,
            children: [
              Grid_Menu(
                  title: 'Scan E-Stamp',
                  press: () {
                    permissionCamere(
                      context,
                      () => checkInternet(page: const Scan_Estamp()),
                    );
                  },
                  icon: CupertinoIcons.doc_text_viewfinder),
              // Grid_Menu(
              //     title: 'E-Stamp details',
              //     press: () {
              //       checkInternet(
              //         page: Estamp_Detail(
              //           prakingId: 'PK_2408300001',
              //         ),
              //       );
              //     },
              //     icon: CupertinoIcons.doc_plaintext),
              Grid_Menu(
                  title: 'E-Stamp logs',
                  press: () {
                    checkInternet(
                        page: const Estamp_Logs(),
                        navigationId: NavigationIds.home);
                  },
                  icon: CupertinoIcons.doc_plaintext),
            ],
          )
        ],
      ),
    );
  }
}
