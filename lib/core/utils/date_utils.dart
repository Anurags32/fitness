import 'package:intl/intl.dart';

class DateFmt {
  static String yMd(DateTime d) => DateFormat('yyyy-MM-dd').format(d);
}
