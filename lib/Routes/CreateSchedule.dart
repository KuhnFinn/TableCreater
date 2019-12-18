import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/Text.dart';

class CreateSchedule extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _initState();
}

enum sports { Fussball, Faustball }

class _initState extends State<CreateSchedule> {
  List<String> _sports = ['Fussball', 'Faustball'];
  String _seleectedSport;
  var _sport;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(str_titelCreateSchedule),
      ),
      body: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Titel',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Sportart',
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(4.0),
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            value: _seleectedSport,
            items: _sports
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _seleectedSport = newValue;
              });
            },
            hint: Text("Sportart"),
          ),
        ),
      ]),
    );
  }
}

class CreateSchedule2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(str_titelCreateSchedule),
      ),
      body: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Titel',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Sportart',
            ),
          ),
        ),
        Padding(padding: const EdgeInsets.all(4.0)),
      ]),
    );
  }
}
