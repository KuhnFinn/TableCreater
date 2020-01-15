import 'package:flutter/material.dart';
import 'package:flutter_app/Routes/CreateSchedule.dart';
import 'package:flutter_app/data/Text.dart';
import 'package:flutter_app/Schedule/Schedule.dart';

List<Schedule> allSchedules =  [];

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
    Schedule tab1 = new Schedule(
        "Spieltag 2",
        new DateTime(2019, 12, 9, 12, 10),
        str_lists_sports[4]);
    allSchedules.add(tab1);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children:
          createCardList(),
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

  List<Widget> createCardList(){
    List<Widget> allCards = [];
    if(allSchedules.isNotEmpty) {
      allSchedules.forEach((sched) => allCards.add(sched.generateCard()));
    }
    else{
      allCards =[
        Text("Es gibt noch keinen Plan")
      ];
    }
    return allCards;
  }
}
