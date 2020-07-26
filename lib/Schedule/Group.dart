class Group{
  List<Team> teams;

  Group([this.teams]){
    this.teams ??= [];
  }


  void add(String team){
    teams.add(new Team(team));
  }

  void addPoints(int points, String team){
    Team thisTeam = teams.firstWhere((acTeam){
      return acTeam.name==team;
    },orElse: (){
      return;
    });
    thisTeam.points+=points;
  }

  void reOrderbyPoints(){
    teams.sort((teamA, teamB)=>
      teamA.points.compareTo(teamB.points)
    );
  }
}

class Team{
  String name;
  int points;

  Team(this.name,[this.points=0]);
}