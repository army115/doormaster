import 'package:dio/dio.dart' as dio;
import 'package:doormster/components/actions/form_error_snackbar.dart';
import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/dropdown/dropdown.dart';
import 'package:doormster/components/image/add_iamges.dart';
import 'package:doormster/components/image/show_images.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/text/text_icon.dart';
import 'package:doormster/components/text_form/text_form.dart';
import 'package:doormster/controller/add_images_controller.dart';
import 'package:doormster/controller/complaint_controller.dart';
import 'package:doormster/models/complaint_model/complaint_type.dart';
import 'package:doormster/models/complaint_model/get_complaint.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Edit_Complaint extends StatefulWidget {
  final complaint_data;
  String language;
  Edit_Complaint(
      {super.key, required this.complaint_data, required this.language});

  @override
  State<Edit_Complaint> createState() => _Edit_ComplaintState();
}

class _Edit_ComplaintState extends State<Edit_Complaint> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController detail = TextEditingController();
  Data? complaintData;
  RxList<DataType> listType = complaintController.type_list;
  final listimages = addImagesController.listImage;

  String image = '';
  int? dropdownSelect;

  Future get_data() async {
    complaintData = widget.complaint_data;
    title.text = complaintData!.docName!;
    detail.text = complaintData!.description!;
    image = complaintData!.complaintImg!;
    type.text = complaintData!.complaintType!;
    for (var item in listType) {
      if (item.label1 == type.text) {
        dropdownSelect = item.value;
        break;
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
                        values['doc_id'] = complaintData!.docId;
                        values['doc_name'] = title.text;
                        values['complaint_type'] = dropdownSelect;
                        values['description'] = detail.text;
                        if (files.isNotEmpty) {
                          values['complaintImg'] = files;
                        }
                        complaintController.edit_Complaint(values);
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
