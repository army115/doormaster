import 'dart:developer';

import 'package:doormster/controller/image_controller/qrcode_controller.dart';
import 'package:doormster/controller/visitor_controller/visitor_controller.dart';
import 'package:doormster/widgets/button/button.dart';
import 'package:doormster/widgets/button/buttonback_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ConfirmVisitor extends StatefulWidget {
  const ConfirmVisitor({super.key});

  @override
  State<ConfirmVisitor> createState() => _ConfirmVisitorState();
}

class _ConfirmVisitorState extends State<ConfirmVisitor> {
  QRCodeController qrCodeController = Get.put(QRCodeController());
  final VisitorController visitorController = Get.put(VisitorController());
  var format = DateFormat('dd/MM/y');
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      visitorController.get_Visitor(
          loadingTime: 100, qrcode: qrCodeController.result.value);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.until((route) => route.isFirst);
        return false;
      },
      child: Obx(() {
        final visitorInfo = visitorController.visitorInfo.value.data;
        log(visitorInfo.toString());
        return Scaffold(
          appBar: AppBar(
            title: Text('visitor'.tr),
            leading: button_back(() {
              Get.until((route) => route.isFirst);
            }),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await visitorController.get_Visitor(
                  loadingTime: 100, qrcode: qrCodeController.result.value);
            },
            child: SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                width: double.infinity,
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      shadowColor: Colors.black38,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'visitor_info'.tr,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Divider(),
                            UserInfoRow(
                                label: 'visitor_name'.tr,
                                value: visitorInfo?.visitorName ?? ''),
                            UserInfoRow(
                                label: 'meet_name'.tr,
                                value: visitorInfo?.meetName ?? ''),
                            UserInfoRow(
                                label: 'license_plate'.tr,
                                value: visitorInfo?.plateNum ?? ''),
                            UserInfoRow(
                                label: 'phone_number'.tr,
                                value: visitorInfo?.phone ?? ''),
                            // UserInfoRow(
                            //     label: 'house_number'.tr,
                            //     value: visitorInfo?.houseId ?? ''),
                            UserInfoRow(
                              label: 'start_date'.tr,
                              value: visitorInfo?.startDate != null
                                  ? format.format(DateTime.parse(
                                      visitorInfo?.startDate ?? ''))
                                  : '',
                            ),
                            UserInfoRow(
                              label: 'end_date'.tr,
                              value: visitorInfo?.endDate != null
                                  ? format.format(DateTime.parse(
                                      visitorInfo?.endDate ?? ''))
                                  : '',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Buttons(
              title: 'ยืนยันการเข้าพบ'.tr,
              width: Get.mediaQuery.size.width * 0.5,
              press: () async {
                var qrcode = int.tryParse(qrCodeController.result.value);
                visitorController.stamp_Visitor(
                    loadingTime: 100, qrcode: qrcode);
              }),
        );
      }),
    );
  }

  Widget UserInfoRow({
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$label :",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Get.theme.dividerColor),
            ),
            Expanded(
              child: Text(
                textAlign: TextAlign.end,
                value,
              ),
            ),
          ],
        ),
        const Divider(height: 20),
      ],
    );
  }
}
