import 'package:flutter_app/Schedule/Game.dart';

class Round{
  DateTime start;
  List<Fixture> fixtures;

  Round(int fields,[this.start, this.fixtures] ){
    fixtures = List<Fixture>(fields);
  }

  bool isPlaying(String team){
    bool returnPlaying = false;
    fixtures.forEach((acFixture){
      if(acFixture!=null&&(acFixture.team1 == team ||acFixture.team2 ==team)){
        returnPlaying=true;
      }
    });
    return returnPlaying;
  }
}