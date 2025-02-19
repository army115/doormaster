import 'package:intl/intl.dart';

class DateTimeUtils {
  static String format(String fullDate, String type) {
    if (type == 'D') {
      DateFormat formatDate = DateFormat('dd-MM-y');
      return formatDate.format(DateTime.parse(fullDate));
    } else {
      DateFormat formatTime = DateFormat('HH:mm');
      return formatTime.format(DateTime.parse(fullDate));
    }
  }
}
