// ignore_for_file: non_constant_identifier_names

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:doormster/controller/visitor_controller/create_visitor_controller.dart';
import 'package:doormster/controller/visitor_controller/scan_idcard_controller.dart';
import 'package:doormster/screen/visitor_service/scan_idcard_page.dart';
import 'package:doormster/screen/visitor_service/show_qrcode_page.dart';
import 'package:doormster/service/connected/check_connected.dart';
import 'package:doormster/service/permission/permission_camera.dart';
import 'package:doormster/widgets/actions/form_error_snackbar.dart';
import 'package:doormster/widgets/button/button.dart';
import 'package:doormster/widgets/button/button_close.dart';
import 'package:doormster/widgets/dropdown/dropdonw_%20search_request.dart';
import 'package:doormster/widgets/text/text_double_colors.dart';
import 'package:doormster/widgets/text_form/text_form.dart';
import 'package:doormster/widgets/text_form/text_form_number.dart';
import 'package:doormster/controller/image_controller/add_images_controller.dart';
import 'package:doormster/controller/main_controller/branch_controller.dart';
import 'package:doormster/utils/scroll_field.dart';
import 'package:doormster/controller/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Visitor_IDCard extends StatefulWidget {
  final carsType;
  final purpose;
  const Visitor_IDCard({super.key, this.carsType, this.purpose});

  @override
  State<Visitor_IDCard> createState() => _Visitor_IDCardState();
}

class _Visitor_IDCardState extends State<Visitor_IDCard> {
  final ScanIDCardController scanIDCardController =
      Get.put(ScanIDCardController());
  final ScrollController _scrollController = ScrollController();
  final _formkey = GlobalKey<FormState>();
  final List<GlobalKey<FormFieldState>> _fieldKeys =
      List.generate(7, (index) => GlobalKey<FormFieldState>());
  final GlobalKey _dropKeys = GlobalKey();

  final meetName = TextEditingController();
  final plateNum = TextEditingController();
  final phone = TextEditingController();
  DateTime dateNow = DateTime.now();
  DateFormat format = DateFormat('y-MM-dd');

  var fileImage = addImagesController.listImage;
  Uint8List? imageProfile;
  String houseId = '';
  String houseNumber = '';
  String branchId = branchController.branch_Id.value;
  bool loading = false;

  // void get_data() {
  //   idCard.text = scanIDCardController.idCard.value;
  //   title.text = scanIDCardController.titleName.value;
  //   visitorName.text = scanIDCardController.name.value;
  //   imageProfile = scanIDCardController.imageIDCard.value;
  // }

