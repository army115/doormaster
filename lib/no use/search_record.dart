
  // Future _getCheckPoint() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   companyId = prefs.getString('companyId');
  //   print('companyId: ${companyId}');

  //   try {
  //     //call api
  //     var url = '${Connect_api().domain}/get/checkpoint/${companyId}';
  //     var response = await Dio().get(
  //       url,
  //       options: Options(headers: {
  //         'Connect-type': 'application/json',
  //         'Accept': 'application/json',
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       getChecklist checklist = getChecklist.fromJson(response.data);
  //       setState(() {
  //         listLength = checklist.data?.length;
  //         print(checklist.data?.length);
  //       });
  //     }
  //   } catch (error) {
  //     print(error);
  //   }
  // }

// Padding(
//                         padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
//                         child: Search_Calendar(
//                           title: 'ค้นหา',
//                           fieldText: fieldText,
//                           ontap: () {
//                             calendar(context);
//                           },
                          // changed: (value) {
                          //   _getLog(_startDateText!, _endDateText!);
                          // _searchData(value);
                          // },
                          // clear: () {
                          //   setState(() {
                          //     fieldText.text == '';
                          //   });
                          //   fieldText.clear();
                          //   _getLogs();
                          // }
                      //   ),
                      // ),
// RichText(
                                            //   text: TextSpan(
                                            //       style: TextStyle(
                                            //           fontSize: 20,
                                            //           fontFamily: 'Prompt'),
                                            //       children: [
                                            //         TextSpan(
                                            //             text: 'สถานะ : ',
                                            //             style: TextStyle(
                                            //               color: Colors.black,
                                            //             )),
                                            //         if (listLog[index]
                                            //                 .fileList!
                                            //                 .length ==
                                            //             listLength) ...[
                                            //           TextSpan(
                                            //               text: 'ตรวจแล้ว',
                                            //               style: TextStyle(
                                            //                 color: Colors.green,
                                            //               ))
                                            //         ] else if (listLog[index]
                                            //                 .fileList!
                                            //                 .length <=
                                            //             0) ...[
                                            //           TextSpan(
                                            //               text: 'ยังไม่ตรวจ',
                                            //               style: TextStyle(
                                            //                 color: Colors.red,
                                            //               ))
                                            //         ] else if (listLog[index]
                                            //                 .fileList!
                                            //                 .length <
                                            //             listLength!) ...[
                                            //           TextSpan(
                                            //               text: 'ตรวจไม่ครบ',
                                            //               style: TextStyle(
                                            //                 color:
                                            //                     Colors.orange,
                                            //               ))
                                            //         ],
                                            //       ]),
                                            // ),

                                            // Expanded(
                      //   child: listlogs.isEmpty
                      //       ? Logo_Opacity()
                      //       : ListView.builder(
                      //           padding: EdgeInsets.symmetric(
                      //               horizontal: 20, vertical: 5),
                      //           // shrinkWrap: true,
                      //           // primary: false,
                      //           // reverse: true
                      //           itemCount: listlogs.length,
                      //           itemBuilder: ((context, index) {
                      //             DateTime time = DateTime.parse(
                      //                 '${listlogs[index].checktimeReal}');
                      //             return Card(
                      //               shape: RoundedRectangleBorder(
                      //                   borderRadius:
                      //                       BorderRadius.circular(10)),
                      //               margin: EdgeInsets.symmetric(vertical: 5),
                      //               elevation: 10,
                      //               child: InkWell(
                      //                 borderRadius: BorderRadius.circular(10),
                      //                 child: Container(
                      //                   padding: EdgeInsets.all(10),
                      //                   child: Column(
                      //                     crossAxisAlignment:
                      //                         CrossAxisAlignment.start,
                      //                     children: [
                      //                       Text(
                      //                         'เหตุการณ์ : ${listlogs[index].event}',
                      //                         overflow: TextOverflow.ellipsis,
                      //                       ),
                      //                       Text(
                      //                         'เพิ่มเติม : ${listlogs[index].desciption}',
                      //                         overflow: TextOverflow.ellipsis,
                      //                       ),
                      //                       Text(
                      //                         'วันที่ : ${listlogs[index].date} เวลา : ${formatTime.format(time)}',
                      //                         overflow: TextOverflow.ellipsis,
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ),
                      //             );
                      //           })),
                      // ),