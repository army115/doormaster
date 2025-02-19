// ignore_for_file: non_constant_identifier_names
import 'package:dio/dio.dart' as dio;
import 'package:doormster/widgets/actions/form_error_snackbar.dart';
import 'package:doormster/widgets/button/button.dart';
import 'package:doormster/widgets/image/add_images.dart';
import 'package:doormster/widgets/image/show_images.dart';
import 'package:doormster/widgets/map/map_page.dart';
import 'package:doormster/widgets/text/text_double_colors_icon.dart';
import 'package:doormster/widgets/text/text_icon.dart';
import 'package:doormster/widgets/text_form/text_form.dart';
import 'package:doormster/controller/image_controller/add_images_controller.dart';
import 'package:doormster/utils/scroll_field.dart';
import 'package:doormster/controller/sos_controller.dart';
import 'package:doormster/models/complaint_model/get_sos.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Edit_SOS extends StatefulWidget {
  final sos_data;
  const Edit_SOS({super.key, this.sos_data});

  @override
  State<Edit_SOS> createState() => _Edit_SOSState();
}

class _Edit_SOSState extends State<Edit_SOS> {
  final SOSController sosController = Get.find<SOSController>();

  final List<GlobalKey<FormFieldState>> _fieldKeys =
      List.generate(2, (index) => GlobalKey<FormFieldState>());

  final _formkey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController detail = TextEditingController();
  Data? sosData;
  double? lat;
  double? lng;
  final listimages = addImagesController.listImage;
  String image = '';

  Future get_data() async {
    sosData = widget.sos_data;
    title.text = sosData!.docName!;
    detail.text = sosData!.description!;
    image = sosData!.imgPath!;
    lat = sosData!.latitude;
    lng = sosData!.longitude;
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
                        Icon(
                          Icons.location_on_sharp,
                          size: 25,
                          color: Colors.red.shade600,
                        ),
                      ),
                      children: [
                        lat == null
                            ? Container()
                            : Map_Page(
                                lat: lat!,
                                lng: lng!,
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
                    values['doc_id'] = sosData!.docId;
                    values['doc_name'] = title.text;
                    values['latitude'] = lat;
                    values['longitude'] = lng;
                    values['description'] = detail.text;
                    if (files.isNotEmpty) {
                      values['imgPath'] = files;
                    } else if (image == '') {
                      values['imgPath'] = null;
                    }
                    sosController.edit_SOS(values);
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
