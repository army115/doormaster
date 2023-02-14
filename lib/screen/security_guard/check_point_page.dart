import 'dart:io';
import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/checkBox/checkbox_formfield.dart';
import 'package:doormster/components/dropdown/dropdown_noborder.dart';
import 'package:doormster/components/text_form/text_form.dart';
import 'package:doormster/components/text_form/text_form_noborder.dart';
import 'package:doormster/components/text_form/text_form_novalidator.dart';
import 'package:doormster/components/text_form/text_form_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Check_Point extends StatefulWidget {
  const Check_Point({Key? key});

  @override
  State<Check_Point> createState() => _Check_PointState();
}

class CheckBox {
  String? title;
  bool? value;
  // String? validator;

  CheckBox({
    this.title,
    this.value,
    // this.validator
  });
}

List<CheckBox> checkBox = [
  CheckBox(
    title: "เปิดไฟโครงการ",
    value: false,
    // validator: "กรุณาเลือกรายการ",
  ),
  CheckBox(
    title: "เปิดไฟที่ป้อม",
    value: false,
    // validator: "กรุณาเลือกรายการ",
  ),
  CheckBox(
    title: "ล็อคประตูโครงการ",
    value: false,
    // validator: "กรุณาเลือกรายการ",
  ),
  CheckBox(
    title: "ตรวจที่จอดรถ",
    value: false,
    // validator: "กรุณาเลือกรายการ",
  ),
];

class _Check_PointState extends State<Check_Point> {
  // bool Checked = false;
  final _formkey = GlobalKey<FormState>();
  TextEditingController detail = TextEditingController();

  final ImagePicker imgpicker = ImagePicker();
  XFile? image;

  openImages(ImageSource TypeImage) async {
    try {
      // var pickedfiles = await imgpicker.pickMultiImage();
      final XFile? photo = await imgpicker.pickImage(source: TypeImage);
      //you can use ImageCourse.camera for Camera capture
      if (photo != null) {
        // imagefiles = pickedfiles;
        setState(() {
          image = photo;
        });
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เช็คจุดสำรวจ'),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
        child: Buttons(
            title: 'บันทึก',
            press: () {
              if (_formkey.currentState!.validate()) {
                Map<String, dynamic> valuse = Map();
                print(valuse);
              }
            }),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('รายการตรวจ'),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: checkBox.length,
                      itemBuilder: ((context, index) => CheckBox_FormField(
                            title: '${checkBox[index].title}',
                            value: checkBox[index].value,
                            validator: 'กรุณาเลือกรายการ',
                          ))),
                  Text('รูปภาพประกอบ'),
                  Row(
                    children: [
                      Card(
                        child: InkWell(
                            onTap: () {
                              openImages(ImageSource.gallery);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                height: MediaQuery.of(context).size.width * 0.4,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Icon(
                                  Icons.camera_alt_rounded,
                                  size: 40,
                                ),
                              ),
                            )),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.width * 0.5,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: GridView.builder(
                            shrinkWrap: true,
                            primary: true,
                            scrollDirection: Axis.horizontal,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              // childAspectRatio: 1,
                              crossAxisCount: 1,
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 10,
                            ),
                            // itemCount: 1,
                            itemBuilder: (context, index) {
                              return image != null
                                  ? Card(
                                      child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image:
                                                  FileImage(File(image!.path))),
                                        ),
                                      ),
                                    ))
                                  : Container();
                            }),
                      ),
                    ],
                  ),
                  Text('บันทึกเหตุการณ์'),
                  DropDownType(),
                  Text_Form_NoValidator(
                    TypeInput: TextInputType.text,
                    controller: detail,
                    icon: Icons.description_rounded,
                    title: 'รายละเอียด',
                  )
                ],
              )),
        ),
      )),
    );
  }

  var dropdownValue;
  Widget DropDownType() {
    return Dropdown_NoBorder(
      title: 'เลือกสถานการณ์',
      // deviceId == null ? 'ไม่มีอุปกรณ์' : 'เลือกอุปกรณ์',
      values: dropdownValue,
      listItem: ['ปกติ', 'ไม่ปกติ'].map((value) {
        return DropdownMenuItem(
          value: value,
          child: Text(
            '${value}',
          ),
        );
      }).toList(),
      leftIcon: Icons.note_add_rounded,
      validate: (values) {
        if (values == null) {
          return 'กรุณาเลือกสถานการณ์';
        }
        return null;
      },
      onChange: (value) {
        setState(() {
          dropdownValue = value;
        });
      },
    );
  }
}