  @override
  void dispose() {
    fileImage.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // get_data();
      return Scaffold(
        appBar: AppBar(title: Text('create_visitor'.tr)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _button(),
        body: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Form(
              key: _formkey,
              child: Container(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('card_image'.tr),
                    const SizedBox(height: 10),
                    squareButtons(),
                    const SizedBox(height: 15),
                    textDoubleColors(
                        text1: 'place_meet'.tr, text2: '*', color2: Colors.red),
                    Dropdonw_searchRequest(
                      fieldKey: _dropKeys,
                      futureRequest: searchController.get_HouseData,
                      title: 'search_house'.tr,
                      error: 'select_place'.tr,
                      onChanged: (value) {
                        houseId = value.split(' :').first;
                        houseNumber = value.split(': ').last;
                      },
                    ),
                    textDoubleColors(
                        text1: 'license_plate'.tr,
                        text2: '*',
                        color2: Colors.red),
                    Text_Form(
                      fieldKey: _fieldKeys[4],
                      controller: plateNum,
                      title: 'license_plate'.tr,
                      error: 'enter_plate'.tr,
                      TypeInput: TextInputType.name,
                    ),
                    textDoubleColors(
                        text1: 'idCard'.tr, text2: '*', color2: Colors.red),
                    TextForm_Number(
                      fieldKey: _fieldKeys[0],
                      controller: scanIDCardController.idCard,
                      title: 'idCard'.tr,
                      type: TextInputType.number,
                      maxLength: 13,
                      error: (values) {
                        if (values.isEmpty) {
                          return 'enter_idcard'.tr;
                        } else if (values.length < 13) {
                          return "idcard_13char".tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    textDoubleColors(
                        text1: 'title_name'.tr, text2: '*', color2: Colors.red),
                    Text_Form(
                      fieldKey: _fieldKeys[1],
                      controller: scanIDCardController.titleName,
                      title: 'title_name'.tr,
                      error: 'enter_titlename_pls'.tr,
                      TypeInput: TextInputType.name,
                    ),
                    textDoubleColors(
                        text1: 'visitor_name'.tr,
                        text2: '*',
                        color2: Colors.red),
                    Text_Form(
                      fieldKey: _fieldKeys[2],
                      controller: scanIDCardController.name,
                      title: 'fullname'.tr,
                      error: 'enter_name_pls'.tr,
                      TypeInput: TextInputType.name,
                    ),
                    textDoubleColors(
                        text1: 'meet_name'.tr, text2: '*', color2: Colors.red),
                    Text_Form(
                      fieldKey: _fieldKeys[3],
                      controller: meetName,
                      title: 'fullname'.tr,
                      error: 'enter_name_contacts'.tr,
                      TypeInput: TextInputType.name,
                    ),
                    Text('phone'.tr),
                    TextForm_Number(
                      fieldKey: _fieldKeys[5],
                      controller: phone,
                      title: 'phone_number'.tr,
                      type: TextInputType.phone,
                      maxLength: 10,
                      error: (values) {
                        // if (values.isEmpty) {
                        //   return 'enter_phone'.tr;
                        // } else
                        if (values.length > 0 && values.length < 10) {
                          return "phone_10char".tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _button() {
    return Buttons(
        title: 'submit'.tr,
        width: Get.mediaQuery.size.width * 0.5,
        press: () async {
          if (_formkey.currentState!.validate()) {
            log('${widget.purpose}');
            List<String> data_visitor = [
              scanIDCardController.titleName.text +
                  scanIDCardController.name.text,
              meetName.text,
              phone.text,
              houseNumber,
              plateNum.text,
              widget.purpose,
              DateFormat('dd-MM-y').format(dateNow),
              DateFormat('dd-MM-y').format(dateNow.add(const Duration(days: 1)))
            ];
            Map<String, dynamic> values = {};
            values['branch_id'] = branchId;
            values['idCard'] = scanIDCardController.idCard.text;
            values['title_id'] = scanIDCardController.titleName.text;
            values['visitor_name'] = scanIDCardController.name.text;
            values['meet_name'] = meetName.text;
            values['phone'] = phone.text;
            values['start_date'] = format.format(dateNow);
            values['end_date'] =
                format.format(dateNow.add(const Duration(days: 1)));
            values['plate_num'] = plateNum.text;
            values['house_id'] = houseId;
            values['description'] = widget.purpose;
            // if (fileImage.isNotEmpty) {
            //   final files = await dio.MultipartFile.fromFile(
            //     fileImage.last.path,
            //     filename: fileImage.last.name,
            //   );
            //   values['profileImg'] = files.length;
            // }
            Get.to(() => Show_QRcode(
                  visitordData: data_visitor,
                  qr_code: '13',
                  // code_number: code_number.toString(),
                ));
            // debugPrint(values.toString());
            // createVisitorController.createVisitor_byGuard(
            //     value: values, data_visitor: data_visitor);
          } else {
            for (var key in _fieldKeys) {
              if (!key.currentState!.validate()) {
                scrollToField(key);
                break;
              } else {
                scrollToField(_dropKeys);
              }
            }
            form_error_snackbar();
          }
        });
  }

  Widget squareButtons() {
    return Wrap(
      children: [
        fileImage.isNotEmpty
            ? Stack(
                children: [
                  Image.file(
                    File(addImagesController.listImage[0].path),
                    fit: BoxFit.cover,
                    width: 250,
                    height: 250,
                  ),
                  closeButton(
                    radius: 15,
                    onPress: () {
                      addImagesController.listImage.clear();
                    },
                  )
                ],
              )
            : ElevatedButton(
                onPressed: () {
                  addImagesController.selectImages(ImageSource.camera);
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(130, 130),
                  backgroundColor: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.camera_alt_rounded,
                      size: 30,
                      color: Colors.black,
                    ),
                    Text(
                      "cap_idcard".tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
        const SizedBox(width: 20),
        scanIDCardController.image.value.path.isNotEmpty
            ? Stack(
                children: [
                  Image.file(
                    File(scanIDCardController.image.value.path),
                    fit: BoxFit.cover,
                    width: 250,
                    height: 250,
                  ),
                  closeButton(
                    radius: 15,
                    onPress: () {
                      scanIDCardController.image.value = XFile("");
                    },
                  )
                ],
              )
            : ElevatedButton(
                onPressed: () {
                  permissionCamere(
                    context,
                    () => checkInternet(page: const Scan_IDCard()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(130, 130),
                  backgroundColor: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.document_scanner_rounded,
                      size: 30,
                      color: Colors.black,
                    ),
                    Text(
                      "ocr_idcard".tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
