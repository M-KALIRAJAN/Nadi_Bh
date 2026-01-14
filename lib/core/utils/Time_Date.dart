import 'package:intl/intl.dart';

String formatIsoDateForUI(String isoDate) {
  try {
    DateTime utcDateTime = DateTime.parse(isoDate);
    DateTime localDateTime = utcDateTime.toLocal();
    return DateFormat("d MMM yyyy, h:mm a").format(localDateTime);
  } catch (e) {
    return "-";
  }
}
