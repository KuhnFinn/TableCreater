import 'package:flutter/material.dart';
import 'package:flutter_app/data/Text.dart';

///Formats a String for a german representation of the given [date]
String formatDate(DateTime date) {
  String returnDate = "";
  if (date != null) {
    switch (date.difference((DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))).inDays)
    {case 0:
        returnDate = "$str_today $str_at ${date.hour.toString()}:${date.minute<10 ?"0":""+date.minute.toString()} $str_clock";
        break;
      case 1:
        returnDate =
        "$str_tomorrow $str_at ${date.hour.toString()}:${date.minute<10 ?"0":""+date.minute.toString()} $str_clock";
        break;
      default:
        returnDate =
        "${str_weekdays[date.weekday - 1]}, ${date.day.toString()}.${date.month
            .toString()}.${date.year.toString()}";
    }
  }
  return returnDate;
}
///Formats a String for a german representation of the given [dur]
String formatDuration(Duration dur) {
  String returnDur = "${dur.inHours}:" + ((dur.inMinutes - (dur.inHours) * 60 < 10) ? "0" : "") + "${dur.inMinutes - (dur.inHours) * 60} h";
  if (dur.inHours < 1) {
    returnDur = "${dur.inMinutes} " + str_minutes;
  }
  return returnDur;
}

///Formats a String for a german representation of the given [time]
String formatClockTime(DateTime time){
  return "${(time.hour<10?"0":"")+time.hour.toString()}:${(time.minute<10?"0":"")+time.minute.toString()}";
}

///shows a Picker to pick a Date
Future<DateTime> selectDate(var context) {
  return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(2030),
      locale: Localizations.localeOf(context));
}

///shows a Picker to pick a Time
Future<TimeOfDay> selectTime(var context) {
  return showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
}
