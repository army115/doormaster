import 'package:dio/dio.dart';
import 'package:doormster/models/profile_model.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future get_Info() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userId = prefs.getString('userId');
  var security = prefs.getBool('security');

  try {
    var url = '${Connect_api().domain}/get/profile/$userId';
    var response = await Dio().get(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      }),
    );

    if (response.statusCode == 200) {
      GetProfile getInfo = GetProfile.fromJson(response.data);
      List<Data>? data = getInfo.data;
      print("getInfo : yes");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', data!.single.userName!);
      await prefs.setString('fname', data.single.firstName!);
      await prefs.setString('lname', data.single.surName!);
      await prefs.setInt('role', data.single.mobile!);
      await prefs.setString('userId', data.single.sId!);
      await prefs.setString('companyId', data.single.companyId!);
      await prefs.setString('uuId', data.single.userUuid!);

      if (data.single.image != null) {
        await prefs.setString('image', data.single.image!);
      }

      if (data.single.devicegroupUuid != null && security != true) {
        await prefs.setString('deviceId', data.single.devicegroupUuid!);
      }

      if (data.single.weigangroupUuid != null && security != true) {
        await prefs.setString('weiganId', data.single.weigangroupUuid!);
      }
    }
  } catch (error) {
    print(error);
    print("getInfo : no");
  }
}
