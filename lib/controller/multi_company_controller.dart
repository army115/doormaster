// import 'package:dio/dio.dart';
// import 'package:doormster/service/connected/connect_api.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:doormster/models/get_multi_company.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// final MultiCompany_Contrller multiCompany_Contrller =
//     Get.put(MultiCompany_Contrller());

// class MultiCompany_Contrller extends GetxController {
//   Rx<bool> loading = false.obs;
//   RxList multiCompany = <Data>[].obs;
//   var uuId;
//   var companyId;
//   var security;
//   var image;
//   var fname;
//   var lname;

//   late SharedPreferences prefs;

//   @override
//   void onInit() async {
//     getValueShared();
//     super.onInit();
//   }

//   @override
//   void onClose() {
//     multiCompany.clear();
//     super.onClose();
//   }

//   Future<void> getValueShared() async {
//     prefs = await SharedPreferences.getInstance();
//     uuId = prefs.getString('uuId');
//     companyId = prefs.getString('companyId');
//     security = prefs.getBool('security');
//     image = prefs.getString('image');
//     fname = prefs.getString('fname');
//     lname = prefs.getString('lname');

//     GetMultiCompany();
//   }

//   Future<void> GetMultiCompany() async {
//     try {
//       loading.value = true;

//       var url = '${Connect_api().domain}/get/multicompanymobile/$uuId';
//       var response = await Dio().get(
//         url,
//         options: Options(headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         }),
//       );

//       if (response.statusCode == 200) {
//         multiCompany.value
//             .assignAll(getMultiCompany.fromJson(response.data).data!);
//       }
//     } catch (error) {
//       print(error);
//     } finally {
//       loading.value = false;
//     }
//   }
// }
