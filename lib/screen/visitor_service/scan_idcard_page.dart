// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, deprecated_member_use, avoid_print

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/models/id_card.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/style/overlay_frame.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class Scan_IDCard extends StatefulWidget {
  const Scan_IDCard({super.key});

  @override
  State<Scan_IDCard> createState() => _Scan_IDCardState();
}

class _Scan_IDCardState extends State<Scan_IDCard> {
  CameraController? controller;
  XFile? image;
  String? imagePath;
  final StreamController<String> _controller = StreamController<String>();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    availableCameras().then((cameras) {
      if (cameras.length > 0) {
        setState(() {
          controller = CameraController(cameras[0], ResolutionPreset.high,
              enableAudio: false);
          controller!.initialize().then((_) {
            if (!mounted) {
              return;
            }
            setState(() {
              _isInitialized = true;
            });
          });
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _capture() async {
    // if (!controller!.value.isTakingPicture) {
    try {
      // await controller?.setFlashMode(FlashMode.off);
      // await controller?.setFocusMode(FocusMode.auto);
      // final image = await controller!.takePicture();
      // print(image.path);
      // setState(() {
      //   imagePath = image.path;
      // });
      final ImagePicker imgpicker = ImagePicker();
      final images = await imgpicker.pickImage(
          source: ImageSource.gallery, maxHeight: 1080, maxWidth: 1080);
      if (images != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Show_Image(
                imagepath: images,
              ),
            ));
      }
      // Get.to(Show_Image(
      //   imagepath: image,
      // ));
    } catch (e) {
      print("Error: $e");
    }
    // }
  }

  @override
  Widget build(BuildContext context) {
    // if (controller == null || !controller!.value.isInitialized) {
    //   return Container();
    // }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        // fit: StackFit.expand,
        children: [
          // Center(
          //   child: CameraPreview(
          //     controller!,
          //     child: Container(
          //       decoration: ShapeDecoration(
          //         shape: OverlayShape(
          //           borderWidth: 10,
          //           borderRadius: 10,
          //           cutOutHeight: 240,
          //           cutOutWidth: 370,
          //         ),
          //       ),
          //       // child: FutureBuilder(future: , builder: builder),
          //     ),
          //   ),
          // ),
          Positioned(
            left: 10,
            top: MediaQuery.of(context).size.height * 0.05,
            child: Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white30),
              child: IconButton(
                  color: Colors.white,
                  iconSize: 30,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded)),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.05,
            child: Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white30),
              child: IconButton(
                  color: Colors.white,
                  iconSize: 60,
                  onPressed: _capture,
                  icon: const Icon(Icons.camera)),
            ),
          ),
        ],
      ),
    );
  }
}

class Show_Image extends StatefulWidget {
  final imagepath;

  const Show_Image({super.key, this.imagepath});

  @override
  State<Show_Image> createState() => _Show_ImageState();
}

class _Show_ImageState extends State<Show_Image> {
  String text = '';
  List<String> data = [];
  String? fname;
  String? lname;
  String? id_number;

