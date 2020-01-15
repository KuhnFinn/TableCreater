import 'package:flutter_app/Schedule/Tournament.dart';
import 'package:flutter_app/data/Text.dart';

class Championship extends Tournament{

  bool doubleRound =false;

  Championship() {
    this.type = str_list_tournamentType[0];
  }



}