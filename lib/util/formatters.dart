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

Duration regulatedDuration(
  Duration duration,
  double brakeFrequencyHours,
  double breakDurationHours,
) {
  // Handle edge cases
  if (duration <= Duration.zero ||
      brakeFrequencyHours <= 0 ||
      breakDurationHours <= 0) {
    return duration;
  }

  // Convert hours to Duration
  Duration brakeFrequency =
      Duration(hours: brakeFrequencyHours.floor()) +
      Duration(minutes: ((brakeFrequencyHours % 1) * 60).round());
  Duration breakDuration =
      Duration(hours: breakDurationHours.floor()) +
      Duration(minutes: ((breakDurationHours % 1) * 60).round());

  // Calculate number of breaks
  int numberOfBreaks =
      (duration.inMilliseconds / brakeFrequency.inMilliseconds).floor();

  // Calculate total break time
  Duration totalBreakTime = breakDuration * numberOfBreaks;

  // Calculate regulated duration
  Duration regulatedDuration = duration - totalBreakTime;

  // Ensure duration doesn't go negative
  return regulatedDuration < Duration.zero ? Duration.zero : regulatedDuration;
}
