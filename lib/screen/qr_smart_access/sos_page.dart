import 'package:doormster/components/button/button_text_icon.dart';
import 'package:doormster/components/calendar/calendar.dart';
import 'package:doormster/components/image/dialog_images.dart';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/searchbar/search_calendar.dart';
import 'package:doormster/components/searchbar/search_from.dart';
import 'package:doormster/components/text/text_icon.dart';
import 'package:doormster/controller/sos_controller.dart';
import 'package:doormster/models/complaint_model/get_sos.dart';
import 'package:doormster/screen/qr_smart_access/add_sos_page.dart';
import 'package:doormster/screen/qr_smart_access/edit_sos_page.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/permission/permission_location.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SOS_Page extends StatefulWidget {
  const SOS_Page({super.key});

  @override
  State<SOS_Page> createState() => _SOS_PageState();
}

class _SOS_PageState extends State<SOS_Page> {
  TextEditingController fieldText = TextEditingController();
  TextEditingController searchText = TextEditingController();

  List<Data> listSOS1 = sosController.listSOS_All;
  List<Data> listSOS2 = sosController.listSOS_All;

  ScrollController scrollController = ScrollController();
  int count = 6;
  bool _hasMore = false;

  List<DateTime?> listDate = [DateTime.now()];
  String startDate = '';
  String endDate = '';

  Future onGoBack() async {
    sosController.get_SOS(
        start_date: startDate, end_date: endDate, loadingTime: 0);
  }

  void _searchData(String text) {
    setState(() {
      listSOS1 = listSOS2.where((item) {
        var name = item.docName ?? '';
        var createDate = createformat(item.createDate, 'D');
        var status = item.status ?? '';
        return name.contains(text) ||
            createDate.contains(text) ||
            status.contains(text);
      }).toList();
    });
  }

