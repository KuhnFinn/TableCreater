class Fixture {
  String team1;
  String team2;
  int pointsTeam1;
  int pointsTeam2;

  String referee;

  Fixture(this.team1, this.team2, this.referee);

  Fixture.bsp() {
    this.team1 = "Team A";
    this.team2 = "Team B";
    this.pointsTeam1 = 10;
    this.pointsTeam2 = 30;
    this.referee = "schiri";
  }

  String getWinner() {
    this.pointsTeam1 ??=0;
    this.pointsTeam2 ??=0;
    if (pointsTeam1 > pointsTeam2) {
      return team1;
    } else if (pointsTeam2 > pointsTeam1) {
      return team2;
    }
    return null;
  }
}
