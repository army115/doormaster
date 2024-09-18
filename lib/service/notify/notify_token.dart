import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notify_Token {
  //บันทึก token device เพื่อส่ง notify
  Future<void> create_notifyToken(companyId, sId) async {
    var prefs = await SharedPreferences.getInstance();
    var deviceToken = prefs.getString('notifyToken');
    String url = '${IP_Address.old_IP}create/notifyToken';
    var response = await Dio().post(url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
        data: {
          "device_token": deviceToken,
          "company_id": companyId,
          "user_id": sId,
        });
    log("Notify: ${response.data}");
  }

  //ลบ token device ออกเมื่อ logout
  Future<void> deletenotifyToken() async {
    var prefs = await SharedPreferences.getInstance();
    var deviceToken = prefs.getString('notifyToken');
    var companyId = prefs.getString('companyId');
    var sId = prefs.getString('userId');
    String url = '${IP_Address.old_IP}delete/notifyToken';
    var response = await Dio().delete(url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
        data: {
          "device_token": deviceToken,
          "company_id": companyId,
          "user_id": sId,
        });
    // print(deviceToken);
    // print("companyId : $companyId");
    // print("sId: $sId");
    // log("Notify: ${response.data}");
  }
}
