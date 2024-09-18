// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, collection_methods_unrelated_type

// import 'package:checkbox_formfield/checkbox_formfield.dart';

import 'package:doormster/components/actions/form_error_snackbar.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/datePicker/date_picker.dart';
import 'package:doormster/components/dropdown/dropdown.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/text_form/text_form.dart';
import 'package:doormster/components/text_form/text_form_number.dart';
import 'package:doormster/controller/branch_controller.dart';
import 'package:doormster/controller/visitor_controller.dart';
import 'package:doormster/models/access_models/get_house.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Visitor_Page extends StatefulWidget {
  Visitor_Page({Key? key}) : super(key: key);

  @override
  State<Visitor_Page> createState() => _Visitor_PageState();
}

class _Visitor_PageState extends State<Visitor_Page> {
  final _kye = GlobalKey<FormState>();
  final visitName = TextEditingController();
  final meetName = TextEditingController();
  final phone = TextEditingController();
  final startDate = TextEditingController();
  final endDate = TextEditingController();
  String branchId = branchController.branch_Id.value;
  String houseId = '';

  List<Data> listHouse = visitorController.listHouse;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await visitorController.gethouse(loadingTime: 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            appBar: AppBar(title: Text('create_visitor'.tr)),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton:
                connectApi.loading.isTrue ? Container() : _button(),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: _kye,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('visitor_name'.tr),
                        Text_Form(
                          controller: visitName,
                          title: 'fullname'.tr,
                          icon: Icons.person,
                          error: 'enter_name_visitor'.tr,
                          TypeInput: TextInputType.name,
                        ),
                        Text('meet_name'.tr),
                        Text_Form(
                          controller: meetName,
                          title: 'fullname'.tr,
                          icon: Icons.person_outline,
                          error: 'enter_name_contacts'.tr,
                          TypeInput: TextInputType.name,
                        ),
                        Text('phone_number'.tr),
                        TextForm_Number(
                          controller: phone,
                          title: 'phone_number'.tr,
                          icon: Icons.phone,
                          type: TextInputType.name,
                          maxLength: 10,
                          error: (values) {
                            if (values.isEmpty) {
                              return 'enter_phone'.tr;
                            } else if (values.length < 10) {
                              return "phone_10char".tr;
                            } else {
                              return null;
                            }
                          },
                        ),
                        Text('place_meet'.tr),
                        Dropdown(
                          title: 'choose_place'.tr,
                          listItem: listHouse
                              .map((e) =>
                                  "${'house_number'.tr} :${e.label!.split(':').last}")
                              .toList(),
                          leftIcon: Icons.home_rounded,
                          onChanged: (value) {
                            final selected = listHouse.firstWhere((item) =>
                                "${'house_number'.tr} :${item.label!.split(':').last}" ==
                                value);
                            houseId = selected.value!;
                          },
                          error: 'select_place'.tr,
                        ),
                        Text('start_date'.tr),
                        Date_Picker(
                            controller: startDate,
                            title: 'pick_date'.tr,
                            leftIcon: Icons.event_note_rounded,
                            error: 'select_date'.tr),
                        Text('end_date'.tr),
                        Date_Picker(
                          controller: endDate,
                          title: 'pick_date'.tr,
                          leftIcon: Icons.event_note_rounded,
                          error: 'select_date'.tr,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          connectApi.loading.isTrue ? Loading() : Container()
        ],
      ),
    );
  }

  Widget _button() {
    return Buttons(
        title: 'create_qrcode'.tr,
        press: () {
          if (_kye.currentState!.validate()) {
            DateTime start = DateTime.parse(startDate.text);
            DateTime end = DateTime.parse(endDate.text);
            if (end.isBefore(start)) {
              dialogOnebutton_Subtitle(
                  title: 'wrong_date'.tr,
                  subtitle: 'end_start'.tr,
                  icon: Icons.warning_rounded,
                  colorIcon: Colors.orange,
                  textButton: 'ok'.tr,
                  press: () => Get.back(),
                  click: true,
                  backBtn: true,
                  willpop: true);
            } else {
              List<String> data_visitor = [
                visitName.text,
                meetName.text,
                phone.text,
                startDate.text,
                endDate.text
              ];
              Map<String, dynamic> values = Map();
              values['branch_id'] = branchId;
              values['house_id'] = houseId;
              values['visitor_name'] = visitName.text;
              values['meet_name'] = meetName.text;
              values['phone'] = phone.text;
              values['startDate'] =
                  DateTime.parse(startDate.text).toIso8601String();
              values['endDate'] =
                  DateTime.parse(endDate.text).toIso8601String();
              visitorController.create_Visitor(
                  value: values, data_visitor: data_visitor);
            }
          } else {
            form_error_snackbar();
            Scrollable.ensureVisible(
              _kye.currentContext!,
              alignment: 0.5,
              duration: Duration.zero,
            );
          }
        });
  }
}
