// ignore_for_file: must_be_immutable
import 'package:dio/dio.dart' as dio;
import 'package:doormster/widgets/actions/form_error_snackbar.dart';
import 'package:doormster/widgets/button/button.dart';
import 'package:doormster/widgets/dropdown/dropdown.dart';
import 'package:doormster/widgets/image/add_images.dart';
import 'package:doormster/widgets/text/text_double_colors.dart';
import 'package:doormster/widgets/text/text_double_colors_icon.dart';
import 'package:doormster/widgets/text/text_icon.dart';
import 'package:doormster/widgets/text_form/text_form.dart';
import 'package:doormster/controller/image_controller/add_images_controller.dart';
import 'package:doormster/controller/main_controller/branch_controller.dart';
import 'package:doormster/controller/complaint_controller.dart';
import 'package:doormster/utils/scroll_field.dart';
import 'package:doormster/models/complaint_model/complaint_type.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Add_Complaint extends StatefulWidget {
  const Add_Complaint({
    super.key,
  });

  @override
  State<Add_Complaint> createState() => _Add_ComplaintState();
}

class _Add_ComplaintState extends State<Add_Complaint> {
  final ComplaintController complaintController =
      Get.find<ComplaintController>();
  final _formkey = GlobalKey<FormState>();
  final List<GlobalKey<FormFieldState>> _fieldKeys =
      List.generate(2, (index) => GlobalKey<FormFieldState>());
  TextEditingController title = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController detail = TextEditingController();
  String branchId = branchController.branch_Id.value;

  final listimages = addImagesController.listImage;
  var dropdownSelect;

  @override
  void dispose() {
    listimages.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<DataType> listType = complaintController.listType;
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
                            break;
                          }
                        }
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
                    'add_image'.tr,
                    Icon(
                      Icons.camera_alt_rounded,
                      color: Theme.of(context).dividerColor,
                      size: 25,
                    ),
                  ),
                  Add_Image(
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
                    values['doc_name'] = title.text;
                    values['complaint_type'] = dropdownSelect;
                    values['description'] = detail.text;
                    values['branch_id'] = branchId;
                    values['complaintImg'] = files;
                    complaintController.add_Complaint(values);
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
