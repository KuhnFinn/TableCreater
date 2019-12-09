import 'package:flutter/material.dart';
import 'package:flutter_app/data/Text.dart';


class Schedule{
  String name;
  DateTime start;
  DateTime end;
  String sport;

  Schedule(String pName, DateTime pStart, DateTime pEnd, String pSport){
    this.name = pName;
    this.start = pStart;
    this.end = pEnd;
    this.sport =pSport;
  }
  Card generateCard(){
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset('assets/images/Fußball_klein.png'),
          ListTile(
            title:  Text(name),
            subtitle: Text(formatDate(start)),
          ),
        ],
      ),
    );
  }

  String formatDate (DateTime Date){
    String returnDate;
    Date.day;
    switch(Date.difference((DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))).inDays){
      case 0:
        returnDate = str_today + " um " + Date.hour.toString() + ":" + Date.minute.toString();
        break;
      case 1:
        returnDate =str_tomorrow;
        break;
      default:
        returnDate = "${str_weekdays[Date.weekday-1]}, "+Date.day.toString()+"."+Date.month.toString()+"."+Date.year.toString();
    }
    return returnDate;

  }


}