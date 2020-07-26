import 'package:flutter_app/Schedule/Round.dart';

class MatchDay{
  DateTime start;
  List<Round> rounds;
  String name;
  int fields;

  MatchDay(this.start, this.rounds, this.name, this.fields);
}