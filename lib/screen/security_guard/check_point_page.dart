import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/checkBox/checkbox_formfield.dart';
import 'package:doormster/components/dropdown/dropdown_noborder.dart';
import 'package:doormster/components/text_form/text_form_novalidator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert' as convert;

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
  // List<XFile>? listImage = [];
  List<String>? listImage64 = [];

  selectedImages(ImageSource TypeImage) async {
    try {
      // var pickedfiles = await imgpicker.pickMultiImage();
      final XFile? pickedImages = await imgpicker.pickImage(source: TypeImage);
      if (pickedImages != null) {
        List<int> imageBytes = await pickedImages.readAsBytes();
        var ImagesBase64 = convert.base64Encode(imageBytes);
        setState(() {
          // listImage?.add(pickedImages);
          listImage64?.add(ImagesBase64);
          print('image64: ${ImagesBase64}');
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
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('รายการตรวจ'),
                  ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount: checkBox.length,
                      itemBuilder: ((context, index) => CheckBox_FormField(
                            title: '${checkBox[index].title}',
                            value: checkBox[index].value,
                            validator: 'กรุณาเลือกรายการ',
                          ))),
                  const Text('รูปภาพประกอบ'),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    height: 150,
                    child: ListView(
                        physics: BouncingScrollPhysics(),
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        // itemCount: listImage?.length,
                        // itemBuilder: (context, index) =>

                        children: [
                          listImage64 != null
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  reverse: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: listImage64!.length,
                                  itemBuilder: ((context, index) => Card(
                                        elevation: 5,
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: MemoryImage(
                                                        convert.base64Decode(
                                                            '${listImage64![index]}'))
                                                    // FileImage(File(
                                                    //     listImage64![
                                                    //         index]))
                                                    ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 3,
                                              right: 3,
                                              child: CircleAvatar(
                                                radius: 10,
                                                backgroundColor: Colors.red,
                                                child: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  constraints: BoxConstraints(),
                                                  splashRadius: 10,
                                                  icon: Icon(Icons.close),
                                                  onPressed: () {
                                                    setState(() {
                                                      // listImage?.remove(
                                                      //     listImage![
                                                      //         index]);
                                                      listImage64?.remove(
                                                          listImage64![index]);
                                                      print(
                                                          'Image :  ${index}');
                                                    });
                                                  },
                                                  iconSize: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )))
                              : Container(),
                          listImage64?.length == 4
                              ? Container()
                              : Card(
                                  elevation: 5,
                                  child: InkWell(
                                      onTap: () {
                                        selectedImages(ImageSource.gallery);
                                      },
                                      child: Container(
                                        width: 150,
                                        height: 150,
                                        child: const Icon(
                                          Icons.camera_alt_rounded,
                                          size: 40,
                                        ),
                                      )),
                                ),
                        ]),
                  ),
                  const Text('บันทึกเหตุการณ์'),
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
