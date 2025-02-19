// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, collection_methods_unrelated_type
import 'package:doormster/controller/visitor_controller/create_visitor_controller.dart';
import 'package:doormster/controller/visitor_controller/house_controller.dart';
import 'package:doormster/screen/qr_smart_access/visitor_detail_page.dart';
import 'package:doormster/widgets/actions/form_error_snackbar.dart';
import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/widgets/button/button.dart';
import 'package:doormster/widgets/datePicker/date_picker.dart';
import 'package:doormster/widgets/dropdown/dropdown.dart';
import 'package:doormster/widgets/text/text_double_colors.dart';
import 'package:doormster/widgets/text_form/text_form.dart';
import 'package:doormster/widgets/text_form/text_form_number.dart';
import 'package:doormster/controller/main_controller/branch_controller.dart';
import 'package:doormster/utils/scroll_field.dart';
import 'package:doormster/controller/visitor_controller/visitor_controller.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Create_Visitor extends StatefulWidget {
  Create_Visitor({Key? key}) : super(key: key);

  @override
  State<Create_Visitor> createState() => _Create_VisitorState();
}

class _Create_VisitorState extends State<Create_Visitor> {
  HouseController houseController = Get.put(HouseController());
  final _key = GlobalKey<FormState>();
  final List<GlobalKey<FormFieldState>> _fieldKeys =
      List.generate(6, (index) => GlobalKey<FormFieldState>());
  final GlobalKey _dropKeys = GlobalKey();
  final visitName = TextEditingController();
  final meetName = TextEditingController();
  final phone = TextEditingController();
  final startDate = TextEditingController();
  final endDate = TextEditingController();
  String branchId = branchController.branch_Id.value;
  String houseId = '';
  String houseNumber = '';

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(title: Text('create_visitor'.tr)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
            connectApi.loading.isTrue ? Container() : _button(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textDoubleColors(
                      text1: 'visitor_name'.tr,
                      text2: '*',
                      color2: Colors.red,
                    ),
                    Text_Form(
                      fieldKey: _fieldKeys[0],
                      controller: visitName,
                      title: 'fullname'.tr,
                      icon: Icons.person,
                      error: 'enter_name_visitor'.tr,
                      TypeInput: TextInputType.name,
                    ),
                    textDoubleColors(
                      text1: 'meet_name'.tr,
                      text2: '*',
                      color2: Colors.red,
                    ),
                    Text_Form(
                      fieldKey: _fieldKeys[1],
                      controller: meetName,
                      title: 'fullname'.tr,
                      icon: Icons.person_outline,
                      error: 'enter_name_contacts'.tr,
                      TypeInput: TextInputType.name,
                    ),
                    textDoubleColors(
                      text1: 'phone_number'.tr,
                      text2: '*',
                      color2: Colors.red,
                    ),
                    TextForm_Number(
                      fieldKey: _fieldKeys[2],
                      controller: phone,
                      title: 'phone_number'.tr,
                      icon: Icons.phone,
                      type: TextInputType.phone,
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
                    textDoubleColors(
                      text1: 'place_meet'.tr,
                      text2: '*',
                      color2: Colors.red,
                    ),
                    Dropdown(
                      fieldKey: _dropKeys,
                      title: 'choose_place'.tr,
                      listItem: houseController.listHouse
                          .map((item) => item.label!
                              // "${'house_number'.tr} :${item.label!.split(':').last}",
                              )
                          .toList(),
                      leftIcon: Icons.home_rounded,
                      onChanged: (value) {
                        // final selected = listHouse.firstWhere((item) =>
                        //     "${'house_number'.tr} :${item.label!.split(':').last}" ==
                        //     value);
                        houseNumber = value!.split(': ').last;
                        houseId = value.split(' :').first;
                      },
                      error: 'select_place'.tr,
                    ),
                    textDoubleColors(
                      text1: 'start_date'.tr,
                      text2: '*',
                      color2: Colors.red,
                    ),
                    Date_Picker(
                        fieldKey: _fieldKeys[4],
                        controller: startDate,
                        title: 'pick_date'.tr,
                        leftIcon: Icons.event_note_rounded,
                        error: 'select_date'.tr),
                    textDoubleColors(
                      text1: 'end_date'.tr,
                      text2: '*',
                      color2: Colors.red,
                    ),
                    Date_Picker(
                      fieldKey: _fieldKeys[5],
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
    );
  }

  Widget _button() {
    return Buttons(
        title: 'create_qrcode'.tr,
        width: Get.mediaQuery.size.width * 0.6,
        press: () {
          if (_key.currentState!.validate()) {
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
              List<String> dataVisitor = [
                visitName.text,
                meetName.text,
                phone.text,
                houseNumber,
                startDate.text,
                endDate.text
              ];
              Map<String, dynamic> values = {};
              values['branch_id'] = branchId;
              values['house_id'] = houseId;
              values['visitor_name'] = visitName.text;
              values['meet_name'] = meetName.text;
              values['phone'] = phone.text;
              values['start_date'] = startDate.text;
              values['end_date'] = endDate.text;
              // createVisitorController.createVisitor_byUser(
              //     value: values, data_visitor: dataVisitor);
              Get.to(() => Visitor_Detail(
                    visitordData: dataVisitor,
                    qr_code: '13',
                  ));
            }
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
}
