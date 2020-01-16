import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_app/Schedule/Game.dart';
import 'package:flutter_app/Schedule/Schedule.dart';
import 'package:flutter_app/data/Text.dart';

class ScheduleOverview extends StatefulWidget {
  static const routeName = '/scheduleOverview';

  @override
  State<StatefulWidget> createState() => ScheduleOverviewState();
}

class ScheduleOverviewState extends State<ScheduleOverview> {
  Schedule acSchedule;

  Game bspGame = Game();

  @override
  void initState() {
    super.initState();

    bspGame = Game.bsp();
  }

  @override
  Widget build(BuildContext context) {
    ScreenArguments args = ModalRoute.of(context).settings.arguments;
    acSchedule = args.acSchedule;
    return Scaffold(
      appBar: AppBar(
        title: Text(acSchedule.name),
      ),
      body: buildGameUI(bspGame),
    );
  }

  Widget buildGameUI(Game acGame) {
    return SizedBox.expand(
        child: DataTable(columnSpacing: 0, horizontalMargin: 10, columns: [
      DataColumn(label: Text(str_timeOfDay)),
      DataColumn(label: Text(str_firstTeam)),
      DataColumn(label: Text("")),
      DataColumn(label: Text(str_secondTeam)),
      DataColumn(label: Text("")),
      DataColumn(label: Text(str_referee)),
    ], rows: buildRows(),

    ));
  }
  List<DataRow> buildRows(){
    List<DataRow> returnRows =[];
    acSchedule.fixtures.forEach((game){
      returnRows.add(DataRow(cells: [
        DataCell(Text("${game.start.hour}:${game.start.minute}")),
        DataCell(Text(game.team1)),
        DataCell(Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextField(
              decoration: InputDecoration(border: OutlineInputBorder()),
            )
        )
        ),
        DataCell(Text(game.team2)),
        DataCell(Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextField(
              decoration: InputDecoration(border: OutlineInputBorder()),
            )
        )),
        DataCell(Text(game.referee)),
      ]));
    });
    return returnRows;
  }
}

class ScreenArguments {
  final Schedule acSchedule;

  ScreenArguments(this.acSchedule);
}
