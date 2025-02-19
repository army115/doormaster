// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart' as dio;
import 'package:doormster/models/complaint_model/complaint_type.dart';
import 'package:doormster/widgets/actions/form_error_snackbar.dart';
import 'package:doormster/widgets/button/button.dart';
import 'package:doormster/widgets/dropdown/dropdown.dart';
import 'package:doormster/widgets/image/add_images.dart';
import 'package:doormster/widgets/image/show_images.dart';
import 'package:doormster/widgets/text/text_double_colors_icon.dart';
import 'package:doormster/widgets/text/text_icon.dart';
import 'package:doormster/widgets/text_form/text_form.dart';
import 'package:doormster/controller/image_controller/add_images_controller.dart';
import 'package:doormster/controller/complaint_controller.dart';
import 'package:doormster/utils/scroll_field.dart';
import 'package:doormster/models/complaint_model/get_complaint.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Edit_Complaint extends StatefulWidget {
  final complaint_data;
  const Edit_Complaint({super.key, required this.complaint_data});

  @override
  State<Edit_Complaint> createState() => _Edit_ComplaintState();
}

class _Edit_ComplaintState extends State<Edit_Complaint> {
  final ComplaintController complaintController =
      Get.find<ComplaintController>();

  final List<GlobalKey<FormFieldState>> _fieldKeys =
      List.generate(2, (index) => GlobalKey<FormFieldState>());

  final _formkey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController detail = TextEditingController();

  Data? complaintData;
  final listimages = addImagesController.listImage;

  String image = '';
  int? dropdownSelect;

  Future get_data() async {
    complaintData = widget.complaint_data;
    title.text = complaintData!.docName!;
    detail.text = complaintData!.description!;
    image = complaintData!.complaintImg!;
    if (complaintData!.complaintType != null) {
      var typeComplaint = complaintData!.complaintType;
      for (var item in complaintController.listType.value) {
        if (item.label1 == typeComplaint) {
          if (complaintController.language == 'th') {
            type.text = item.label1!;
          } else {
            type.text = item.label2!;
          }
          dropdownSelect = item.value;
          break;
        }
      }
    }
  }

  @override
  void initState() {
    get_data();
    super.initState();
  }

  @override
  void dispose() {
    listimages.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<DataType> listType = complaintController.listType.value;
      String language = complaintController.language.value;
      return Scaffold(
        appBar: AppBar(
          title: Text('complaint'.tr),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 80),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textDoubleColorsIcon(
                      text1: 'title'.tr,
                      text2: '*',
                      color2: Colors.red,
                      icon: Icon(
                        Icons.edit_document,
                        color: Theme.of(context).dividerColor,
                        size: 25,
                      )),
                  Text_Form(
                    fieldKey: _fieldKeys[0],
                    controller: title,
                    title: 'title'.tr,
                    // icon: Icons.person,
                    error: 'enter_title'.tr,
                    TypeInput: TextInputType.name,
                  ),
                  const SizedBox(height: 5),
                  textDoubleColorsIcon(
                      text1: 'type'.tr,
                      text2: '*',
                      color2: Colors.red,
                      icon: Icon(
                        Icons.edit_document,
                        color: Theme.of(context).dividerColor,
                        size: 25,
                      )),
                  Dropdown(
                    title: 'type'.tr,
                    controller: type,
                    error: 'select_type'.tr,
                    listItem: listType
                        .map((value) => language == 'th'
                            ? value.label1.toString()
                            : value.label2.toString())
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        for (var item in listType) {
                          if (item.label1 == value || item.label2 == value) {
                            dropdownSelect = item.value;
                            debugPrint(dropdownSelect.toString());
                            break;
                          }
                        }
                        debugPrint(value);
                        type.text = value;
                      }
                    },
                  ),
                  const SizedBox(height: 5),
                  textIcon(
                    'description'.tr,
                    Icon(
                      Icons.description_rounded,
                      color: Theme.of(context).dividerColor,
                      size: 25,
                    ),
                  ),
                  Text_Form(
                    fieldKey: _fieldKeys[1],
                    controller: detail,
                    title: 'description'.tr,
                    minLines: 3,
                    maxLines: 5,
                    // error: 'enter_description'.tr,
                    TypeInput: TextInputType.name,
                  ),
                  const SizedBox(height: 5),
                  textIcon(
                    'pictures'.tr,
                    Icon(
                      Icons.camera_alt_rounded,
                      color: Theme.of(context).dividerColor,
                      size: 25,
                    ),
                  ),
                  image != ''
                      ? showImage(
                          image: image,
                          onPrass: () {
                            setState(() {
                              image = '';
                            });
                          })
                      : Add_Image(
                          count: 1,
                        )
                ],
              ),
            ),
          ),
        )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: connectApi.loading.isTrue
            ? Container()
            : Buttons(
                title: 'save'.tr,
                width: Get.mediaQuery.size.width * 0.5,
                press: () async {
                  List<dio.MultipartFile> files = [];
                  for (int i = 0; i < listimages.length; i++) {
                    files.add(await dio.MultipartFile.fromFile(
                      listimages[i].path,
                      filename: listimages[i].name,
                    ));
                  }

                  if (_formkey.currentState!.validate()) {
                    Map<String, dynamic> values = {};
                    values['doc_id'] = complaintData!.docId;
                    values['doc_name'] = title.text;
                    values['complaint_type'] = dropdownSelect;
                    values['description'] = detail.text;
                    if (files.isNotEmpty) {
                      values['complaintImg'] = files;
                    } else if (image == '') {
                      values['complaintImg'] = null;
                    }
                    complaintController.edit_Complaint(values);
                  } else {
                    for (var key in _fieldKeys) {
                      if (!key.currentState!.validate()) {
                        scrollToField(key);
                        break;
                      }
                    }
                    form_error_snackbar();
                  }
                }),
      );
    });
  }
}
