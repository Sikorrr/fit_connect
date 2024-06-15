import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

String formatTimestamp(Timestamp timestamp) {
  return DateFormat('hh:mm a').format(timestamp.toDate());
}

String formatDateTimestamp(Timestamp timestamp) {
  return DateFormat('yyyy-MM-dd').format(timestamp.toDate());
}

String formatWorkoutDate(Timestamp timestamp) {
  final date = timestamp.toDate();
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));
  final yesterday = today.subtract(const Duration(days: 1));

  if (DateFormat('yyyy-MM-dd').format(date) ==
      DateFormat('yyyy-MM-dd').format(today)) {
    return 'Today';
  } else if (DateFormat('yyyy-MM-dd').format(date) ==
      DateFormat('yyyy-MM-dd').format(tomorrow)) {
    return 'Tomorrow';
  } else if (DateFormat('yyyy-MM-dd').format(date) ==
      DateFormat('yyyy-MM-dd').format(yesterday)) {
    return 'Yesterday';
  } else {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
