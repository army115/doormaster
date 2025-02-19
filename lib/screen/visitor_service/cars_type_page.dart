import 'package:doormster/screen/visitor_service/visitor_idcard_page.dart';
import 'package:doormster/style/textStyle.dart';
import 'package:doormster/widgets/actions/form_error_snackbar.dart';
import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton.dart';
import 'package:doormster/widgets/button/button.dart';
import 'package:doormster/widgets/dropdown/dropdown.dart';
import 'package:doormster/widgets/text/text_double_colors_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarsTypePage extends StatefulWidget {
  const CarsTypePage({super.key});

  @override
  State<CarsTypePage> createState() => _CarsTypePageState();
}

class _CarsTypePageState extends State<CarsTypePage> {
  final _formkey = GlobalKey<FormState>();
  List<String> carsType = [
    "รถเก๋ง",
    "รถกระบะ",
    "รถตู้",
    "รถจักรยานยนต์",
    "รถจักรยาน",
    "รถแท็คซี่",
    "รถบรรทุก",
  ];

  List<String> listPurpose = [
    "เยี่ยมญาติ",
    "เข้าพบเจ้าของบ้าน",
    "ส่งสินค้า",
    "รับ-ส่งคน",
    "ส่งอาหารหรือพัสดุ",
    "บริการซ่อมบำรุง",
    "ร่วมงานเลี้ยงหรือกิจกรรม",
    "เข้าประชุมหรือทำกิจกรรมส่วนรวม",
    "ดูแลหรือทำความสะอาดบ้าน",
    "สำรวจพื้นที่เพื่อการก่อสร้าง",
    "ติดต่อสำนักงานนิติบุคคล",
    "บริการทางการแพทย์หรือฉุกเฉิน",
    "อื่น ๆ",
  ];
  String? selectedCarType;
  String? selectedPurpose;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("list_vehicle_type".tr),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textDoubleColorsIcon(
                    text1: 'vehicle_type'.tr,
                    fontWeight1: FontWeight.bold,
                    text2: '*',
                    fontsize2: 18,
                    color2: Colors.red,
                    icon: Icon(
                      CupertinoIcons.car,
                      color: Theme.of(context).dividerColor,
                      size: 25,
                    )),
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 56,
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: carsType.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final carType = carsType[index];
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedCarType = carType;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedCarType == carType
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(carType,
                          textAlign: TextAlign.center,
                          style: textStyle.title16),
                    );
                  },
                ),
                textDoubleColorsIcon(
                    text1: 'purpose'.tr,
                    fontWeight1: FontWeight.bold,
                    text2: '*',
                    fontsize2: 18,
                    color2: Colors.red,
                    icon: Icon(
                      Icons.description,
                      color: Theme.of(context).dividerColor,
                      size: 25,
                    )),
                Dropdown(
                  title: 'purpose'.tr,
                  // controller: purpose,
                  error: 'enter_purpose'.tr,
                  listItem: listPurpose.toList(),
                  onChanged: (value) {
                    debugPrint(value);
                    if (value != null) {
                      setState(() {});
                      selectedPurpose = value;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _button(),
    );
  }

  Widget _button() {
    return Buttons(
        title: 'next'.tr,
        width: Get.mediaQuery.size.width * 0.5,
        press: () async {
          if (selectedCarType == null) {
            dialogOnebutton(
              title: 'select_vehicle_type'.tr,
              icon: Icons.error_rounded,
              colorIcon: Colors.red,
              textButton: 'ok'.tr,
              press: () {
                Get.back();
              },
              click: true,
              willpop: true,
            );
          } else if (_formkey.currentState!.validate()) {
            Get.to(() => Visitor_IDCard(
                  purpose: selectedPurpose,
                ));
          } else {
            form_error_snackbar();
          }
        });
  }
}