  // void _scantext() async {
  //   try {
  //     final inputImage = InputImage.fromFilePath(widget.imagepath.path);
  //     final textRecognizer =
  //         TextRecognizer(script: TextRecognitionScript.chinese);
  //     final RecognizedText recognizedText =
  //         await textRecognizer.processImage(inputImage);
  //     if (text == '' || data.isEmpty) {
  //       for (TextBlock block in recognizedText.blocks) {
  //         for (TextLine line in block.lines) {
  //           for (TextElement element in line.elements) {
  //             setState(() {});
  //             text = text + element.text + ' ';
  //             data.add(element.text);
  //             print(text);
  //           }
  //         }
  //       }
  //     }
  //     if (data.isNotEmpty) {
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => ID_Form(
  //               fname: data[0],
  //               lname: data[1],
  //               id_card: data[2],
  //               textFull: text,
  //             ),
  //           ));
  //     } else {
  //       dialogOnebutton_Subtitle(context, 'Error', 'ข้อมูลบัตรไม่ถูกต้อง',
  //           Icons.warning, Colors.orange, 'OK', () {
  //         Navigator.pop(context);
  //       }, false, false);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> _sendID(XFile file) async {
    try {
      // await Future.delayed(Duration(milliseconds: loadingTime));

      //call api Dio
      var host = 'http://localhost:8080/OCR';
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.name,
        ),
      });

      Response response = await Dio().post(
        host,
        data: formData,
        // options: Options(
        //   headers: {'apikey': 'NmQF10gmOYyg8Sa1abNuiu6EEH0Yzlnr'},
        // ),
      );
      log(response.data.toString());

      if (response.statusCode == 200) {
        ID_Card id_card = ID_Card.fromJson(response.data);
        setState(() {
          // fname = id_card.thFname;
          // lname = id_card.thLname;
          // id_number = id_card.idNumber;
          text = response.data.toString();
        });
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => ID_Form(
        //         fname: id_card.thFname,
        //         lname: id_card.thLname,
        //         id_card: id_card.idNumber,
        //       ),
        //     ));
        // Get.to(ID_Form(
        //   fname: id_card.thFname,
        //   lname: id_card.thLname,
        //   id_card: id_card.idNumber,
        // ));
      } else {
        print(response.statusCode);
        ID_Card error = ID_Card.fromJson(response.data);
        // Error error = Error.fromJson(convert.jsonDecode(responseBody));
        dialogOnebutton_Subtitle('Error', '${error.errorMessage}',
            Icons.warning, Colors.orange, 'OK', () {
          Navigator.pop(context);
        }, false, false);
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Error status code: ${e.response!.statusCode}');
        print('Error response data: ${e.response!.data}');
        ID_Card error = ID_Card.fromJson(e.response?.data);
        dialogOnebutton_Subtitle('Error', '${error.errorMessage}',
            Icons.check_circle, Colors.green, 'OK', () {
          Navigator.pop(context);
        }, false, false);
      } else {
        dialogOnebutton_Subtitle(
            'Error', '${e}', Icons.warning, Colors.orange, 'OK', () {
          Navigator.pop(context);
        }, false, false);
        log('Request failed without a response.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    XFile file = widget.imagepath;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // SizedBox(
          // width: double.infinity,
          // height: double.infinity,
          // child:
          Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                foregroundDecoration: ShapeDecoration(
                  shape: OverlayShape(
                    borderColor: Colors.white,
                    borderWidth: 10,
                    borderRadius: 10,
                    cutOutHeight: 240,
                    cutOutWidth: 370,
                  ),
                ),
                decoration: BoxDecoration(
                    image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  alignment: FractionalOffset.center,
                  image: FileImage(
                    File(file.path),
                  ),
                )),
              ),
              // )
            ),
          ),

          Positioned(
            right: 10,
            top: MediaQuery.of(context).size.height * 0.05,
            child: ElevatedButton(
                onPressed: () {
                  // _scantext();
                  _sendID(file);
                },
                child: Icon(Icons.translate)),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              text,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          Positioned(
            left: 10,
            top: MediaQuery.of(context).size.height * 0.05,
            child: Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white30),
              child: IconButton(
                  color: Colors.white,
                  iconSize: 30,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded)),
            ),
          ),
          // ListView.builder(
          //   primary: false,
          //   shrinkWrap: true,
          //   itemCount: data.length,
          //   itemBuilder: (context, index) => Text(data[index]),
          // )
        ],
      ),
    );
  }
}

class ID_Form extends StatefulWidget {
  final fname;
  final lname;
  final id_card;
  final textFull;
  const ID_Form(
      {super.key, this.fname, this.lname, this.id_card, this.textFull});

  @override
  State<ID_Form> createState() => _ID_FormState();
}

class _ID_FormState extends State<ID_Form> {
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController id_card = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fname.text = widget.fname;
    lname.text = widget.lname;
    id_card.text = widget.id_card;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: fname,
              decoration: InputDecoration(hintText: fname.text),
            ),
            TextFormField(
              controller: lname,
              decoration: InputDecoration(hintText: lname.text),
            ),
            TextFormField(
              controller: id_card,
              decoration: InputDecoration(hintText: id_card.text),
            ),
            Text(widget.textFull),
          ],
        ),
      ),
    );
  }
}
