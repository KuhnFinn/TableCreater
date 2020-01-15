import 'package:flutter/material.dart';
import 'package:flutter_app/Schedule/Championship.dart';
import 'package:flutter_app/Schedule/KoTournament.dart';
import 'package:flutter_app/data/Text.dart';
import 'package:flutter_app/Util.dart';


class Schedule{
  String name = "";
  DateTime start;
  String sport = str_lists_sports[0];

  List<String> teams;

  KoTournament actKoTournament = KoTournament();
  Championship actChampionship = Championship();
  String tournamentType = str_list_tournamentType[0];

  bool externRefery=true;
  Duration gameDuration = new Duration(minutes: 15);
  bool halftime = true;
  Duration halftimeDuration = new Duration(minutes: 5);
  String winCondition = str_list_winCondition[0];
  String setType = str_list_setType[0];
  int setQuantity;
  int pointsToWin;



  Schedule(String pName, DateTime pStart, String pSport){
    this.name = pName;
    this.start = pStart;
    this.sport =pSport;
  }
  Schedule.empty(){
    teams=[""];
    tournamentType=str_list_tournamentType[0];
  }

  Widget generateCard(){
    return Padding(padding:const EdgeInsets.all(4.0),
    child: Card(
      child: Column(
        children: <Widget>[
          Image.asset(_getSportPicturePath()),
          ListTile(
            title:  Text(name),
            subtitle: Text(formatDate(start)),
          ),
        ],
      ),
    ),);
  }
  String _getSportPicturePath(){
    String returnPath;
    switch(str_lists_sports.indexOf(sport)){
      case 0:
        returnPath = 'assets/images/Unknown.png';
        break;
      case 1:
        returnPath = 'assets/images/Fussball.png';
        break;
      case 2:
        returnPath = 'assets/images/Faustball.png';
        break;
      case 3:
        returnPath = 'assets/images/tennis.png';
        break;
      case 4:
        returnPath = 'assets/images/Volleyball.png';
        break;
    }
    return returnPath;
  }

  set setActKoTorunament(KoTournament newTournament){
    actKoTournament = newTournament;
    tournamentType = str_list_tournamentType[1];
  }

  set setActChampionship(Championship newChampionship){
    actChampionship = newChampionship;
    tournamentType = str_list_tournamentType[0];
  }

  void configurationDone(){
    switch(str_list_tournamentType.indexOf(tournamentType)){
      case 0:
        actChampionship.teams = teams;
        break;
      case 1:
        actKoTournament.teams = teams;
        break;
    }
  }
}


