import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String format(String isoDate) {
    try {
      final date = DateTime.parse(isoDate).toLocal();
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';

      return DateFormat('MMM d, yyyy').format(date);
    } catch (_) {
      return isoDate;
    }
  }
}