import 'package:flutter_app/Graph.dart';
import 'package:flutter_app/Schedule/Game.dart';
import 'package:flutter_app/Schedule/MatchDay.dart';
import 'package:flutter_app/Schedule/Round.dart';
import 'package:flutter_app/data/Text.dart';

class Schedule {
  String name;

  DateTime start;
  String sport;

  List<String> teams;

  String tournamentType;
  bool doubleRound;

  bool groupsEnable;

  List<String> groups;
  int groupQuantity;

  int koRoundQuantity;
  int untilPlace;

  bool externRefery;
  Duration gameDuration;
  bool halftime;
  Duration halftimeDuration;
  String winCondition;

  String setType;
  int setQuantity;
  int pointsToWin;

  List<MatchDay> matchDays ;

  Schedule(
      {this.name = "",
      this.start,
      this.sport,
      this.teams,
      this.tournamentType,
      this.doubleRound = false,
      this.groupsEnable = false,
      this.groups,
      this.groupQuantity,
      this.koRoundQuantity,
      this.untilPlace,
      this.externRefery = true,
      this.gameDuration = const Duration(minutes: 15),
      this.halftime = true,
      this.halftimeDuration = const Duration(minutes: 5),
      this.winCondition,
      this.setType,
      this.setQuantity,
      this.pointsToWin,
      this.matchDays}) {

    if (this.sport == null) {
      this.sport = str_lists_sports[0];
    }
    if (this.tournamentType == null) {
      this.tournamentType = str_list_tournamentType[0];
    }
    if (this.winCondition == null) {
      this.winCondition = str_list_winCondition[0];
    }
    if (this.setType == null) {
      this.setType = str_list_setType[0];
    }
    if (this.matchDays == null) {
      this.matchDays = [];
    }
    if (this.teams == null) {
      this.teams = [];
    }
  }

  Schedule.bsp() {
    this.name = "test1";
    this.start = DateTime.now();
    this.sport = str_lists_sports[2];
    this.teams = ["a", "b", "c", "d", "e", "f", "g", "h"];
    this.koRoundQuantity = 2;
    this.untilPlace = 6;
    this.groupQuantity = 2;
    this.groupsEnable = true;
    this.doubleRound = false;
    this.externRefery = true;
    this.gameDuration = Duration(minutes: 20);
    this.halftime = true;
    this.halftimeDuration = Duration(minutes: 3);
    this.winCondition = str_list_winCondition[0];
    this.matchDays=[];
    this.matchDays.add(new MatchDay(this.start, [new Round(this.start, [Fixture("Team A", "TeamB", "schiri"),Fixture("Team A", "TeamB", "schiri"),Fixture("Team A", "TeamB", "schiri"),])]));

    buildChamionchipFixtures();
  }

  String getSportPicturePath() {
    String returnPath;
    switch (str_lists_sports.indexOf(sport)) {
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

  void configurationDone() {}

  void buildChamionchipFixtures() {
    Graph acGraph;
    List<Node> allTeamNodes = [];

    teams.forEach((acTeam) {
      allTeamNodes.add(Node(acTeam));
    });
    acGraph = new Graph(allTeamNodes, []);
    acGraph.completeGraph();

    Edge acEdge;
    for (int i = 0; i < acGraph.edges.length; i++) {
      acEdge = acGraph.getMinNotMarkedEdge();
      acGraph.markEdge(acEdge);
      matchDays[0].rounds.add(new Round(this.start,[new Fixture(acEdge.firstNode.name, acEdge.secondNode.name, "schiri")]));
    }

    var lol = acGraph.edges[0];
  }
}
