import 'package:intl/intl.dart';

final moneyFormatter = NumberFormat.simpleCurrency(
  locale: 'en_CA',
  name: 'CAD',
);

final dateFormatter = DateFormat.yMMMEd();

final timeFormatter = DateFormat.jm();

final militaryTimeFormatter = DateFormat.Hm();

String formatDuration(Duration d) {
  final hours = d.inMinutes / 60.0;
  return hours % 1 == 0 ? "${hours.toInt()}H" : "${hours.toStringAsFixed(1)}H";
}

String formatShortDate(DateTime d) => DateFormat.MMMd().format(d);
