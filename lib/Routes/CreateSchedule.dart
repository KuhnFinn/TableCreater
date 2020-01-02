import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/Text.dart';
import 'package:flutter_app/Schedule.dart';

class CreateSchedule extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _initState();
}

class _initState extends State<CreateSchedule> {
  static String _seleectedSport;
  var test;
  var startDateTextController = new TextEditingController();
  var endDateTextController = new TextEditingController();
  var _tabs;
  Schedule actSchedule = new Schedule.empty();
  int _selectedTab =0;

  @override
  void initState() {
    super.initState();
    _tabs = [
      Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: str_titel,
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
                items: str_lists_sports
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
                hint: Text(str_sportsTypes),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: str_startDate),
                  readOnly: true,
                  controller: startDateTextController,
                  onTap: () async {
                    DateTime start = await selectDate(context);
                    TimeOfDay startTime = await selectTime(context);
                    setState(() {
                      startDateTextController.text = formatDate(DateTime(
                          start.year,
                          start.month,
                          start.day,
                          startTime.hour,
                          startTime.minute));
                    });
                  },
                )),
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: str_endDate),
                  readOnly: true,
                  controller: endDateTextController,
                  onTap: () async {
                    DateTime end = await selectDate(context);
                    TimeOfDay endTime = await selectTime(context);
                    setState(() {
                      endDateTextController.text = formatDate(DateTime(end.year,
                          end.month, end.day, endTime.hour, endTime.minute));
                    });
                  },
                )),
          ],
        ),
      ),
      Container(),
      Container(),
      Container(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(str_titelCreateSchedule),
      ),
      body: _tabs[_selectedTab],
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.close),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.date_range), title: Text(str_list_tabs[0])),
          BottomNavigationBarItem(
              icon: Icon(Icons.group), title: Text(str_list_tabs[1])),
          BottomNavigationBarItem(
              icon: Icon(Icons.flag), title: Text(str_list_tabs[2])),
          BottomNavigationBarItem(
              icon: Icon(Icons.timer), title: Text(str_list_tabs[3])),
        ],
        currentIndex: _selectedTab,
        onTap: (int index){
          setState(() {
            _selectedTab = index;
          });
        },
      ),
    );
  }
}

Future<DateTime> selectDate(var context) {
  return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
      locale: Localizations.localeOf(context));
}

Future<TimeOfDay> selectTime(var context) {
  return showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
}
