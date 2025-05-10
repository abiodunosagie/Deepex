import 'package:intl/intl.dart';

class DateTimeUtils {
  static String humanReadableDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return '$diff days ago';

    return DateFormat('dd MMM, yyyy').format(date);
  }
}
