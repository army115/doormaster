// ignore_for_file: non_constant_identifier_names

import 'package:doormster/service/connected/api_path.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';

Search_Controller searchController = Search_Controller();

class Search_Controller {
  Future<List<Object>> get_HouseData(value) async {
    final values = await connectApi.callApi_getData(
        ip: IP_Address.emp_IP_server,
        path: VisitorPath.SearchHouse,
        loadingTime: 0,
        values: {"search_text": value},
        showError: () {
          return [];
        },
        showTimeout: () {
          return [];
        });
    if (values != null) {
      List data = values['data'];
      return data
          .map((item) => item['label'].toString())
          // "${'house_number'.tr} :${item['label'].split(': ').last}")
          .toList();
    } else {
      return [];
    }
  }
}
