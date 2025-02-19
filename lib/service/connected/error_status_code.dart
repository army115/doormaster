import 'package:get/get.dart';

Future<String> handleErrorStatusOCR(int? statusCode) async {
  String message;
  switch (statusCode) {
    case 413:
      message = 'file_large'.tr;
      break;
    case 420:
      message = 'idcard_not_found'.tr;
      break;
    case 425:
      message = 'idcard_not_clear'.tr;
      break;
    default:
      message = 'can_not_scan'.tr;
  }
  return message;
}
