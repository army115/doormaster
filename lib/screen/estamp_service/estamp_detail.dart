// ignore_for_file: unnecessary_null_comparison

import 'package:doormster/controller/estamp_controller/estamp_controller.dart';
import 'package:doormster/controller/estamp_controller/parking_controller.dart';
import 'package:doormster/widgets/button/button.dart';
import 'package:doormster/widgets/button/button_text_icon.dart';
import 'package:doormster/widgets/button/buttonback_appbar.dart';
import 'package:doormster/widgets/checkBox/checkbox_formfield.dart';
import 'package:doormster/widgets/loading/circle_loading.dart';
import 'package:doormster/widgets/text/text_icon.dart';
import 'package:doormster/models/estamp_models/get_parking.dart';
import 'package:doormster/style/textStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Estamp_Detail extends StatefulWidget {
  String prakingId;
  Estamp_Detail({super.key, required this.prakingId});

  @override
  State<Estamp_Detail> createState() => _Estamp_DetailState();
}

class _Estamp_DetailState extends State<Estamp_Detail> {
  final ParkingController parkingController = Get.put(ParkingController());
  final EstampController estampController = Get.put(EstampController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await parkingController.get_Parking(parkingId: widget.prakingId);
    });
  }

  @override
  void dispose() {
    parkingController.parkingInfo.value = getParking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.until((route) => route.isFirst);
        return false;
      },
      child: Obx(
        () {
          final parkingInfo = parkingController.parkingInfo.value;
          if (parkingInfo.minute != null) {
            estampController.convertTime(parkingInfo.minute!);
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('E-Stamp Details'),
              leading: button_back(() {
                Get.until((route) => route.isFirst);
              }),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'parking_details'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(thickness: 1, height: 20),
                  bodyInfo(
                      icon: Icons.timer_rounded,
                      colorIcon: Colors.blue,
                      title: "${'start_time'.tr} : ",
                      label: parkingInfo.start ?? ''),
                  bodyInfo(
                      icon: Icons.access_time_filled_rounded,
                      colorIcon: Colors.orange,
                      title: "${'current_time'.tr} : ",
                      label: parkingInfo.end ?? ''),
                  const Divider(thickness: 1, height: 20),
                  bodyInfo(
                      icon: Icons.directions_car_filled_rounded,
                      colorIcon: Colors.green,
                      title: "${'license_plate'.tr} : ",
                      label: parkingInfo.plateNum ?? ''),
                  bodyInfo(
                      icon: Icons.timelapse_rounded,
                      colorIcon: Colors.red,
                      title: "${'parking_duration'.tr} : ",
                      label:
                          "${estampController.finalHours} ${'hours'.tr} ${estampController.finalMinutes} ${'minutes'.tr}"),
                  const Divider(thickness: 1, height: 20),
                  Row(
                    children: [
                      textIcon(
                          "${'discount'.tr} : ",
                          fontWeight: FontWeight.bold,
                          Icon(
                            CupertinoIcons.tag_solid,
                            color: Get.theme.primaryColor,
                          )),
                      const SizedBox(width: 10),
                      Buttons_textIcon(
                          title: 'add_discount'.tr,
                          icon: Icons.add,
                          press: () {
                            estampController.tempSelectedDiscounts();
                            parkingController.get_Estamp(
                                parkingId: widget.prakingId);
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  return addDiscount();
                                });
                          })
                    ],
                  ),
                  discount(),
                  const SizedBox(height: 10),
                  discountHistory(),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: parkingInfo.parkingId == null
                ? Container()
                : Buttons(
                    title: 'submit'.tr,
                    width: Get.mediaQuery.size.width * 0.6,
                    press: () {
                      Map<String, dynamic> value = {
                        "parking_id": widget.prakingId,
                        "estampList": estampController.selectedDiscountsId,
                        "branch_id": "070324_881"
                      };
                      estampController.useEstamp(value);
                    }),
          );
        },
      ),
    );
  }

  Widget bodyInfo(
      {required IconData icon,
      Color? colorIcon,
      required String title,
      required String label}) {
    return Row(children: [
      textIcon(
        title,
        fontWeight: FontWeight.bold,
        Icon(
          icon,
          color: colorIcon ?? Get.theme.primaryColor,
          size: 25,
        ),
      ),
      Expanded(
          child: Text(
        textAlign: TextAlign.end,
        label,
      )),
    ]);
  }

  Widget addDiscount() {
    return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Obx(() => ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(20)),
                child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    centerTitle: false,
                    toolbarHeight: 45,
                    elevation: 0,
                    title: Text('select_discount'.tr),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: const Icon(Icons.close),
                      )
                    ],
                  ),
                  body: parkingController.isEstamp.isTrue
                      ? CircleLoading()
                      : parkingController.Estamp.isEmpty
                          ? const Center(
                              child: Opacity(
                                opacity: 0.5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      CupertinoIcons.tickets,
                                      size: 50,
                                    ),
                                    Text('ไม่มีส่วนลด'),
                                  ],
                                ),
                              ),
                            )
                          : Obx(() => ListView.builder(
                                padding: const EdgeInsets.only(bottom: 120),
                                itemCount: parkingController.Estamp.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final String? id = parkingController
                                      .Estamp[index].value!.estampId;
                                  final String? label =
                                      parkingController.Estamp[index].label;
                                  return CheckBox_FormField(
                                      title: label,
                                      value: estampController
                                          .tempSelectedDiscountsId
                                          .contains(id),
                                      onChanged: (value) =>
                                          estampController.updateSelectedItems(
                                              label!, id!, value));
                                },
                              )),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                  floatingActionButton: parkingController.Estamp.isEmpty ||
                          parkingController.isEstamp.isTrue
                      ? Container()
                      : Buttons(
                          title: 'submit'.tr,
                          width: Get.mediaQuery.size.width * 0.4,
                          press: () {
                            estampController.saveSelectedDiscounts();
                            Get.back();
                          }),
                ),
              ));
        });
  }

  Widget discount() {
    return Wrap(
      spacing: 10,
      runSpacing: 5,
      children:
          estampController.selectedDiscountsName.asMap().entries.map((entry) {
        final index = entry.key;
        final discount = entry.value;
        return Chip(
          labelStyle: textStyle.title16,
          label: Text(
            discount,
          ),
          backgroundColor: Get.theme.primaryColorLight.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Get.theme.primaryColor),
          ),
          deleteIcon: const CircleAvatar(
            backgroundColor: Colors.red,
            radius: 12,
            child: Icon(Icons.close, size: 18, color: Colors.white),
          ),
          onDeleted: () {
            estampController.removeDiscount(index);
          },
        );
      }).toList(),
    );
  }

  Widget discountHistory() {
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        textIcon(
            "${'previous_discounts'.tr} : ",
            fontWeight: FontWeight.bold,
            Icon(
              CupertinoIcons.tickets_fill,
              color: Get.theme.primaryColor,
            )),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Wrap(
            spacing: 10,
            runSpacing: 5,
            children: parkingController.EstampHistory.map((discount) {
              return Chip(
                labelStyle: textStyle.body14,
                label: Text(
                  discount.estampName!,
                ),
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
