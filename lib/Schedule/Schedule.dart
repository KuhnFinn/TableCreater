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
    this.matchDays=[new MatchDay(this.start,[],"Spieltag 1"),new MatchDay(this.start,[], "Spieltag 2")];

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
/// builds the whole Schedule when the Configuration is done
  void configurationDone() {
    switch(str_list_tournamentType.indexOf(this.tournamentType)){
      case 0:
        buildChamionchipFixtures();
        break;
      case 1:
        buildKoFxtures();
        break;
    }
  }

  ///creates all Fixtures for the given configuration to play a championship
  void buildChamionchipFixtures() {
    Graph acGraph;
    List<Node> allTeamNodes = [];
    List<Graph> matchDayGraph =[];

    teams.forEach((acTeam) {
      allTeamNodes.add(Node(acTeam));
    });
    acGraph = new Graph(allTeamNodes, []);
    acGraph.completeGraph();
    matchDayGraph = acGraph.getSubgraphs(this.matchDays.length);

    for(int i=0; i<this.matchDays.length;i++){
      Graph acSubgraph = matchDayGraph[i];
      while(!acSubgraph.isEveryEdgeMarked()){
        Edge nextEdgeToMark;
        acSubgraph.edges.forEach((acEdge){
          if(!acEdge.marked){
            if(nextEdgeToMark==null){
              nextEdgeToMark=acEdge;
            }
            else{
              if(acEdge.value<nextEdgeToMark.value){
                nextEdgeToMark=acEdge;
              }
              else if(acEdge.value==nextEdgeToMark.value){
                if(acEdge.getDegreeOfNodes()>nextEdgeToMark.getDegreeOfNodes()){
                  nextEdgeToMark=acEdge;
                }
              }
            }
          }
        });
        acSubgraph.markEdge(nextEdgeToMark);
        this.matchDays[i].rounds.add(new Round(this.start, [new Fixture(nextEdgeToMark.firstNode.name, nextEdgeToMark.secondNode.name, "schiri")]));
      }
    }
  }
  ///creates all Fixtures for the given configuration to play a KO-Tournament
  void buildKoFxtures(){

  }
}
