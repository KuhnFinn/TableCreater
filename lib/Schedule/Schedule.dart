import 'dart:math';

import 'package:flutter_app/Graph.dart';
import 'package:flutter_app/Schedule/Game.dart';
import 'package:flutter_app/Schedule/Group.dart';
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

  List<Group> groups;
  int groupQuantity;

  int koRoundQuantity;
  int untilPlace;

  bool externRefery;
  Duration gameDuration;
  bool halftime;
  Duration halftimeDuration;
  String winCondition;

  List<MatchDay> matchDays;

  Schedule({this.name = "",
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
    if (this.matchDays == null) {
      this.matchDays = [];
    }
    if (this.teams == null) {
      this.teams = [];
    }
  }

  Schedule.bsp() {
    this.name = "Test";
    this.start = DateTime.now();
    this.sport = str_lists_sports[0];
    this.teams = ["a", "b", "c", "d", "e", "f", "g", "h"];
    this.tournamentType = str_list_tournamentType[1];
    this.koRoundQuantity = 2;
    this.untilPlace = 6;
    this.groupQuantity = 2;
    this.groupsEnable = true;
    this.doubleRound = true;
    this.externRefery = false;
    this.gameDuration = Duration(minutes: 20);
    this.halftime = true;
    this.halftimeDuration = Duration(minutes: 5);
    this.winCondition = str_list_winCondition[0];
    this.matchDays = [
      new MatchDay(this.start, [], "Spieltag 1", 2),
      new MatchDay(this.start, [], "Spieltag 2", 1),
      new MatchDay(this.start, [], "Spieltag 3", 1),
    ];

    configurationDone();
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
    switch (str_list_tournamentType.indexOf(this.tournamentType)) {
      case 0:
        buildChampionchipFixtures();
        break;
      case 1:
        buildKoFixtures();
        break;
    }
    setTimingofRounds();
    if(!this.externRefery){
      findReferres();
    }
    setStart();
  }

  ///creates all Fixtures for the given configuration to play a championship
  void buildChampionchipFixtures() {
    Graph acGraph;
    List<Node> allTeamNodes = [];
    List<Graph> matchDayGraphs = [];
    int roundIndex = 0;
    List<int> noGamePlayed = List(teams.length);

    teams.forEach((acTeam) {
      allTeamNodes.add(Node(acTeam));
    });
    acGraph = new Graph(allTeamNodes, []);
    acGraph.completeGraph();

    if (!this.doubleRound) {
      matchDayGraphs = acGraph.getSubgraphs(this.getMatchdaysWeights());
    }
    else {
      List<List<int>> acWeights = this.getMatchdaysWeightsDoubleRound();
      matchDayGraphs = acGraph.getSubgraphs(acWeights[0]);
      acGraph.clearMarksAndValues();
      matchDayGraphs = acGraph.getSubgraphs(acWeights[1], matchDayGraphs);
    }

    for (int i = 0; i < this.matchDays.length; i++) {
      noGamePlayed.fillRange(0, noGamePlayed.length,0);
      this.matchDays[i].rounds = [new Round(this.matchDays[i].fields)];
      roundIndex = 0;
      Graph acSubgraph = matchDayGraphs[i];
      acSubgraph.edges.shuffle();
      while (!acSubgraph.isEveryEdgeMarked()) {
        Edge nextEdgeToMark;
        acSubgraph.edges.forEach((acEdge) {
          if (!acEdge.marked) {
            if (nextEdgeToMark == null) {
              nextEdgeToMark = acEdge;
            }
            else {
              if (acEdge.value < nextEdgeToMark.value) {
                nextEdgeToMark = acEdge;
              }
              else if (acEdge.value == nextEdgeToMark.value) {
                if (acEdge.getDegreeOfNodes() >
                    nextEdgeToMark.getDegreeOfNodes()) {
                  nextEdgeToMark = acEdge;
                }
                else if(acEdge.getDegreeOfNodes() ==
                    nextEdgeToMark.getDegreeOfNodes()){
                  if(noGamePlayed[acSubgraph.nodes.indexOf(acEdge.firstNode)]+noGamePlayed[acSubgraph.nodes.indexOf(acEdge.secondNode)]>noGamePlayed[acSubgraph.nodes.indexOf(nextEdgeToMark.firstNode)]+noGamePlayed[acSubgraph.nodes.indexOf(nextEdgeToMark.secondNode)]){
                    nextEdgeToMark = acEdge;
                  }
                }
              }
            }
          }
        });
        acSubgraph.markEdge(nextEdgeToMark);
        noGamePlayed= _increaseAllExcept(noGamePlayed, [acSubgraph.nodes.indexOf(nextEdgeToMark.firstNode), acSubgraph.nodes.indexOf(nextEdgeToMark.secondNode)]);
        if (this.matchDays[i].rounds.last.fixtures.last == null) {
          this.matchDays[i].rounds.last.fixtures[roundIndex] = new Fixture(
              nextEdgeToMark.firstNode.name, nextEdgeToMark.secondNode.name,
              "extern");
        }
        else {
          this.matchDays[i].rounds.add(new Round(this.matchDays[i].fields));
          this.matchDays[i].rounds.last.fixtures[0] = new Fixture(
              nextEdgeToMark.firstNode.name, nextEdgeToMark.secondNode.name,
              "extern");
        }
        roundIndex = (roundIndex + 1) % this.matchDays[i].fields;
      }
    }
  }

  ///creates all Fixtures for the given configuration to play a KO-Tournament
  void buildKoFixtures() {
    List<Graph> groupGraphes;
    List<Fixture> allFixture =[];

    if(this.groupsEnable){
      buildGroups();
      groupGraphes = buildGroupGraphes();
      allFixture =fillGroupFixtures(groupGraphes);
    }

  //  allFixture.addAll(fillKOFixtures());

    splitFixturesToMatchdays(allFixture);

  }

  ///sets a clock time or all fixtures
  void setTimingofRounds() {
    this.matchDays.forEach((acMatchDay) {
      acMatchDay.rounds.forEach((acRound) {
        acRound.start = acMatchDay.start.add(
            (this.gameDuration + this.halftimeDuration) *
                acMatchDay.rounds.indexOf(acRound));
      });
    });
  }

  ///get a list of the Weights depending on the fields of each Matchday
  List<int> getMatchdaysWeights() {
    List<int> returnList = List(this.matchDays.length);
    for (int i = 0; i < this.matchDays.length; i++) {
      returnList[i] = this.matchDays[i].fields;
    }
    return returnList;
  }

  ///get a list of the Weights depending on the fields of each Matchday for a double Round
  List<List<int>> getMatchdaysWeightsDoubleRound() {
    List<List<int>> returnList = [
      List(this.matchDays.length),
      List(this.matchDays.length)
    ];
    returnList[0].fillRange(0, returnList[0].length, 0);
    returnList[1].fillRange(0, returnList[1].length, 0);
    List<int> singleWeight = getMatchdaysWeights();
    int fullWeight = 0,
        index = 0,
        round = 0;
    singleWeight.forEach((acWeight) => fullWeight = fullWeight + acWeight);
    if (fullWeight % 2 != 0) {
      for (int i = 0; i < singleWeight.length; i++) {
        singleWeight[i] = singleWeight[i] * 2;
      }
      fullWeight = fullWeight * 2;
    }
    for (int i = 1; i <= fullWeight; i++) {
      if (returnList[0][index]+returnList[1][index] < singleWeight[index]) {
        returnList[round][index]++;
      }
      else {
        index++;
        returnList[round][index]++;
      }
      if (i == fullWeight / 2) {
        round = 1;
      }
    }
    return returnList;
  }

  ///Increase all Integer of [oldList]
  ///
  ///The Integer with Index in [except] are set to 0
  List<int> _increaseAllExcept(List<int> oldList, [List<int> except]) {
    for (int i = 0; i < oldList.length; i++) {
      oldList[i]++;
    }
    except.forEach((acIndex){
      oldList[acIndex]=0;
    });
    return oldList;
  }

  ///Choose a Referee for every fixture
  void findReferres(){
    List<int> sinceLastRef =List(this.teams.length);
    sinceLastRef.fillRange(0, sinceLastRef.length,0);
    int acReferee;

    this.matchDays.forEach((acMatchday){
      acMatchday.rounds.forEach((acRound){
        acRound.fixtures.forEach((acFixture){
          if(acFixture != null){
            for(int i=0;i<sinceLastRef.length;i++){
              if(!acRound.isPlaying(this.teams[i])){
                acReferee ??= i;
                if(sinceLastRef[i]>sinceLastRef[acReferee]){
                  acReferee=i;
                }
              }
            }
            acFixture.referee=this.teams[acReferee];
            sinceLastRef=_increaseAllExcept(sinceLastRef, [acReferee]);
          }
        });
      });
    });
  }

  ///split the teams into the groups
  void buildGroups(){
    List<String> popTeams = []..addAll(this.teams);
    int groupIndex=0;
    this.groups=List<Group>(groupQuantity);
    for(int i =0;i<this.groups.length;i++){
      this.groups[i]=new Group();
    }
    while(popTeams.isNotEmpty){
      popTeams.shuffle();
      this.groups[groupIndex].add(popTeams.last);
      popTeams.removeLast();
      groupIndex=(groupIndex+1)%this.groups.length;
    }
  }

  List<Graph> buildGroupGraphes(){

    List<Graph> groupGraphes =new List<Graph>(this.groups.length);
    for (int i=0;i<this.groups.length;i++){
      groupGraphes[i]=new Graph([], []);
      this.groups[i].teams.forEach((acTeam){
        groupGraphes[i].nodes.add(new Node(acTeam.name));
      });
      groupGraphes[i].completeGraph();
    }
    return groupGraphes;
  }

  bool allEdgesmarked(List<Graph> graphes){
    return graphes.every((acGraph){
      return acGraph.isEveryEdgeMarked();
    });
  }

  List<Fixture> fillGroupFixtures(List<Graph> groupGraphes) {
    List<Fixture> returnFixture = [];
    int groupIndex = 0;
    Edge acEdge;

    while (!allEdgesmarked(groupGraphes)) {
      if (!groupGraphes[groupIndex].isEveryEdgeMarked()) {
        acEdge = groupGraphes[groupIndex].getMinNotMarkedEdge();
        groupGraphes[groupIndex].markEdge(acEdge);
        returnFixture.add(new Fixture(
            acEdge.firstNode.name, acEdge.secondNode.name, "extern"));
      }
      groupIndex = (groupIndex + 1) % groupGraphes.length;
    }
    return returnFixture;
  }

  List<Fixture> fillKOFixtures(){

    List<String> forKoQualified;

    if(this.groupsEnable){
      forKoQualified = getQualified();
    }
    else{
      forKoQualified = this.teams.getRange(0, this.teams.length);
    }
    return buildPairs(forKoQualified);
  }

  List<String> getQualified(){
    List<String> forKoQualified;
    int groupIndex =0, placeIndex=0;

    forKoQualified = new List(pow(2,koRoundQuantity));
    this.groups.forEach((acGroup){
      acGroup.reOrderbyPoints();
    });
    while (forKoQualified.contains(null)){
      forKoQualified.add(this.groups[groupIndex].teams[placeIndex].name);
      groupIndex++;
      if(groupIndex==this.groups.length){
        groupIndex=0;
        placeIndex++;
      }
    }
  }

  List<Fixture> buildPairs(List<String> forKoQualified){

  }

  List<int> getGamesperDay(List<Fixture> fixtures){
    List<int> weights= getMatchdaysWeights(), gamesPerDay=[];
    int fullWeight = 0, matchesPerWeight;
    weights.forEach((acWeight) => fullWeight = fullWeight + acWeight);
    matchesPerWeight = fixtures.length~/fullWeight;
    weights.forEach((acWeight)=>gamesPerDay.add(acWeight*matchesPerWeight));

    int weightLeft = fixtures.length%fullWeight, index = gamesPerDay.length-1;
    while(weightLeft>0){
      gamesPerDay[index]+= weights[(weights[index]<weightLeft)?weights[index]:weightLeft];
      weightLeft-=weights[index];
      index--;
    }
    return gamesPerDay;
  }

  void splitFixturesToMatchdays(List<Fixture> fixtures){
    List <int> gamesPerDay = getGamesperDay(fixtures);
    int roundIndex;

    for(int i=0;i<gamesPerDay.length;i++){
      while(gamesPerDay[i]>0){

        if(this.matchDays[i].rounds.isNotEmpty&&this.matchDays[i].rounds.last.fixtures.last==null&&!this.matchDays[i].rounds.last.isPlaying(fixtures[0].team1)&&!this.matchDays[i].rounds.last.isPlaying(fixtures[0].team2)){
          this.matchDays[i].rounds.last.fixtures[roundIndex]=fixtures[0];
          roundIndex++;
        }
        else{
          this.matchDays[i].rounds.add(new Round(this.matchDays[i].fields));
          this.matchDays[i].rounds.last.fixtures[0]=fixtures[0];
          roundIndex=1;
        }
        fixtures.removeAt(0);
        gamesPerDay[i]--;
      }
    }
    return;
  }

  List<Fixture> buildKOs(List<String> teams){
    int i=0;
    int j =teams.length-1;
    List<Fixture> acFixtures=[];
    List<String> nextTeams=[];

    while(i<j){
      acFixtures.add(new Fixture(teams[i], teams[j], "extern"));
    }

    for(int i=0; i<teams.length/2;i++){
      nextTeams.add(acFixtures[i].getWinner());
    }

    acFixtures.addAll(buildKOs(nextTeams));
    return acFixtures;
  }

  void setStart(){
    this.start = matchDays[0].start;
    this.matchDays.forEach((acDay){
      if(acDay.start.isBefore(this.start)){
        this.start=acDay.start;
      }
    });
  }
}