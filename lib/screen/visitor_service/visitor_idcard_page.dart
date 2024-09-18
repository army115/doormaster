import 'package:doormster/components/dropdown/dropdown.dart';
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
  final _key = GlobalKey<FormState>();
  final id = TextEditingController();
  final fname = TextEditingController();
  final lname = TextEditingController();
  final phone = TextEditingController();
  final details = TextEditingController();
  bool loading = false;

  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;

  List<String> days = List.generate(31, (index) => (index + 1).toString());
  List<String> months =
      List<String>.generate(12, (index) => (index + 1).toString());
  List<String>? years;

  Future getInfo() async {
    DateTime dateNow = DateTime.now();
    int thaiYear = 543 + dateNow.year;
    selectedDay = dateNow.day.toString();
    selectedMonth = dateNow.month.toString();
    selectedYear = thaiYear.toString();
    years =
        List<String>.generate(101, (index) => (thaiYear - index).toString());
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }

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
                key: _key,
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 80),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              child: CircleAvatar(
                                radius: 73,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                    radius: 70,
                                    backgroundColor: Colors.grey.shade100,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                'assets/images/HIP Smart Community Icon-01.png')),
                                      ),
                                    )),
                              ),
                            ),
                            Text('idCard'.tr),
                            Text_Form(
                              controller: id,
                              title: 'idCard'.tr,
                              // icon: Icons.person,
                              error: 'enter_name_visitor'.tr,
                              TypeInput: TextInputType.name,
                            ),
                            Text('fname'.tr),
                            Text_Form(
                              controller: fname,
                              title: 'fname'.tr,
                              // icon: Icons.person,
                              error: 'enter_name_visitor'.tr,
                              TypeInput: TextInputType.name,
                            ),
                            Text('lname'.tr),
                            Text_Form(
                              controller: lname,
                              title: 'lname'.tr,
                              // icon: Icons.person_outline,
                              error: 'enter_name_contacts'.tr,
                              TypeInput: TextInputType.name,
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     _dropdown(
                            //       'day'.tr,
                            //       selectedDay,
                            //       days,
                            //       (newValue) {
                            //         setState(() {
                            //           selectedDay = newValue;
                            //         });
                            //       },
                            //     ),
                            //     _dropdown(
                            //       'month'.tr,
                            //       selectedMonth,
                            //       months,
                            //       (newValue) {
                            //         setState(() {
                            //           selectedMonth = newValue;
                            //         });
                            //       },
                            //     ),
                            //     _dropdown(
                            //       'year'.tr,
                            //       selectedYear,
                            //       years!,
                            //       (newValue) {
                            //         setState(() {
                            //           selectedYear = newValue;
                            //         });
                            //       },
                            //     ),
                            //   ],
                            // ),
                            Text('phone'.tr),
                            TextForm_Number(
                              controller: phone,
                              title: 'phone_number'.tr,
                              // icon: Icons.phone,
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
                            Text('วัตถุประสงค์'.tr),
                            Text_Form(
                              controller: details,
                              title: 'กรุณากรอก'.tr,
                              TypeInput: TextInputType.name,
                              maxLines: 5,
                              minLines: 3,
                              error: 'กรุณาบอกวัตถุประสงค์',
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

  Widget _button() {
    return Buttons(
        title: 'submit'.tr,
        press: () {
          if (_key.currentState!.validate()) {}
        });
  }

  Widget _dropdown(String title, String? value, List<String> item, onChanged) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Text(title),
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: PhysicalModel(
          borderRadius: BorderRadius.circular(10),
          elevation: 3,
          color: Colors.white,
          child: DropdownButton(
              padding: EdgeInsets.only(left: 10, right: 20),
              value: value,
              hint: Text(title),
              menuMaxHeight: Get.mediaQuery.size.height * 0.7,
              borderRadius: BorderRadius.circular(5),
              underline: Container(),
              items: item.map((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onChanged),
        ),
      ),
    ]);
  }
}
