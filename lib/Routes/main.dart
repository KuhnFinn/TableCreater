import 'package:flutter/material.dart';

import 'package:flutter_app/Routes/CreateSchedule.dart';
import 'package:flutter_app/Routes/ScheduleOverview.dart';
import 'package:flutter_app/data/Text.dart';
import 'package:flutter_app/Schedule/Schedule.dart';

import '../Util.dart';

List<Schedule> allSchedules = [];

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: str_app_titel,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: str_app_titel),
      routes: {
        ScheduleOverview.routeName: (context) => ScheduleOverview(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    allSchedules.add(Schedule.bsp());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: createCardList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateSchedule()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  List<Widget> createCardList() {
    List<Widget> allCards = [];
    if (allSchedules.isNotEmpty) {
      allSchedules.sort((a,b)=>a.start.compareTo(b.start));
      allSchedules.forEach((sched) {
        allCards.add(Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            clipBehavior: Clip.antiAlias,
              child: InkWell(
            child: Column(
              children: <Widget>[
                Image.asset(sched.getSportPicturePath()),
                ListTile(
                  title: Text(sched.name),
                  subtitle: Text(formatDate(sched.start)),
                ),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(context, ScheduleOverview.routeName,
                  arguments: ScreenArguments(sched));
            },
          )),
        ));
      });
    } else {
      allCards = [Text("Es gibt noch keinen Plan")];
    }
    return allCards;
  }
}
