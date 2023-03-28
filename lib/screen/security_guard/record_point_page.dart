import 'package:doormster/components/list_logo_opacity/logo_opacity.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/map/map_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                                                  listLogs[index].desciption !=
                                                          ''
                                                      ? Row(
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .description_rounded,
                                                                size: 25),
                                                            SizedBox(width: 5),
                                                            Text(
                                                                'รายละเอียดเพิ่มเติม'),
                                                          ],
                                                        )
                                                      : Container(),
                                                  listLogs[index].desciption !=
                                                          ''
                                                      ? Text(
                                                          ' - ${listLogs[index].desciption}')
                                                      : Container(),
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
                                                        EdgeInsets.fromLTRB(
                                                            20, 5, 20, 5),
                                                    itemCount:
                                                        listpoint?.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      final checkpoint =
                                                          listpoint[index]
                                                              .checklist;
                                                      return checkpoint?[index]
                                                                  .checklist ==
                                                              ''
                                                          ? Container()
                                                          : Text(
                                                              '- ${checkpoint?[index].checklist}');
                                                    },
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on_sharp,
                                                        size: 30,
                                                        color:
                                                            Colors.red.shade600,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                          'ตำแหน่งจุดตรวจที่บันทึก'),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5),
                                                  // Map_Page(
                                                  //   lat: listPoint[index].lat!,
                                                  //   lng: listPoint[index].lng!,
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
}
