// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart' as dio;
import 'package:doormster/components/actions/form_error_snackbar.dart';
import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/image/add_iamges.dart';
import 'package:doormster/components/image/show_images.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/map/map_page.dart';
import 'package:doormster/components/text/text_icon.dart';
import 'package:doormster/components/text_form/text_form.dart';
import 'package:doormster/controller/add_images_controller.dart';
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
      return Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: const Text('SOS'),
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
                            ),
                      const SizedBox(height: 5),
                      PhysicalModel(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 3,
                        color: Colors.transparent,
                        child: ExpansionTile(
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
                        values['doc_id'] = sosData!.docId;
                        values['doc_name'] = title.text;
                        values['latitude'] = lat;
                        values['longitude'] = lng;
                        values['description'] = detail.text;
                        if (files.isNotEmpty) {
                          values['imgPath'] = files;
                        }
                        sosController.edit_SOS(values);
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
