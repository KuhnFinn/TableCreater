class Game{
  DateTime start;

  String team1;
  String team2;
  int pointsTeam1;
  int pointsTeam2;

  String referee;

  String getWinner(){
    if (pointsTeam1>pointsTeam2){
      return team1;
    }
    else if(pointsTeam2>pointsTeam1){
      return team2;
    }
    return null;
  }
}