// ignore_for_file: must_be_immutable
import 'package:dio/dio.dart' as dio;
import 'package:doormster/components/actions/form_error_snackbar.dart';
import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/dropdown/dropdown.dart';
import 'package:doormster/components/image/add_iamges.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/text/text_icon.dart';
import 'package:doormster/components/text_form/text_form.dart';
import 'package:doormster/controller/add_images_controller.dart';
import 'package:doormster/controller/branch_controller.dart';
import 'package:doormster/controller/complaint_controller.dart';
import 'package:doormster/models/complaint_model/complaint_type.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Add_Complaint extends StatefulWidget {
  String language;
  Add_Complaint({super.key, required this.language});

  @override
  State<Add_Complaint> createState() => _Add_ComplaintState();
}

class _Add_ComplaintState extends State<Add_Complaint> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController detail = TextEditingController();
  String branchId = branchController.branch_Id.value;
  List<DataType> listType = complaintController.type_list;
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
      return Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text('Complaint'.tr),
            ),
            body: SafeArea(
                child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textIcon(
                        'title'.tr,
                        Icon(
                          Icons.edit_document,
                          color: Theme.of(context).dividerColor,
                          size: 25,
                        ),
                      ),
                      Text_Form(
                        controller: title,
                        title: 'title'.tr,
                        // icon: Icons.person,
                        error: 'enter_title'.tr,
                        TypeInput: TextInputType.name,
                      ),
                      const SizedBox(height: 5),
                      textIcon(
                        'type'.tr,
                        Icon(
                          Icons.edit_document,
                          color: Theme.of(context).dividerColor,
                          size: 25,
                        ),
                      ),
                      Dropdown(
                        title: 'type'.tr,
                        controller: type,
                        error: 'select_type'.tr,
                        listItem: listType
                            .map((value) => widget.language == 'th'
                                ? value.label1.toString()
                                : value.label2.toString())
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            for (var item in listType) {
                              if (item.label1 == value) {
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
                        controller: detail,
                        title: 'description'.tr,
                        minLines: 3,
                        maxLines: 5,
                        error: 'enter_description'.tr,
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
                        title: 'add_image'.tr,
                        count: 1,
                      )
                    ],
                  ),
                ),
              ),
            )),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: connectApi.loading.isTrue
                ? Container()
                : Buttons(
                    title: 'save'.tr,
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
                        form_error_snackbar();
                      }
                    }),
          ),
          connectApi.loading.isTrue ? Loading() : Container()
        ],
      );
    });
  }
}
