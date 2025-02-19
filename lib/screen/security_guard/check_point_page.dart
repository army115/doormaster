// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously, sort_child_properties_last

import 'package:doormster/widgets/button/button_text_icon.dart';
import 'package:doormster/widgets/list_null_opacity/logo_opacity.dart';
import 'package:doormster/widgets/map/map_dialog.dart';
import 'package:doormster/widgets/searchbar/search_from.dart';
import 'package:doormster/widgets/text/text_double_colors.dart';
import 'package:doormster/widgets/text/text_icon.dart';
import 'package:doormster/controller/security_controller/checkpoint_controll.dart';
import 'package:doormster/models/secarity_models/get_checkpoint.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Check_Point extends StatefulWidget {
  Check_Point({Key? key}) : super(key: key);

  @override
  State<Check_Point> createState() => _Check_PointState();
}

class _Check_PointState extends State<Check_Point> {
  final CheckPointController checkPointController =
      Get.put(CheckPointController());
  TextEditingController fieldText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text('list_checkpoint'.tr),
        ),
        body: Column(
          children: [
            checkPointController.filterCheckpoint.length > 10
                ? Container(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                    child: Search_From(
                      title: 'search_checkpoint'.tr,
                      searchText: fieldText,
                      clear: () {
                        setState(() {
                          fieldText.clear();
                          checkPointController.listCheckpoint
                              .assignAll(checkPointController.filterCheckpoint);
                        });
                      },
                      changed: (value) {
                        checkPointController.searchData(value);
                      },
                    ),
                  )
                : Container(),
            Expanded(
              child: checkPointController.listCheckpoint.isEmpty
                  ? Logo_Opacity(title: 'no_data'.tr)
                  : RefreshIndicator(
                      onRefresh: () async {
                        await checkPointController.get_checkPoint(
                            loadingTime: 100);
                      },
                      child: ListView.builder(
                          padding:
                              checkPointController.listCheckpoint.length > 10
                                  ? const EdgeInsets.fromLTRB(15, 0, 15, 10)
                                  : const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                          itemCount: checkPointController.listCheckpoint.length,
                          itemBuilder: (context, index) {
                            final listcheckpoint = checkPointController
                                .listCheckpoint[index].checkpointList;
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              elevation: 10,
                              color: Colors.transparent,
                              child: ExpansionTile(
                                  title: Text(
                                    '${'checkpoint'.tr} : ${checkPointController.listCheckpoint[index].locationName}',
                                    style: Get.textTheme.bodySmall,
                                  ),
                                  subtitle: textDoubleColors(
                                      text1: "${'status'.tr} : ",
                                      text2: checkPointController
                                                  .listCheckpoint[index]
                                                  .verify ==
                                              0
                                          ? 'no_regis'.tr
                                          : 'registered'.tr,
                                      color2: checkPointController
                                                  .listCheckpoint[index]
                                                  .verify ==
                                              0
                                          ? Colors.red
                                          : Theme.of(context).primaryColorDark),
                                  children: [
                                    checkPointController
                                                .listCheckpoint[index].verify ==
                                            0
                                        ? textIcon(
                                            'no_regis_checkpoint'.tr,
                                            const Icon(
                                              Icons.warning_rounded,
                                              size: 25,
                                              color: Colors.orange,
                                            ))
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              textIcon(
                                                'checklist'.tr,
                                                Icon(Icons.task_rounded,
                                                    color: Theme.of(context)
                                                        .dividerColor,
                                                    size: 25),
                                              ),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                primary: false,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 3,
                                                    horizontal: 20),
                                                itemCount:
                                                    listcheckpoint?.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return listcheckpoint?[index]
                                                              .checkpointName ==
                                                          ''
                                                      ? Container()
                                                      : Text(
                                                          '- ${listcheckpoint?[index].checkpointName}');
                                                },
                                              ),
                                              checkPointController
                                                          .listCheckpoint[index]
                                                          .verify ==
                                                      0
                                                  ? Container()
                                                  : Row(
                                                      children: [
                                                        Expanded(
                                                          child: textIcon(
                                                            'checkpoint_location'
                                                                .tr,
                                                            const Icon(
                                                                Icons
                                                                    .location_on_sharp,
                                                                color:
                                                                    Colors.red,
                                                                size: 25),
                                                          ),
                                                        ),
                                                        Buttons_textIcon(
                                                            title:
                                                                'view_location'
                                                                    .tr,
                                                            buttonColor:
                                                                Colors.red,
                                                            icon: Icons.map,
                                                            press: () {
                                                              showMap_Dialog(
                                                                  context:
                                                                      context,
                                                                  vertical: 150,
                                                                  horizontal:
                                                                      20,
                                                                  lat: checkPointController
                                                                      .listCheckpoint[
                                                                          index]
                                                                      .lat!,
                                                                  lng: checkPointController
                                                                      .listCheckpoint[
                                                                          index]
                                                                      .lng!,
                                                                  areaLat: checkPointController
                                                                      .listCheckpoint[
                                                                          index]
                                                                      .lat!,
                                                                  areaLng: checkPointController
                                                                      .listCheckpoint[
                                                                          index]
                                                                      .lng!,
                                                                  radius: checkPointController
                                                                      .listCheckpoint[
                                                                          index]
                                                                      .radius!);
                                                            })
                                                      ],
                                                    ),
                                            ],
                                          ),
                                  ]),
                            );
                          }),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
