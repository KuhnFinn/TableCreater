import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/Text.dart';

class CreateSchedule extends StatelessWidget {
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
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: DropdownButton<String>(
            icon: Icon(Icons.arrow_drop_down),
            value: 'Drei',
            items: <String>['One', 'Two', 'Free', 'Four']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ]),
    );
  }
}
