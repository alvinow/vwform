import 'package:flutter/material.dart';

/// Utility class for converting between DateTime and TimeOfDay
class VwFormDateTimeUtils {
  /// Converts a DateTime to TimeOfDay
  ///
  /// Extracts the hour and minute from the DateTime object
  ///
  /// Example:
  /// ```dart
  /// DateTime dateTime = DateTime(2024, 11, 16, 14, 30, 45);
  /// TimeOfDay time = DateTimeUtils.dateTimeToTimeOfDay(dateTime);
  /// // time.hour = 14, time.minute = 30
  /// ```
  static TimeOfDay dateTimeToTimeOfDay(DateTime dateTime) {
    return TimeOfDay(
      hour: dateTime.hour,
      minute: dateTime.minute,
    );
  }

  /// Converts a TimeOfDay to DateTime
  ///
  /// Combines TimeOfDay with a date (defaults to today)
  /// Seconds and milliseconds are set to 0
  ///
  /// Example:
  /// ```dart
  /// TimeOfDay time = TimeOfDay(hour: 14, minute: 30);
  /// DateTime dateTime = DateTimeUtils.timeOfDayToDateTime(time);
  /// // dateTime = DateTime(today's date, 14, 30, 0)
  /// ```
  static DateTime timeOfDayToDateTime(
      TimeOfDay time, {
        DateTime? date,
      }) {
    final now = date ?? DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
  }

