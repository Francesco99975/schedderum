import 'package:intl/intl.dart';

final moneyFormatter = NumberFormat.simpleCurrency(
  locale: 'en_CA',
  name: 'CAD',
);

final dateFormatter = DateFormat.yMMMEd();

final timeFormatter = DateFormat.jm();

final militaryTimeFormatter = DateFormat.Hm();
