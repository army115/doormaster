import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/text_form/text_form.dart';
import 'package:doormster/components/text_form/text_form_number.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Visitor_IDCard extends StatefulWidget {
  const Visitor_IDCard({super.key});

  @override
  State<Visitor_IDCard> createState() => _Visitor_IDCardState();
}

class _Visitor_IDCardState extends State<Visitor_IDCard> {
  final _kye = GlobalKey<FormState>();
  final visitName = TextEditingController();
  final visitPeople = TextEditingController();
  final phone = TextEditingController();
  final startDate = TextEditingController();
  final endDate = TextEditingController();
  final useCount = TextEditingController();
  final devices = TextEditingController();
  final types = TextEditingController();
  final selectDevices = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text('create_visitor'.tr)),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _button(),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _kye,
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 80),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('fname'.tr),
                            Text_Form(
                              controller: visitName,
                              title: 'fullname'.tr,
                              icon: Icons.person,
                              error: 'enter_name_visitor'.tr,
                              TypeInput: TextInputType.name,
                            ),
                            Text('contacts'.tr),
                            Text_Form(
                              controller: visitPeople,
                              title: 'fullname'.tr,
                              icon: Icons.person_outline,
                              error: 'enter_name_contacts'.tr,
                              TypeInput: TextInputType.name,
                            ),
                            Text('phone'.tr),
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
                          ],
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ),
        loading ? Loading() : Container()
      ],
    );
  }
}

Widget _button() {
  return Buttons(title: 'submit'.tr, press: () {});
}
