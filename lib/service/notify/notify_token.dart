import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:doormster/utils/secure_storage.dart';

class Notify_Token {
  //บันทึก token device เพื่อส่ง notify
  Future<void> create_notifyToken(companyId, sId) async {
    var deviceToken = await SecureStorageUtils.readString('notifyToken');
    String url = '${IP_Address}create/notifyToken';
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
    var deviceToken = await SecureStorageUtils.readString('notifyToken');
    var companyId = await SecureStorageUtils.readString('companyId');
    var sId = await SecureStorageUtils.readString('userId');
    String url = '${IP_Address}delete/notifyToken';
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
    // debugPrint(deviceToken);
    // debugPrint("companyId : $companyId");
    // debugPrint("sId: $sId");
    // log("Notify: ${response.data}");
  }
}
