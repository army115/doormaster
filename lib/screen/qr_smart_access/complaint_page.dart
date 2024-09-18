import 'package:doormster/components/button/button_text_icon.dart';
import 'package:doormster/components/calendar/calendar.dart';
import 'package:doormster/components/image/dialog_images.dart';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/searchbar/search_calendar.dart';
import 'package:doormster/components/searchbar/search_from.dart';
import 'package:doormster/components/text/text_icon.dart';
import 'package:doormster/controller/complaint_controller.dart';
import 'package:doormster/models/complaint_model/get_complaint.dart';
import 'package:doormster/screen/qr_smart_access/add_complaint_page.dart';
import 'package:doormster/screen/qr_smart_access/edit_complaint_page.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Complaint_Page extends StatefulWidget {
  const Complaint_Page({super.key});

  @override
  State<Complaint_Page> createState() => _Complaint_PageState();
}

class _Complaint_PageState extends State<Complaint_Page> {
  TextEditingController fieldText = TextEditingController();
  TextEditingController searchText = TextEditingController();

  List<Data> listComplaint1 = complaintController.listComplaint_All;
  List<Data> listComplaint2 = complaintController.listComplaint_All;

  ScrollController scrollController = ScrollController();
  int count = 6;
  bool _hasMore = false;

  List<DateTime?> listDate = [DateTime.now()];
  String? startDate = '';
  String? endDate = '';
  String? language = '';

  Future onGoBack() async {
    complaintController.get_ComplaintAll(
        start_date: startDate, end_date: endDate, loadingTime: 0);
  }

  void _searchData(String text) {
    setState(() {
      listComplaint1 = listComplaint2.where((item) {
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
      final prefs = await SharedPreferences.getInstance();
      language = prefs.getString('language');
      await complaintController.get_TypeComplaint();
      await complaintController.get_ComplaintAll(
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
    return Obx(() => Scaffold(
          appBar: AppBar(elevation: 0, title: Text('complaint_list'.tr)),
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
                                    await complaintController.get_ComplaintAll(
                                        start_date: startDate,
                                        end_date: endDate,
                                        loadingTime: 100);
                                  }
                                },
                              );
                            },
                            clear: () async {
                              fieldText.clear();
                              await complaintController.get_ComplaintAll(
                                  start_date: '', end_date: '', loadingTime: 0);
                              setState(() {
                                startDate = '';
                                endDate = '';
                                listDate = [DateTime.now()];
                              });
                            },
                          ),
                          listComplaint2.length > 10
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
                                          listComplaint1 = listComplaint2;
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
                        child: listComplaint1.isEmpty
                            ? Logo_Opacity(title: 'data_not_found'.tr)
                            : RefreshIndicator(
                                onRefresh: () async {
                                  complaintController.get_ComplaintAll(
                                      start_date: startDate,
                                      end_date: endDate,
                                      loadingTime: 100);
                                },
                                child: ListView.builder(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 0, 20, 80),
                                    controller: scrollController,
                                    itemCount: count < listComplaint1.length
                                        ? count + (_hasMore ? 1 : 0)
                                        : listComplaint1.length,
                                    itemBuilder: (context, index) {
                                      if (index >= count) {
                                        return const Padding(
                                          padding: EdgeInsets.only(top: 20),
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        );
                                      }
                                      return listComplaint1[index].statusId == 6
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
                                                    '${'title'.tr} : ${listComplaint1[index].docName}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${'date'.tr} ${createformat(listComplaint1[index].createDate!, 'D')} ${'time'.tr} ${createformat(listComplaint1[index].createDate!, 'T')}',
                                                      ),
                                                      Text(
                                                        '${'status'.tr} : ${"${listComplaint1[index].statusId}cp".tr}'
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
                                                                child: listComplaint1[index]
                                                                            .description !=
                                                                        ''
                                                                    ? Text(
                                                                        '- ${listComplaint1[index].description}',
                                                                      )
                                                                    : const Text(
                                                                        '-')),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: textIcon(
                                                                    'pictures'
                                                                        .tr,
                                                                    Icon(
                                                                      Icons
                                                                          .photo_library_rounded,
                                                                      size: 25,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .dividerColor,
                                                                    ))),
                                                            Buttons_textIcon(
                                                                title:
                                                                    'view_pictures'
                                                                        .tr,
                                                                icon:
                                                                    Icons.photo,
                                                                press: () {
                                                                  showImages_Dialog(
                                                                      context:
                                                                          context,
                                                                      listImages:
                                                                          listComplaint1[index]
                                                                              .complaintImg);
                                                                })
                                                          ],
                                                        ),
                                                        listComplaint1[index]
                                                                    .statusId !=
                                                                1
                                                            ? Container()
                                                            : Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Buttons_textIcon(
                                                                      title:
                                                                          'edit'
                                                                              .tr,
                                                                      icon: Icons
                                                                          .mode_edit_outlined,
                                                                      press:
                                                                          () {
                                                                        Navigator.of(context,
                                                                                rootNavigator: true)
                                                                            .push(MaterialPageRoute(
                                                                              builder: (context) => Edit_Complaint(
                                                                                complaint_data: listComplaint1[index],
                                                                                language: language!,
                                                                              ),
                                                                            ))
                                                                            .then(
                                                                              (value) => onGoBack(),
                                                                            );
                                                                      }),
                                                                  Buttons_textIcon(
                                                                      title:
                                                                          'cancel'
                                                                              .tr,
                                                                      textColor:
                                                                          Colors
                                                                              .white,
                                                                      buttonColor:
                                                                          Colors
                                                                              .red
                                                                              .shade600,
                                                                      icon: Icons
                                                                          .delete_forever_rounded,
                                                                      press:
                                                                          () {
                                                                        complaintController.updateStatus_Complaint(
                                                                            doc_id: listComplaint1[index]
                                                                                .docId,
                                                                            status:
                                                                                6,
                                                                            succress:
                                                                                'cancel_success',
                                                                            fail:
                                                                                'cancel_unsuccess');
                                                                      }),
                                                                ],
                                                              ),
                                                        listComplaint1[index]
                                                                    .statusId !=
                                                                5
                                                            ? Container()
                                                            : Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      'resolved'
                                                                          .tr,
                                                                      style: const TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 40,
                                                                    child: Buttons_textIcon(
                                                                        title: 'close'.tr,
                                                                        textColor: Colors.white,
                                                                        buttonColor: Colors.green,
                                                                        icon: Icons.check_circle,
                                                                        press: () {
                                                                          complaintController.updateStatus_Complaint(
                                                                              doc_id: listComplaint1[index].docId,
                                                                              status: 5,
                                                                              succress: 'close_success',
                                                                              fail: 'close_unsuccess');
                                                                        }),
                                                                  ),
                                                                ],
                                                              ),
                                                      ],
                                                    )
                                                  ]));
                                    }),
                              )),
                  ],
                ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Get.theme.primaryColorDark,
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                  builder: (context) => Add_Complaint(
                        language: language!,
                      )));
            },
            child: Icon(
              Icons.add,
              color: Get.textTheme.bodyLarge!.color,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ));
  }
}
