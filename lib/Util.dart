import 'package:flutter/material.dart';
import 'package:flutter_app/data/Text.dart';

String formatDate (DateTime Date){
  String returnDate;
  switch(Date.difference((DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))).inDays){
    case 0:
      returnDate = str_today + " um " + Date.hour.toString() + ":" + Date.minute.toString()+ "Uhr";
      break;
    case 1:
      returnDate =str_tomorrow + " um " + Date.hour.toString() + ":" + Date.minute.toString()+"Uhr";
      break;
    default:
      returnDate = "${str_weekdays[Date.weekday-1]}, "+Date.day.toString()+"."+Date.month.toString()+"."+Date.year.toString();
  }
  return returnDate;
}

String formatDuration(Duration dur){
  String returnDur = "${dur.inHours}:"+((dur.inMinutes-(dur.inHours)*60<10)?"0":"")+"${dur.inMinutes-(dur.inHours)*60} h";
  if(dur.inHours<1){
    returnDur ="${dur.inMinutes} "+str_minutes;
  }
  return returnDur;

}

Future<DateTime> selectDate(var context) {
  return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
      locale: Localizations.localeOf(context));
}

Future<TimeOfDay> selectTime(var context) {
  return showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
}