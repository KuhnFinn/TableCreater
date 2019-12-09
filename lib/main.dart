import 'package:flutter/material.dart';
import 'package:flutter_app/Routes/CreateSchedule.dart';
import 'package:flutter_app/data/Text.dart';
import 'package:flutter_app/Schedule.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: str_titel,
      theme: ThemeData(
        primarySwatch: Colors.green,

      ),
      home: MyHomePage(title: str_titel),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    Schedule tab1 =new Schedule("Spieltga 2", new DateTime(2019,12,9,12,10), new DateTime(2019,3,30),"Fußball");

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
        leading: Icon(Icons.menu),
      ),
      body: Column(

          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Card(

              child: Column(
                children: <Widget>[
                  Image.asset('assets/images/Fußball_klein.png'),
                  ListTile(

                    title:  Text("Spielplan 1"),
                    subtitle: Text("03.03.2019"),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: tab1.generateCard()
            ),
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: tab1.generateCard()
            ),

          ],
        ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateSchedule()),
        );
        },
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
