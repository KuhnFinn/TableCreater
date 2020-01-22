import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_app/Schedule/MatchDay.dart';
import 'package:flutter_app/Schedule/Schedule.dart';
import 'package:flutter_app/data/Text.dart';

class ScheduleOverview extends StatefulWidget {
  static const routeName = '/scheduleOverview';

  @override
  State<StatefulWidget> createState() => ScheduleOverviewState();
}

class ScheduleOverviewState extends State<ScheduleOverview> {
  Schedule acSchedule;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenArguments args = ModalRoute.of(context).settings.arguments;
    acSchedule = args.acSchedule;
    return Scaffold(
      appBar: AppBar(
        title: Text(acSchedule.name),
      ),
      body: ListView(children: buildCardList()),
    );
  }

  List<Card> buildCardList() {
    List<Card> matchDayList = [];
    acSchedule.matchDays.forEach((acMatchday) {
      matchDayList.add(Card(
        child: buildGameUI(acMatchday),
      ));
    });
    return matchDayList;
  }

  Widget buildGameUI(MatchDay acMatchday) {
    return SingleChildScrollView(
      child: DataTable(
        columnSpacing: 0,
        horizontalMargin: 10,
        columns: [
          DataColumn(label: Text(str_timeOfDay)),
          DataColumn(label: Text(str_firstTeam)),
          DataColumn(label: Text(str_points)),
          DataColumn(label: Text(str_secondTeam)),
          DataColumn(label: Text(str_points)),
          DataColumn(label: Text(str_referee)),
        ],
        rows: buildRows(acMatchday),
      ),
    );
  }

  List<DataRow> buildRows(MatchDay acMatchday) {
    List<DataRow> returnRows = [];
    acMatchday.rounds.forEach((acRound) {
      acRound.fixtures.forEach((acFixture) {
        returnRows.add(DataRow(cells: [
          DataCell(Text("${acRound.start.hour}:${acRound.start.minute}")),
          DataCell(Text(acFixture.team1)),
          DataCell(Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Container(
              width: 54,
              child: TextFormField(
                maxLength: 3,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), counter: SizedBox.shrink()),
                initialValue:
                (acFixture.pointsTeam1 != null) ? acFixture.pointsTeam1.toString() : "",
                onChanged: (value) {
                  if (value.isEmpty) {
                    acFixture.pointsTeam1 = null;
                  } else {
                    acFixture.pointsTeam1 = int.parse(value);
                  }
                },
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[0-9]|^\$")),
                ],
                keyboardType: TextInputType.number,
              ),
            ),
          )),
          DataCell(Text(acFixture.team2)),
          DataCell(Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Container(
              width: 54,
              child: TextFormField(
                maxLength: 3,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), counter: SizedBox.shrink()),
                initialValue:
                (acFixture.pointsTeam2 != null) ? acFixture.pointsTeam2.toString() : "",
                onChanged: (value) {
                  if (value.isEmpty) {
                    acFixture.pointsTeam2 = null;
                  } else {
                    acFixture.pointsTeam2 = int.parse(value);
                  }
                },
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[0-9]|^\$")),
                ],
                keyboardType: TextInputType.number,
              ),
            ),
          )),
          DataCell(Text(acFixture.referee)),
        ]));
      });
    });

    return returnRows;
  }
}

class ScreenArguments {
  final Schedule acSchedule;

  ScreenArguments(this.acSchedule);
}
