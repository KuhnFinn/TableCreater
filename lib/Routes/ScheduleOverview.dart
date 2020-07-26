import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_app/Schedule/MatchDay.dart';
import 'package:flutter_app/Schedule/Schedule.dart';
import 'package:flutter_app/Util.dart';
import 'package:flutter_app/data/Text.dart';

class ScheduleOverview extends StatefulWidget {
  static const routeName = '/scheduleOverview';

  @override
  State<StatefulWidget> createState() => ScheduleOverviewState();
}

class ScheduleOverviewState extends State<ScheduleOverview> {
  Schedule acSchedule;
  List<bool> cardCollapsed = [];

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
    for (int i = 0; i < acSchedule.matchDays.length; i++) {
      cardCollapsed.add(true);
      matchDayList.add(Card(
          child: Column(
        children: <Widget>[
          ListTile(
            title: Text(acSchedule.matchDays[i].name),
            subtitle: Text(formatDate(acSchedule.matchDays[i].start)),
            trailing: Icon(cardCollapsed[i]?Icons.keyboard_arrow_down:Icons.keyboard_arrow_up),
            onTap: () {
              setState(() {
                cardCollapsed[i] = !cardCollapsed[i];
              });
            },
          ),
          (cardCollapsed[i])
              ? Container()
              : Column(
                  children: <Widget>[
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: buildGameUI(acSchedule.matchDays[i]),
                    ),
                  ],
                )
        ],
      )));
    }
    return matchDayList;
  }

  Widget buildGameUI(MatchDay acMatchday) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
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
        if(acFixture==null){
          return;
        }
        returnRows.add(DataRow(cells: [
          DataCell(Text(formatClockTime(acRound.start))),
          DataCell(Text(acFixture.team1)),
          DataCell(Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 4.0, right: 4.0),
            child: Container(
              width: 54,
              child: TextFormField(
                maxLength: 3,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), counter: SizedBox.shrink()),
                initialValue: (acFixture.pointsTeam1 != null)
                    ? acFixture.pointsTeam1.toString()
                    : "",
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
            padding: const EdgeInsets.only(top: 6.0, left: 4.0, right: 4.0),
            child: Container(
              width: 54,
              child: TextFormField(
                maxLength: 3,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), counter: SizedBox.shrink()),
                initialValue: (acFixture.pointsTeam2 != null)
                    ? acFixture.pointsTeam2.toString()
                    : "",
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
