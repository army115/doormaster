import 'package:doormster/components/list_logo_opacity/logo_opacity.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/map/map_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:intl/intl.dart';
import 'dart:convert' as convert;

class Record_Point extends StatefulWidget {
  final listPoint;
  Record_Point({Key? key, this.listPoint}) : super(key: key);

  @override
  State<Record_Point> createState() => _Record_PointState();
}

class _Record_PointState extends State<Record_Point> {
  var companyId;
  bool loading = false;
  DateFormat formatTime = DateFormat.Hm();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final listLogs = widget.listPoint;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text('บันทึกจุดตรวจ')),
          body: loading
              ? Container()
              : SafeArea(
                  child: listLogs.isEmpty
                      ? Logo_Opacity()
                      : SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: listLogs.length,
                                itemBuilder: (context, index) {
                                  DateTime time = DateTime.parse(
                                      '${listLogs[index].checktimeReal}');
                                  final listpoint = listLogs[index].checkpoint;
                                  final checkpoint = listpoint[0].checklist;
                                  final listPic = listLogs[index].pic;
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    elevation: 10,
                                    child: Container(
                                      child: ExpansionTile(
                                          textColor: Colors.black,
                                          title: Text(
                                              'จุดตรวจ :  ${listpoint[0].checkpointName}'),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  'เหตุการณ์ : ${listLogs[index].event}'),
                                              Text(
                                                  'วันที่ ${listLogs[index].date} เวลา ${formatTime.format(time)}'),
                                            ],
                                          ),
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(10),
                                                      bottomRight: Radius.circular(
                                                          10)), // Set the border radius here
                                                  color: Colors.grey.shade200),
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 10, 10, 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.task_rounded,
                                                          size: 25),
                                                      SizedBox(width: 5),
                                                      Text('รายการตรวจ'),
                                                    ],
                                                  ),
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    primary: false,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5,
                                                            horizontal: 20),
                                                    itemCount:
                                                        checkpoint?.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return checkpoint?[index]
                                                                  .checklist ==
                                                              ''
                                                          ? Container()
                                                          : Text(
                                                              '- ${checkpoint?[index].checklist}');
                                                    },
                                                  ),
                                                  // listLogs[index].desciption !=
                                                  //         ''
                                                  //     ?
                                                  Row(
                                                    children: [
                                                      Icon(
                                                          Icons
                                                              .description_rounded,
                                                          size: 25),
                                                      SizedBox(width: 5),
                                                      Text(
                                                          'รายละเอียดเพิ่มเติม'),
                                                    ],
                                                  ),
                                                  // : Container(),
                                                  // listLogs[index].desciption !=
                                                  //         ''
                                                  //     ?
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20,
                                                        vertical: 3),
                                                    child: Text(
                                                      '- ${listLogs[index].desciption}',
                                                    ),
                                                  ),
                                                  // : Container(),

                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .photo_library_rounded,
                                                        size: 30,
                                                        color: Colors.black,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Expanded(
                                                          child: Text(
                                                              'รูปภาพการตรวจ')),
                                                      button(
                                                          'ดูรูปภาพ',
                                                          Theme.of(context)
                                                              .primaryColor,
                                                          Icons.photo, () {
                                                        showImages(listPic);
                                                      })
                                                    ],
                                                  ),
                                                  SizedBox(height: 3),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on_sharp,
                                                        size: 30,
                                                        color:
                                                            Colors.red.shade600,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Expanded(
                                                          child: Text(
                                                              'ตำแหน่งที่ตรวจ')),
                                                      button(
                                                          'ดูตำแหน่ง',
                                                          Colors.red.shade600,
                                                          Icons.map, () {
                                                        showMap(
                                                            listLogs[index]
                                                                .lat!,
                                                            listLogs[index]
                                                                .lng!);
                                                      })
                                                    ],
                                                  ),
                                                  // SizedBox(height: 5),
                                                  // Map_Page(
                                                  //   lat: listLogs[index].lat!,
                                                  //   lng: listLogs[index].lng!,
                                                  //   width: double.infinity,
                                                  //   height: 200,
                                                  // )
                                                ],
                                              ),
                                            ),
                                          ]),
                                    ),
                                  );
                                }),
                          ),
                        )),
        ),
        loading ? Loading() : Container()
      ],
    );
  }

  void showImages(listImages) {
    showDialog(
        useRootNavigator: true,
        context: context,
        builder: (_) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(vertical: 180, horizontal: 30),
              child: listImages.isEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported_rounded,
                              size: 50,
                            ),
                            Text('ไม่มีรูปภาพ')
                          ]),
                    )
                  : Swiper(
                      pagination: const SwiperPagination(
                          builder: DotSwiperPaginationBuilder(
                              size: 8,
                              activeSize: 8,
                              color: Colors.grey,
                              activeColor: Colors.white)),
                      control: const SwiperControl(
                          color: Colors.white,
                          iconPrevious: Icons.arrow_back_ios_new_rounded,
                          iconNext: Icons.arrow_forward_ios_rounded),
                      itemCount: listImages.length,
                      itemBuilder: (context, index) {
                        var _Images = convert.base64Decode(
                            ('${listImages[index]}').split(',').last);
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              _Images,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
            ));
  }

  void showMap(lat, lng) {
    showDialog(
        useRootNavigator: true,
        context: context,
        builder: (_) => Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(vertical: 180, horizontal: 30),
              child: Map_Page(
                width: double.infinity,
                height: double.infinity,
                lat: lat,
                lng: lng,
              ),
            ));
  }

  Widget button(name, color, icon, press) {
    return ElevatedButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      ),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 3),
          Text(
            name,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
          ),
        ],
      ),
      onPressed: press,
    );
  }
}
