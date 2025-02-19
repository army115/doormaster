// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, unused_import, non_constant_identifier_names

import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/widgets/loading/loading.dart';
import 'package:doormster/widgets/text/text_double_colors.dart';
import 'package:doormster/models/secarity_models/get_round_all.dart'
    as new_round;
import 'package:doormster/models/secarity_models/get_round_now.dart'
    as get_round_now;
import 'package:doormster/screen/security_guard/checkin_addpoint_page/add_checkpoint_page.dart';
import 'package:doormster/screen/security_guard/checkin_addpoint_page/check_in_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scan/scan.dart';

class ScanQR_Check extends StatefulWidget {
  final name;
  final roundId;
  final roundName;
  final roundStart;
  final roundEnd;
  final page;
  final inspectDetail;
  final logs;
  const ScanQR_Check(
      {Key? key,
      this.name,
      this.roundId,
      this.roundName,
      this.roundStart,
      this.roundEnd,
      this.page,
      this.inspectDetail,
      this.logs})
      : super(key: key);

  @override
  State<ScanQR_Check> createState() => _ScanQR_CheckState();
}

class _ScanQR_CheckState extends State<ScanQR_Check> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  ScanController scanController = ScanController();
  bool open = true;
  bool loading = false;
  Position? position;
  List<get_round_now.InspectDetail> inspectDetail_Now = [];
  List<new_round.InspectDetail> inspectDetail_Round = [];
  List<get_round_now.Logs> logs = [];

  Future getLocation() async {
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (error) {
      if (kDebugMode) {
        debugPrint("error: $error");
      }
      Get.back();
    }
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.until((route) => route.isFirst);
        return false;
      },
      child: Stack(
        children: [
          Scaffold(
            body: Stack(
              alignment: Alignment.center,
              children: [
                // QRView(
                //   key: qrKey,
                //   onQRViewCreated: _onQRViewCreated,
                //   overlay: QrScannerOverlayShape(
                //     borderColor: Colors.red,
                //     borderRadius: 10,
                //     borderLength: 30,
                //     borderWidth: 10,
                //   ),
                // ),
                ScanView(
                  controller: scanController,
                  scanAreaScale: .7,
                  scanLineColor: Colors.green,
                  onCapture: (data) {
                    scanController.pause();
                    _checkQRcode(data);
                  },
                ),
                Positioned(
                    top: Get.mediaQuery.size.height * 0.05,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Text('${'scan'.tr} QR Code',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)))),
                Positioned(
                  left: 10,
                  top: Get.mediaQuery.size.height * 0.05,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white30),
                    child: IconButton(
                        color: Colors.white,
                        iconSize: 30,
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(Icons.arrow_back_ios_new_rounded)),
                  ),
                ),
                Positioned(
                    right: 15,
                    top: Get.mediaQuery.size.height * 0.04,
                    child: IconButton(
                      onPressed: () async {
                        await controller?.toggleFlash();
                        setState(() {
                          open = !open;
                        });
                      },
                      icon: open
                          ? Icon(Icons.flash_off_rounded,
                              color: Colors.grey, size: 40)
                          : Icon(
                              Icons.flash_on_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                    )),
              ],
            ),
          ),
          loading ? Loading() : Container()
        ],
      ),
    );
  }

  void _checkQRcode(result) {
    if (widget.name == 'check') {
      logs = widget.logs;
      //เช็คตรวจจุดซ้ำ
      bool checkLogsid = logs.any((element) => element.checkpointId == result);
      //เช็คจุดตรวจไม่ตรงรอบ
      bool? checkInspectdetail;
      if (widget.page == 'now') {
        inspectDetail_Now = widget.inspectDetail;
        checkInspectdetail =
            inspectDetail_Now.any((element) => element.checkpointId == result);
      } else {
        inspectDetail_Round = widget.inspectDetail;
        checkInspectdetail = inspectDetail_Round
            .any((element) => element.checkpointId == result);
      }

      if (widget.roundId == null) {
        dialogOnebutton_Subtitle(
            title: 'occur_error'.tr,
            subtitle: 'check_later'.tr,
            icon: Icons.highlight_off_rounded,
            colorIcon: Colors.red,
            textButton: 'ok'.tr,
            press: () {
              Get.until((route) => route.isFirst);
            },
            click: false,
            backBtn: false,
            willpop: false);
      } else if (checkLogsid) {
        dialogOnebutton_Subtitle(
            title: 'repeat_checkpoint'.tr,
            subtitle: 'data_checkpoint'.tr,
            icon: Icons.warning_amber_rounded,
            colorIcon: Colors.orange,
            textButton: 'ok'.tr,
            press: () {
              Get.until((route) => route.isFirst);
            },
            click: false,
            backBtn: false,
            willpop: false);
      } else if (!checkInspectdetail) {
        dialogOnebutton_Subtitle(
            title: 'checkpoint_found'.tr,
            subtitle: 'checkpoint_found_round'.tr,
            icon: Icons.warning_amber_rounded,
            colorIcon: Colors.orange,
            textButton: 'ok'.tr,
            press: () {
              Get.until((route) => route.isFirst);
            },
            click: false,
            backBtn: false,
            willpop: false);
      } else {
        debugPrint("result : $result");
        Get.to(() => Check_In(
            title: 'checkIn'.tr,
            checkpointId: '$result',
            lat: position?.latitude,
            lng: position?.longitude,
            roundId: widget.roundId,
            roundName: widget.roundName,
            roundStart: widget.roundStart,
            roundEnd: widget.roundEnd));
      }
    } else if (widget.name == 'extra') {
      Get.to(() => Check_In(
          title: 'check_extra_round'.tr,
          checkpointId: '$result',
          roundName: widget.roundName,
          lat: position?.latitude,
          lng: position?.longitude));
    } else if (widget.name == 'add') {
      Get.to(() => Add_CheckPoint(
          timeCheck: DateTime.now(),
          checkpointId: '$result',
          lat: position?.latitude,
          lng: position?.longitude));
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        controller.pauseCamera();
      });

      if (widget.name == 'check') {
        logs = widget.logs;
        //เช็คตรวจจุดซ้ำ
        bool checkLogsid =
            logs.any((element) => element.checkpointId == result?.code);
        //เช็คจุดตรวจไม่ตรงรอบ
        bool? checkInspectdetail;
        if (widget.page == 'now') {
          inspectDetail_Now = widget.inspectDetail;
          checkInspectdetail = inspectDetail_Now
              .any((element) => element.checkpointId == result?.code);
        } else {
          inspectDetail_Round = widget.inspectDetail;
          checkInspectdetail = inspectDetail_Round
              .any((element) => element.checkpointId == result?.code);
        }

        if (widget.roundId == null) {
          dialogOnebutton_Subtitle(
              title: 'occur_error'.tr,
              subtitle: 'check_later'.tr,
              icon: Icons.highlight_off_rounded,
              colorIcon: Colors.red,
              textButton: 'ok'.tr,
              press: () {
                Get.until((route) => route.isFirst);
              },
              click: false,
              backBtn: false,
              willpop: false);
        } else if (checkLogsid) {
          dialogOnebutton_Subtitle(
              title: 'repeat_checkpoint'.tr,
              subtitle: 'data_checkpoint'.tr,
              icon: Icons.warning_amber_rounded,
              colorIcon: Colors.orange,
              textButton: 'ok'.tr,
              press: () {
                Get.until((route) => route.isFirst);
              },
              click: false,
              backBtn: false,
              willpop: false);
        } else if (!checkInspectdetail) {
          dialogOnebutton_Subtitle(
              title: 'checkpoint_found'.tr,
              subtitle: 'checkpoint_found_round'.tr,
              icon: Icons.warning_amber_rounded,
              colorIcon: Colors.orange,
              textButton: 'ok'.tr,
              press: () {
                Get.until((route) => route.isFirst);
              },
              click: false,
              backBtn: false,
              willpop: false);
        } else {
          debugPrint("result : ${result?.code}");
          Get.to(() => Check_In(
              title: 'checkIn'.tr,
              checkpointId: '${result?.code}',
              lat: position?.latitude,
              lng: position?.longitude,
              roundId: widget.roundId,
              roundName: widget.roundName,
              roundStart: widget.roundStart,
              roundEnd: widget.roundEnd));
        }
      } else if (widget.name == 'extra') {
        Get.to(() => Check_In(
            title: 'check_extra_round'.tr,
            checkpointId: '${result?.code}',
            roundName: widget.roundName,
            lat: position?.latitude,
            lng: position?.longitude));
      } else if (widget.name == 'add') {
        Get.to(() => Add_CheckPoint(
            timeCheck: DateTime.now(),
            checkpointId: '${result?.code}',
            lat: position?.latitude,
            lng: position?.longitude));
      }
    });
  }
}