  /// Converts a TimeOfDay to DateTime with specific date
  ///
  /// Example:
  /// ```dart
  /// TimeOfDay time = TimeOfDay(hour: 14, minute: 30);
  /// DateTime specificDate = DateTime(2024, 12, 25);
  /// DateTime dateTime = DateTimeUtils.timeOfDayToDateTimeWithDate(time, specificDate);
  /// // dateTime = DateTime(2024, 12, 25, 14, 30, 0)
  /// ```
  static DateTime timeOfDayToDateTimeWithDate(
      TimeOfDay time,
      DateTime date,
      ) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  /// Combines a date from one DateTime and time from TimeOfDay
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime(2024, 12, 25);
  /// TimeOfDay time = TimeOfDay(hour: 14, minute: 30);
  /// DateTime result = DateTimeUtils.combineDateAndTime(date, time);
  /// // result = DateTime(2024, 12, 25, 14, 30, 0)
  /// ```
  static DateTime combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  /// Extracts date part from DateTime (time set to midnight)
  ///
  /// Example:
  /// ```dart
  /// DateTime dateTime = DateTime(2024, 11, 16, 14, 30, 45);
  /// DateTime dateOnly = DateTimeUtils.dateOnly(dateTime);
  /// // dateOnly = DateTime(2024, 11, 16, 0, 0, 0)
  /// ```
  static DateTime dateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  /// Formats TimeOfDay to string
  ///
  /// Example:
  /// ```dart
  /// TimeOfDay time = TimeOfDay(hour: 14, minute: 30);
  /// String formatted = DateTimeUtils.formatTimeOfDay(time);
  /// // formatted = "14:30"
  ///
  /// String formatted12h = DateTimeUtils.formatTimeOfDay(time, use24Hour: false);
  /// // formatted12h = "02:30 PM"
  /// ```
  static String formatTimeOfDay(TimeOfDay time, {bool use24Hour = true}) {
    if (use24Hour) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
    }
  }

  /// Parses a time string to TimeOfDay
  ///
  /// Supports formats: "HH:mm", "H:mm", "HH:mm:ss"
  ///
  /// Example:
  /// ```dart
  /// TimeOfDay time1 = DateTimeUtils.parseTimeOfDay("14:30");
  /// // time1 = TimeOfDay(hour: 14, minute: 30)
  ///
  /// TimeOfDay time2 = DateTimeUtils.parseTimeOfDay("9:05");
  /// // time2 = TimeOfDay(hour: 9, minute: 5)
  /// ```
  static TimeOfDay? parseTimeOfDay(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length < 2) return null;

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        return null;
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return null;
    }
  }

  /// Compares two TimeOfDay objects
  ///
  /// Returns:
  /// - negative value if time1 is before time2
  /// - 0 if they are equal
  /// - positive value if time1 is after time2
  ///
  /// Example:
  /// ```dart
  /// TimeOfDay time1 = TimeOfDay(hour: 14, minute: 30);
  /// TimeOfDay time2 = TimeOfDay(hour: 15, minute: 0);
  /// int result = DateTimeUtils.compareTimeOfDay(time1, time2);
  /// // result < 0 (time1 is before time2)
  /// ```
  static int compareTimeOfDay(TimeOfDay time1, TimeOfDay time2) {
    if (time1.hour != time2.hour) {
      return time1.hour - time2.hour;
    }
    return time1.minute - time2.minute;
  }

  /// Checks if time1 is before time2
  ///
  /// Example:
  /// ```dart
  /// TimeOfDay time1 = TimeOfDay(hour: 14, minute: 30);
  /// TimeOfDay time2 = TimeOfDay(hour: 15, minute: 0);
  /// bool isBefore = DateTimeUtils.isTimeBefore(time1, time2);
  /// // isBefore = true
  /// ```
  static bool isTimeBefore(TimeOfDay time1, TimeOfDay time2) {
    return compareTimeOfDay(time1, time2) < 0;
  }

  /// Checks if time1 is after time2
  ///
  /// Example:
  /// ```dart
  /// TimeOfDay time1 = TimeOfDay(hour: 15, minute: 0);
  /// TimeOfDay time2 = TimeOfDay(hour: 14, minute: 30);
  /// bool isAfter = DateTimeUtils.isTimeAfter(time1, time2);
  /// // isAfter = true
  /// ```
  static bool isTimeAfter(TimeOfDay time1, TimeOfDay time2) {
    return compareTimeOfDay(time1, time2) > 0;
  }

  /// Adds minutes to a TimeOfDay
  ///
  /// Example:
  /// ```dart
  /// TimeOfDay time = TimeOfDay(hour: 14, minute: 30);
  /// TimeOfDay newTime = DateTimeUtils.addMinutes(time, 45);
  /// // newTime = TimeOfDay(hour: 15, minute: 15)
  /// ```
  static TimeOfDay addMinutes(TimeOfDay time, int minutes) {
    final dateTime = timeOfDayToDateTime(time);
    final newDateTime = dateTime.add(Duration(minutes: minutes));
    return dateTimeToTimeOfDay(newDateTime);
  }

  /// Subtracts minutes from a TimeOfDay
  ///
  /// Example:
  /// ```dart
  /// TimeOfDay time = TimeOfDay(hour: 14, minute: 30);
  /// TimeOfDay newTime = DateTimeUtils.subtractMinutes(time, 45);
  /// // newTime = TimeOfDay(hour: 13, minute: 45)
  /// ```
  static TimeOfDay subtractMinutes(TimeOfDay time, int minutes) {
    final dateTime = timeOfDayToDateTime(time);
    final newDateTime = dateTime.subtract(Duration(minutes: minutes));
    return dateTimeToTimeOfDay(newDateTime);
  }

  /// Calculates the difference in minutes between two TimeOfDay objects
  ///
  /// Example:
  /// ```dart
  /// TimeOfDay time1 = TimeOfDay(hour: 14, minute: 30);
  /// TimeOfDay time2 = TimeOfDay(hour: 16, minute: 45);
  /// int diff = DateTimeUtils.differenceInMinutes(time1, time2);
  /// // diff = 135 (2 hours and 15 minutes)
  /// ```
  static int differenceInMinutes(TimeOfDay time1, TimeOfDay time2) {
    final dt1 = timeOfDayToDateTime(time1);
    final dt2 = timeOfDayToDateTime(time2);
    return dt2.difference(dt1).inMinutes;
  }
}