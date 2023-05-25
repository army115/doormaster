// ignore_for_file: avoid_unnecessary_containers, must_be_immutable, unused_import
import 'package:flutter/material.dart';

class DoorOnline extends StatefulWidget {
  String name;
  final press;
  String devSn;
  String devMac;
  String appKey;
  bool valueDoor;
  DoorOnline(
      {Key? key,
      required this.name,
      required this.press,
      required this.devSn,
      required this.valueDoor,
      required this.devMac,
      required this.appKey});

  @override
  State<DoorOnline> createState() => _DoorOnlineState();
}

class _DoorOnlineState extends State<DoorOnline> {
  // void _loadStatusAutoDoors() async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     var DoorAuto = prefs.getBool("autoDoor") ?? false;
  //     print('autoDoor : $DoorAuto');
  //     if (DoorAuto) {
  //       setState(() {
  //         widget.valueDoor = true;
  //         // _CallJavaSDK(widget.valueDoor);
  //       });
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<void> checkLocationStatus(value) async {
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   try {
  //     if (value == true) {
  //       Position position = await Geolocator.getCurrentPosition(
  //           desiredAccuracy: LocationAccuracy.high);
  //     }
  //     await CallNativeJava(value, widget.devSn, widget.devMac, widget.appKey);
  //     setState(() {
  //       widget.valueDoor = value;
  //       print("autoDoor : $value");
  //     });

  //     // SharedPreferences prefs = await SharedPreferences.getInstance();
  //     // await prefs.setBool("autoDoor", value);
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // _loadStatusAutoDoors();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
          title: Text(widget.name,
              style: TextStyle(
                fontSize: 20,
              )),
          trailing: ElevatedButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                elevation: 5,
              ),
              child: Wrap(
                children: [
                  Icon(
                    Icons.meeting_room_rounded,
                    size: 30,
                  ),
                  Text(
                    'เปิดประตู',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              onPressed: widget.press),
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          title: Row(
            children: [
              widget.valueDoor
                  ? Icon(Icons.meeting_room_rounded,
                      size: 30, color: Theme.of(context).primaryColor)
                  : Icon(
                      Icons.door_front_door,
                      size: 30,
                      color: Colors.grey,
                    ),
              Text('เปิดประตูอัตโนมัติ',
                  style: TextStyle(
                      fontSize: 20,
                      color: widget.valueDoor == false
                          ? Colors.grey
                          : Theme.of(context).primaryColor)),
            ],
          ),
          trailing: Transform.scale(
            scale: 1.5,
            child: Switch(
              value: widget.valueDoor,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (bool value) async {
                // checkLocationStatus(value);
              },
            ),
          ),
        ),
      ],
    );
  }
}



  // Future _getDoorDevice() async {
  //   try {
  //     setState(() {
  //       loading = true;
  //     });

  //     //call api device
  //     var url = '${Connect_api().domain}/getdeviceuuidmobile/$deviceId';
  //     var res = await Dio().get(
  //       url,
  //       options: Options(headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //       }),
  //     );

  //     if (res.statusCode == 200) {
  //       DoorsDeviece deviceDoors = DoorsDeviece.fromJson(res.data);

  //       setState(() {
  //         listDevice = deviceDoors.lists!;
  //         loading = false;
  //       });
  //     }
  //   } catch (error) {
  //     print(error);

  //     dialogOnebutton_Subtitle(
  //         context,
  //         'พบข้อผิดพลาด',
  //         'ไม่สามารถเชื่อมต่อได้ กรุณาลองใหม่อีกครั้ง',
  //         Icons.warning_amber_rounded,
  //         Colors.orange,
  //         'ตกลง', () {
  //       Navigator.popUntil(context, (route) => route.isFirst);
  //     }, false, false);

  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }



    // Future _getDoorWeigan() async {
  //   try {
  //     setState(() {
  //       loading = true;
  //     });

  //     //call api Weigan
  //     var urlWeigan =
  //         '${Connect_api().domain}/get/weigan_group_id/$weiganId/$companyId';
  //     var response = await Dio().get(
  //       urlWeigan,
  //       options: Options(headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       getDoorWeigan DoorsWeigan = getDoorWeigan.fromJson(response.data);
  //       setState(() {
  //         listWeigan = DoorsWeigan.data!;
  //         loading = false;
  //       });
  //       // วน loop เพื่อดึง Det จากแต่ละ DataWeigan
  //       for (int i = 0; i < listWeigan.length; i++) {
  //         // เก็บ List Det จาก DataWeigan ลงในตัวแปร listdet
  //         listdet?.addAll(listWeigan[i].det!);
  //       }
  //     }
  //   } catch (error) {
  //     print(error);

  //     dialogOnebutton_Subtitle(
  //         context,
  //         'พบข้อผิดพลาด',
  //         'ไม่สามารถเชื่อมต่อได้ กรุณาลองใหม่อีกครั้ง',
  //         Icons.warning_amber_rounded,
  //         Colors.orange,
  //         'ตกลง', () {
  //       Navigator.popUntil(context, (route) => route.isFirst);
  //     }, false, false);

  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }