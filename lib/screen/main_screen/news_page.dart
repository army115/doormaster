// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print, use_build_context_synchronously

import 'dart:typed_data';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/style/theme/light/theme_light.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:ui' as ui;
import 'package:doormster/style/textStyle.dart';

class News_Page extends StatefulWidget {
  const News_Page({super.key});

  @override
  State<News_Page> createState() => _News_PageState();
}

class _News_PageState extends State<News_Page>
    with AutomaticKeepAliveClientMixin {
  GlobalKey _keyScreenshot = GlobalKey();
  List<bool> showtext = [];
  List<getdata> data = [
    getdata(
        title: 'กล้อง CCTV คุณภาพจาก HIP',
        images:
            'https://hipglobal.co.th/assets/images/hip-product-group-570x334-02.jpg',
        details:
            '💥ให้เราดูแลบ้านแทนคุณ💥ด้วยกล้อง CCTV คุณภาพจาก HIPภาพสี+เสียง 24 ช.ม.  ใช้งานภายนอก ภายในความละเอียดสูงสุดระดับ 4K 📌5 ล้านพิกเซล📹คมชัดทั้งภาพ กลางวัน กลางคืน  ✅ ความละเอียด 2 - 5 ล้านพิกเซล ✅  บันทึกภาพ พร้อม เสียง คมชัดละเอียดทุก ระดับ 4K✅  ภาพสี 24 ช.ม. Dual Light มาพร้อมเทคโนโลยี Smart IR✅  ตรวจจับการเคลื่อนไหวด้วย AI เฉพาะมนุษย์✅  คืนที่ไร้แสงไฟ วันที่ใจมัวหม่น สามารถมองเห็นได้ชัดไร้ที่ติ‼️‼️ ✅  กันแดดกันฝน กันลม พร้อมประกัน 3 ปี 💕📢 พร้อมติดตั้งทั่วไทยโดยตัวแทนจำหน่ายคุณภาพจาก HIP  สอบถามศูนย์ตัวแทนจำหน่ายได้ที่ 027481993 หรือ ทักคอมเม้นเลยเราจะแนะนำคุณ 🤝'),
    getdata(
        title: 'ระบบเตือนภัยฉุกเฉินผ่านแพลตฟอร์ม HIP Cloud Security',
        images:
            'https://hipglobal.co.th/assets/images/hip-product-group-570x334-06.jpg',
        details:
            'ป้องกันเหตุไม่คาดฝัน 📌ระบบเตือนภัยฉุกเฉินด้วยปุ่มเดียว ผ่านแพลตฟอร์ม HIP Cloud Securityส่งสัญญาณเตือนภัยในรูปแบบวิดีโอ ด้วยเทคโนโลยี IoTสำหรับการโทรฉุกเฉิน เตือนด้วยวิดีโอ การเตือนด้วยเสียง และสนทนาได้ แจ้งเตือนไปยังแอปพลิเคชั่นบนมือถือ และศูนย์ HIP Cloud 24 hr แบบเรียลไทม์  📌ยับยั้งเหตุร้ายได้ทันถ่วงที  เหมาะสำหรับติดตั้งอุปกรณ์เตือนภัยนี้กับพื้นที่เฝ้าระวังเป็นพิเศษ  ✅ ตัวเครื่องป้องกันความปลอดภัยแบบแอ็คทีฟ เพื่อยับยั้งการเกิดเหตุได้ทันการณ์  ✅ ปุ่มกดฉุกเฉิน พร้อมแจ้งเตือนวิดีโอทันที  ✅ Two-way  Audio พูดคุยโต้ตอบได้สองทาง  ✅ ศูนย์ HIP Cloud 24 hr แบบเรียลไทม์👮HIP 🛒 สามารถติดต่อมาเลยที่ฝ่ายขาย HIP หรือจุดติดตั้ง ตัวแทนจำหน่ายของ HIP ได้ทั่วประเทศ☎️ โทร. 02-748-1993🌐 เว็บไซต์ : hip.co.th📢 Line : https://lin.ee/aUqllfe'),
    getdata(
        title: 'เครื่องสแกนลายนิ้วมือสำหรับควบคุมการเข้าประตู',
        images:
            'https://hipglobal.co.th/assets/images/hip-product-group-570x334-04.jpg',
        details:
            'CMG606F เครื่องสแกนลายนิ้วมือ ทาบบัตร กดรหัส สำหรับควบคุมการเข้าประตู และรองรับเชื่อมต่อผ่านสัญญาณ Bluetoothกับแอปพลิเคชัน HIP IOT  ง่าย สะดวก ปลอดูภัย กรณีผู้มาติดต่อสามารถส่งรหัส One-Time เพื่อเปิดประตูได้เพียงครั้งเดียว เหมาะสำหรับการใช้งานกับประตูบ้าน ออฟฟิศ อพาร์ทเม้นท์ คอนโด')
  ];

  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    super.initState();
    showtext = List<bool>.filled(data.length, true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('news_feed'.tr),
            leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                }),
          ),
          body: RepaintBoundary(
            key: _keyScreenshot,
            child: Container(
              child: data.isEmpty
                  ? Logo_Opacity(title: 'no_news'.tr)
                  : ListView.builder(
                      itemCount: data.length,
                      padding: EdgeInsets.all(15),
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.only(bottom: 10),
                          // color: Get.theme.primaryColorDark,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${data[index].title}',
                                  style: TextStyle(fontSize: 15, height: 1.3),
                                ),
                                Divider(
                                  color: Get.theme.primaryColor,
                                  thickness: 1,
                                ),
                                SizedBox(height: 3),
                                Image.network(
                                  '${data[index].images}',
                                  height: showtext[index] ? 150 : null,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '${data[index].details}',
                                  maxLines: showtext[index] ? 4 : null,
                                  overflow: showtext[index]
                                      ? TextOverflow.ellipsis
                                      : null,
                                  style: textStyle().body14,
                                ),
                                Divider(
                                  color: Get.theme.primaryColor,
                                  thickness: 1,
                                ),
                                Center(
                                  child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showtext[index] = !showtext[index];
                                        });
                                        print(showtext);
                                      },
                                      child: Text(
                                        showtext[index]
                                            ? 'see_more'.tr
                                            : 'see_less'.tr,
                                        style: TextStyle(
                                            color: Get.theme.primaryColor,
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 14),
                                      )),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class getdata {
  String title;
  String images;
  String details;

  getdata({required this.title, required this.images, required this.details});
}
