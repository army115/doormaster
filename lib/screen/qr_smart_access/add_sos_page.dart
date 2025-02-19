// ignore_for_file: unnecessary_null_comparison

import 'package:dio/dio.dart' as dio;
import 'package:doormster/controller/location_controller.dart';
import 'package:doormster/widgets/actions/form_error_snackbar.dart';
import 'package:doormster/widgets/button/button.dart';
import 'package:doormster/widgets/image/add_images.dart';
import 'package:doormster/widgets/map/map_page.dart';
import 'package:doormster/widgets/text/text_double_colors_icon.dart';
import 'package:doormster/widgets/text/text_icon.dart';
import 'package:doormster/widgets/text_form/text_form.dart';
import 'package:doormster/controller/image_controller/add_images_controller.dart';
import 'package:doormster/controller/main_controller/branch_controller.dart';
import 'package:doormster/utils/scroll_field.dart';
import 'package:doormster/controller/sos_controller.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Add_SOS extends StatefulWidget {
  const Add_SOS({super.key});
  @override
  State<Add_SOS> createState() => _Add_SOSState();
}

class _Add_SOSState extends State<Add_SOS> {
  final SOSController sosController = Get.find<SOSController>();
  final LocationController locationController = Get.put(LocationController());

  final List<GlobalKey<FormFieldState>> _fieldKeys =
      List.generate(2, (index) => GlobalKey<FormFieldState>());

  final _formkey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController detail = TextEditingController();
  String branchId = branchController.branch_Id.value;
  final listimages = addImagesController.listImage;

  @override
  void dispose() {
    listimages.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: const Text('SOS'),
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
                  ),
                  const SizedBox(height: 5),
                  PhysicalModel(
                    borderRadius: BorderRadius.circular(10),
                    elevation: 3,
                    color: Colors.transparent,
                    child: ExpansionTile(
                      backgroundColor: Colors.white,
                      collapsedBackgroundColor: Colors.white,
                      iconColor: Colors.black,
                      collapsedIconColor: Colors.black,
                      tilePadding: EdgeInsets.zero,
                      title: textIcon(
                        'current_position'.tr,
                        color: Colors.black,
                        Icon(
                          Icons.location_on_sharp,
                          size: 25,
                          color: Colors.red.shade600,
                        ),
                      ),
                      children: [
                        locationController.lat == null
                            ? Container()
                            : Map_Page(
                                lat: locationController.lat.value,
                                lng: locationController.lng.value,
                                myLocation: true,
                                width: double.infinity,
                                height: 300,
                              )
                      ],
                    ),
                  ),
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
                    values['latitude'] = locationController.lat.value;
                    values['longitude'] = locationController.lng.value;
                    values['description'] = detail.text;
                    values['branch_id'] = branchId;
                    values['imgPath'] = files;
                    sosController.add_SOS(values);
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
