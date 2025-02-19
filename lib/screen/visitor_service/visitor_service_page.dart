import 'package:doormster/screen/visitor_service/emp_opendoor_page.dart';
import 'package:doormster/screen/visitor_service/cars_type_page.dart';
import 'package:doormster/widgets/girdManu/grid_menu.dart';
import 'package:doormster/screen/visitor_service/scan_idcard_page.dart';
import 'package:doormster/screen/visitor_service/scan_qr_doors.dart';
import 'package:doormster/screen/visitor_service/visitor_idcard_page.dart';
import 'package:doormster/service/connected/check_connected.dart';
import 'package:doormster/service/permission/permission_camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Visitor_Service extends StatefulWidget {
  const Visitor_Service({super.key});

  @override
  State<Visitor_Service> createState() => _Visitor_ServiceState();
}

class _Visitor_ServiceState extends State<Visitor_Service> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visitor'),
      ),
      body: GridView.count(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(30),
        primary: false,
        childAspectRatio: 2,
        crossAxisSpacing: 25,
        mainAxisSpacing: 25,
        crossAxisCount: 1,
        children: [
          // Grid_Menu(
          //     title: 'Scan IDCard',
          //     press: () {
          //       permissionCamere(
          //         context,
          //         () => checkInternet(page: const Scan_IDCard()),
          //       );
          //     },
          //     icon: Icons.document_scanner_outlined),
          // Grid_Menu(
          //     title: 'Form IDCard',
          //     press: () {
          //       Get.to(() => const Visitor_IDCard());
          //     },
          //     icon: Icons.contact_page_rounded),
          // Grid_Menu(
          //     title: 'Open door',
          //     press: () {
          //       checkInternet(
          //         page: Emp_Opendoor(
          //           codeNumber: '012',
          //         ),
          //       );
          //     },
          //     icon: Icons.meeting_room_rounded),
          Grid_Menu(
              title: 'เข้า',
              color: Theme.of(context).primaryColor,
              press: () {
                checkInternet(
                  page: const CarsTypePage(),
                );
              },
              icon: Icons.input_rounded),
          Grid_Menu(
              color: Colors.red,
              title: 'ออก',
              press: () {
                checkInternet(
                  page: const ScanQRDoors(),
                );
              },
              icon: Icons.output_rounded),
        ],
      ),
    );
  }
}
