import 'package:flutter_app/Schedule/Round.dart';

class MatchDay{
  DateTime start;
  List<Round> rounds;
  String name;

  MatchDay(this.start, this.rounds, this.name);
}