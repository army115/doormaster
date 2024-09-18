// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously, sort_child_properties_last

import 'package:doormster/components/button/button_text_icon.dart';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/map/map_dialog.dart';
import 'package:doormster/components/searchbar/search_from.dart';
import 'package:doormster/components/text/text_double_colors.dart';
import 'package:doormster/components/text/text_icon.dart';
import 'package:doormster/controller/security_controller/checkpoint_controll.dart';
import 'package:doormster/models/secarity_models/get_checkpoint.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Check_Point extends StatefulWidget {
  Check_Point({Key? key}) : super(key: key);

  @override
  State<Check_Point> createState() => _Check_PointState();
}

class _Check_PointState extends State<Check_Point> {
  TextEditingController fieldText = TextEditingController();
  List<checkPoint> listCheckpoint1 = checkPointController.list_Checkpoint;
  List<checkPoint> listCheckpoint2 = checkPointController.list_Checkpoint;

  void _searchData(String text) {
    setState(() {
      listCheckpoint1 = listCheckpoint2.where((item) {
        var name = item.locationName!;
        return name.contains(text);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      checkPointController.get_checkPoint(loadingTime: 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text('list_checkpoint'.tr),
        ),
        body: connectApi.loading.isTrue
            ? Loading()
            : Column(
                children: [
                  listCheckpoint2.length > 10
                      ? Container(
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                          child: Search_From(
                            title: 'search_checkpoint'.tr,
                            searchText: fieldText,
                            clear: () {
                              setState(() {
                                fieldText.clear();
                                listCheckpoint1 = listCheckpoint2;
                              });
                            },
                            changed: (value) {
                              _searchData(value);
                            },
                          ),
                        )
                      : Container(),
                  Expanded(
                    child: listCheckpoint1.isEmpty
                        ? Logo_Opacity(title: 'no_data'.tr)
                        : RefreshIndicator(
                            onRefresh: () async {
                              await checkPointController.get_checkPoint(
                                  loadingTime: 100);
                            },
                            child: ListView.builder(
                                padding: listCheckpoint1.length > 10
                                    ? const EdgeInsets.fromLTRB(20, 0, 20, 10)
                                    : const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                itemCount: listCheckpoint1.length,
                                itemBuilder: (context, index) {
                                  final listcheckpoint =
                                      listCheckpoint1[index].checkpointList;
                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    elevation: 10,
                                    color: Colors.transparent,
                                    child: ExpansionTile(
                                        title: Text(
                                          '${'checkpoint'.tr} : ${listCheckpoint1[index].locationName}',
                                          style: Get.textTheme.bodySmall,
                                        ),
                                        subtitle: textDoubleColors(
                                            "${'status'.tr} : ",
                                            Theme.of(context).dividerColor,
                                            listCheckpoint1[index].verify == 0
                                                ? 'no_regis'.tr
                                                : 'registered'.tr,
                                            listCheckpoint1[index].verify == 0
                                                ? Colors.red
                                                : Theme.of(context)
                                                    .primaryColorDark),
                                        children: [
                                          listCheckpoint1[index].verify == 0
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
                                                          color:
                                                              Theme.of(context)
                                                                  .dividerColor,
                                                          size: 25),
                                                    ),
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      primary: false,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 3,
                                                              horizontal: 20),
                                                      itemCount: listcheckpoint
                                                          ?.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return listcheckpoint?[
                                                                        index]
                                                                    .checkpointName ==
                                                                ''
                                                            ? Container()
                                                            : Text(
                                                                '- ${listcheckpoint?[index].checkpointName}');
                                                      },
                                                    ),
                                                    listCheckpoint1[index]
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
                                                                      color: Colors
                                                                          .red,
                                                                      size: 25),
                                                                ),
                                                              ),
                                                              Buttons_textIcon(
                                                                  title:
                                                                      'view_location'
                                                                          .tr,
                                                                  buttonColor:
                                                                      Colors
                                                                          .red,
                                                                  icon:
                                                                      Icons.map,
                                                                  press: () {
                                                                    showMap_Dialog(
                                                                        context:
                                                                            context,
                                                                        vertical:
                                                                            150,
                                                                        horizontal:
                                                                            20,
                                                                        lat: listCheckpoint1[index]
                                                                            .lat!,
                                                                        lng: listCheckpoint1[index]
                                                                            .lng!,
                                                                        areaLat:
                                                                            listCheckpoint1[index]
                                                                                .lat!,
                                                                        areaLng:
                                                                            listCheckpoint1[index]
                                                                                .lng!,
                                                                        radius:
                                                                            listCheckpoint1[index].radius!);
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
