import 'package:flutter_app/Schedule/Championship.dart';
import 'package:flutter_app/Schedule/Tournament.dart';
import 'package:flutter_app/data/Text.dart';

class KoTournament extends Tournament{

  bool groupsEnable = false;
  List<Championship> groups;
  int groupQuantity ;
  int koRoundQuantity;
  int untilPlace;

  KoTournament(){
    this.type=str_list_tournamentType[1];
  }

}