  String createformat(fullDate, String type) {
    if (type == 'D') {
      DateFormat formatDate = DateFormat('dd-MM-y');
      return formatDate.format(DateTime.parse(fullDate));
    } else {
      DateFormat formatTime = DateFormat('HH:mm');
      return formatTime.format(DateTime.parse(fullDate));
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await sosController.get_SOS(
          start_date: '', end_date: '', loadingTime: 100);
    });
    scrollController.addListener(
      () async {
        if (scrollController.position.pixels ==
                scrollController.position.maxScrollExtent &&
            !_hasMore) {
          if (mounted) {
            setState(() {
              _hasMore = true;
            });
          }
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) {
            setState(() {
              count = count + 2;
              _hasMore = false;
            });
          }
        }
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SOS')),
      body: Obx(() => Scaffold(
            body: connectApi.loading.isTrue
                ? Loading()
                : Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                        child: Column(
                          children: [
                            Search_Calendar(
                              title: 'pick_date'.tr,
                              fieldText: fieldText,
                              ontap: () async {
                                await CalendarPicker_2Date(
                                        context: context, listDate: listDate)
                                    .then(
                                  (value) async {
                                    if (value != null) {
                                      setState(() {
                                        startDate = value['startDate'];
                                        endDate = value['endDate'];
                                        fieldText.text = value['showDate'];
                                        listDate = value['listDate'];
                                      });
                                      await sosController.get_SOS(
                                          start_date: startDate,
                                          end_date: endDate,
                                          loadingTime: 100);
                                    }
                                  },
                                );
                              },
                              clear: () async {
                                fieldText.clear();
                                await sosController.get_SOS(
                                    start_date: '',
                                    end_date: '',
                                    loadingTime: 0);
                                setState(() {
                                  startDate = '';
                                  endDate = '';
                                  listDate = [DateTime.now()];
                                });
                              },
                            ),
                            listSOS2.length > 10
                                ? Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: DottedLine(
                                          direction: Axis.horizontal,
                                          alignment: WrapAlignment.center,
                                          lineLength: double.infinity,
                                          lineThickness: 2,
                                          dashColor: Colors.grey.shade600,
                                          dashGapColor: Colors.white,
                                        ),
                                      ),
                                      Search_From(
                                        title: 'search'.tr,
                                        searchText: searchText,
                                        clear: () {
                                          setState(() {
                                            searchText.clear();
                                            listSOS1 = listSOS2;
                                          });
                                        },
                                        changed: (value) {
                                          _searchData(value);
                                        },
                                      ),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      Expanded(
                          child: listSOS1.isEmpty
                              ? Logo_Opacity(title: 'data_not_found'.tr)
                              : RefreshIndicator(
                                  onRefresh: () async {
                                    sosController.get_SOS(
                                        start_date: startDate,
                                        end_date: endDate,
                                        loadingTime: 100);
                                  },
                                  child: ListView.builder(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 80),
                                      controller: scrollController,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      itemCount: count < listSOS1.length
                                          ? count + (_hasMore ? 1 : 0)
                                          : listSOS1.length,
                                      itemBuilder: ((context, index) {
                                        if (index >= count) {
                                          return const Padding(
                                            padding: EdgeInsets.only(top: 20),
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          );
                                        }
                                        return listSOS1[index].statusId == 4
                                            ? Container()
                                            : Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5),
                                                elevation: 10,
                                                child: ExpansionTile(
                                                    title: Text(
                                                      '${'title'.tr} : ${listSOS1[index].docName}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    subtitle: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${'date'.tr} ${createformat(listSOS1[index].createDate!, 'D')} ${'time'.tr} ${createformat(listSOS1[index].createDate!, 'T')}',
                                                        ),
                                                        Text(
                                                          '${'status'.tr} : ${"${listSOS1[index].status}".tr}'
                                                              .tr,
                                                        ),
                                                      ],
                                                    ),
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              textIcon(
                                                                  'description'
                                                                      .tr,
                                                                  Icon(
                                                                    Icons
                                                                        .description_rounded,
                                                                    size: 25,
                                                                    color: Get
                                                                        .theme
                                                                        .dividerColor,
                                                                  )),
                                                              Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          20,
                                                                      vertical:
                                                                          3),
                                                                  child: listSOS1[index]
                                                                              .description !=
                                                                          ''
                                                                      ? Text(
                                                                          '- ${listSOS1[index].description}',
                                                                        )
                                                                      : const Text(
                                                                          '-')),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                  child: textIcon(
                                                                      'pictures'.tr,
                                                                      Icon(
                                                                        Icons
                                                                            .photo_library_rounded,
                                                                        size:
                                                                            25,
                                                                        color: Theme.of(context)
                                                                            .dividerColor,
                                                                      ))),
                                                              Buttons_textIcon(
                                                                  title:
                                                                      'view_pictures'
                                                                          .tr,
                                                                  icon: Icons
                                                                      .photo,
                                                                  press: () {
                                                                    showImages_Dialog(
                                                                        context:
                                                                            context,
                                                                        listImages:
                                                                            listSOS1[index].imgPath);
                                                                  }),
                                                            ],
                                                          ),
                                                          listSOS1[index].statusId !=
                                                                      1 &&
                                                                  listSOS1[index]
                                                                          .statusId !=
                                                                      2
                                                              ? Container()
                                                              : Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    Buttons_textIcon(
                                                                        title: 'edit'
                                                                            .tr,
                                                                        icon: Icons
                                                                            .mode_edit_outlined,
                                                                        press:
                                                                            () {
                                                                          Navigator.of(context, rootNavigator: true)
                                                                              .push(MaterialPageRoute(
                                                                                  builder: (context) => Edit_SOS(
                                                                                        sos_data: listSOS1[index],
                                                                                      )))
                                                                              .then(
                                                                                (value) => onGoBack(),
                                                                              );
                                                                        }),
                                                                    Buttons_textIcon(
                                                                        title: 'delete'
                                                                            .tr,
                                                                        textColor:
                                                                            Colors
                                                                                .white,
                                                                        buttonColor: Colors
                                                                            .red
                                                                            .shade600,
                                                                        icon: Icons
                                                                            .delete_forever_rounded,
                                                                        press:
                                                                            () {
                                                                          sosController.updateStatus_SOS(
                                                                              doc_id: listSOS1[index].docId);
                                                                        }),
                                                                  ],
                                                                )
                                                        ],
                                                      )
                                                    ]));
                                      })),
                                )),
                    ],
                  ),
          )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Get.theme.primaryColorDark,
        onPressed: () {
          permissionLocation(
              context,
              () => Navigator.of(
                    context,
                    rootNavigator: true,
                  ).push(MaterialPageRoute(
                    builder: (context) => const Add_SOS(),
                  )));
        },
        child: Icon(
          Icons.add,
          color: Get.textTheme.bodyLarge!.color,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
