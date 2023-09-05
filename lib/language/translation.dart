import 'package:doormster/language/en.dart';
import 'package:doormster/language/th.dart';
import 'package:get/get.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en_US,
        'th_TH': th_TH,
      };
}
