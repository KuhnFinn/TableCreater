import 'package:numberpicker/numberpicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:flutter_app/data/Text.dart';
import 'package:flutter_app/Schedule/Schedule.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/Util.dart';

class CreateSchedule extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CreateScheduleState();
}

class CreateScheduleState extends State<CreateSchedule> {
  var startDateTextController = new TextEditingController();
  var durationTextController = new TextEditingController();
  var halftimeDurationTextController = new TextEditingController();
  Schedule actSchedule;
  int _selectedTab = 0;
  Widget actTournamentForm;
  Widget actGameSettingsForm;

  List<Color> _tabsColor;
  List<bool> _tabsVal;
  List<Widget> _teams;

  static final _formKey = new GlobalKey<FormState>();

  static final Key _k1 = UniqueKey();

  String title;

  @override
  void initState() {
    super.initState();

    _tabsColor = [
      Colors.grey[700],
      Colors.grey[700],
      Colors.grey[700],
      Colors.grey[700]
    ];

    _tabsVal = [false, false, false, false];

    actSchedule = new Schedule();

    _teams = rebuildTeams();

    actTournamentForm = buildChampForm();
    actGameSettingsForm = buildTimeForm();
  }

  @override
  Widget build(BuildContext context) {
    var _tabs = [
      Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 4.0,
            ),
            Padding(
              //Titel InputFiel
              padding: const EdgeInsets.all(4.0),
              child: TextFormField(
                key: _k1,
                onChanged: (value) {
                  actSchedule.name = value;
                },
                initialValue: actSchedule.name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: str_titel,
                ),
                validator: (value) {
                  return valCheckEmpty(value, str_err_titel);
                },
              ),
            ),
            Padding(
              //Sport InputField
              padding: const EdgeInsets.all(4.0),
              child: DropdownButtonFormField(
                key: UniqueKey(),
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: str_sportsTypes),
                value: actSchedule.sport,
                items: str_lists_sports
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    actSchedule.sport = newValue;
                  });
                },
                hint: Text(str_sportsTypes),
                validator: (pvalue) {
                  return valCheckEmpty(pvalue, str_err_sportsType);
                },
              ),
            ),
            Padding(
                //StartDate InputField
                padding: const EdgeInsets.all(4.0),
                child: TextFormField(
                  key: UniqueKey(),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: str_startDate),
                  readOnly: true,
                  controller: startDateTextController,
                  onTap: () async {
                    DateTime start = await selectDate(context);
                    if (start == null) {
                      return;
                    }
                    TimeOfDay startTime = await selectTime(context);
                    if (startTime == null) {
                      return;
                    }
                    actSchedule.start = DateTime(start.year, start.month,
                        start.day, startTime.hour, startTime.minute);
                    setState(() {
                      startDateTextController.text =
                          formatDate(actSchedule.start);
                    });
                  },
                  validator: (value) {
                    return valCheckEmpty(value, str_err_startDate);
                  },
                )),
          ],
        ),
      ),
      Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 4.0,
            ),
            Expanded(
              child: ListView(
                children: _teams,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
              ),
            ),

          ],
        ),
      ),
      Container(
        child: ListView(
          children: <Widget>[
            Container(
              height: 4.0,
            ),
            Padding(
              //TournamentType InputField
              padding: const EdgeInsets.all(4.0),
              child: DropdownButtonFormField(
                key: UniqueKey(),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: str_tournamentType),
                value: actSchedule.tournamentType,
                items: str_list_tournamentType
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  switch (str_list_tournamentType.indexOf(newValue)) {
                    case 0:
                      setState(() {
                        actSchedule.tournamentType = str_list_tournamentType[0];
                        actTournamentForm = buildChampForm();
                      });
                      break;
                    case 1:
                      setState(() {
                        actSchedule.tournamentType = str_list_tournamentType[1];
                        actTournamentForm = buildKoForm();
                      });
                      break;
                  }
                },
              ),
            ),
            actTournamentForm,
          ],
        ),
      ),
      Container(
        child: ListView(
          children: <Widget>[
            Container(height: 4.0),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: CheckboxListTile(
                title: Text(str_refereeExtern),
                value: actSchedule.externRefery,
                key: UniqueKey(),
                onChanged: (bool pvalue) {
                  setState(() {
                    actSchedule.externRefery = pvalue;
                  });
                },
              ),
            ),
            Padding(
              //TournamentType InputField
              padding: const EdgeInsets.all(4.0),
              child: DropdownButtonFormField(
                key: UniqueKey(),
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: str_winCondition),
                value: actSchedule.winCondition,
                items: str_list_winCondition
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  var newForm;
                  switch (str_list_winCondition.indexOf(newValue)) {
                    case 0:
                      newForm = buildTimeForm();
                      break;
                    case 1:
                      newForm = buildSetForm();
                      break;
                  }
                  setState(() {
                    actSchedule.winCondition = newValue;
                    actGameSettingsForm = newForm;
                  });
                },
              ),
            ),
            actGameSettingsForm,
          ],
        ),
      ),
    ];

    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(str_titelCreateSchedule),
          ),
          body: Form(
            child: _tabs[_selectedTab],
            key: _formKey,
          ),
          resizeToAvoidBottomInset: false,
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.check),
            backgroundColor: Colors.green,
            onPressed: () {
              validateTab();
              if (_tabsVal.every((e) => e)) {
                allSchedules.add(actSchedule);
                Navigator.pop(context);
              } else {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: Text(str_alertNotFinishedTitle),
                          content: Text(str_alertNotFinishedMessage),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(str_ok),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ));
              }
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            backgroundColor: Colors.grey[200],
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.date_range,
                  color: _tabsColor[0],
                ),
                title: Text(str_list_tabs[0],
                    style: TextStyle(color: _tabsColor[0])),
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.group,
                    color: _tabsColor[1],
                  ),
                  title: Text(str_list_tabs[1],
                      style: TextStyle(color: _tabsColor[1]))),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.flag,
                    color: _tabsColor[2],
                  ),
                  title: Text(str_list_tabs[2],
                      style: TextStyle(color: _tabsColor[2]))),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.timer,
                    color: _tabsColor[3],
                  ),
                  title: Text(str_list_tabs[3],
                      style: TextStyle(color: _tabsColor[3]))),
            ],
            currentIndex: _selectedTab,
            onTap: (int index) {
              validateTab();
              setState(() {
                _selectedTab = index;
                _teams = rebuildTeams();
              });
            },
          ),
        ),
        onWillPop: () async {
          bool returnValue = false;
          await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text(str_alertCancelTitle),
                    content: Text(str_alertCancelMessage),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(str_leave),
                        onPressed: () {
                          Navigator.of(context).pop();
                          returnValue = true;
                        },
                      ),
                      FlatButton(
                        child: Text(
                          str_stay,
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.indigo,
                        onPressed: () {
                          Navigator.of(context).pop();
                          returnValue = false;
                        },
                      ),
                    ],
                  ));
          return Future(() => returnValue);
        });
  }

  ///Validates if the current Tab is filled correctly and colors the icon according to that
  void validateTab() {
    Color newColor = (_tabsVal[_selectedTab] = _formKey.currentState.validate())
        ? Colors.green
        : Colors.red;
    _tabsColor[_selectedTab] = newColor;
  }

  ///Remove Team with [index] for [actSchedule]
  removeTeam(int index) {
    actSchedule.teams.removeAt(index);

    setState(() {
      _teams = rebuildTeams();
    });
  }

  ///Add Team to [actSchedule]
  void addTeam() {
    actSchedule.teams.add("");

    setState(() {
      _teams = rebuildTeams();
    });
  }

  ///Build Column TextFieldForms for all teams
  List<Widget> rebuildTeams() {
    var teams = List<Widget>();
    for (int i = 1; i <= actSchedule.teams.length; i++) {
      teams.add(Padding(
        padding: const EdgeInsets.all(4.0),
        child: TextFormField(
          key: UniqueKey(),
          initialValue: actSchedule.teams[i - 1],
          onChanged: (value) {
            actSchedule.teams[i - 1] = value;
          },
          decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: Colors.red[800],
                ),
                onPressed: () {
                  removeTeam(i - 1);
                },
              ),
              border: OutlineInputBorder(),
              labelText: str_team + " " + i.toString()),
          validator: (value) {
            return valCheckEmpty(value, str_err_team);
          },
        ),
      ));
    }
    teams.add(IconButton(
      alignment: Alignment.centerLeft,
      icon: Icon(
        Icons.add_circle_outline,
        color: Colors.green[800],
      ),
      onPressed: () {
        addTeam();
      },
    ));
    return teams;
  }

  ///Builds a Form that contains all Fields for defining gameRules for a time Game
  Column buildTimeForm() {
    Column timeForm = Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextFormField(
            key: UniqueKey(),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: str_duration,
            ),
            readOnly: true,
            controller: durationTextController,
            onTap: () {
              showDialog<int>(
                  context: context,
                  builder: (BuildContext context) {
                    return new NumberPickerDialog.integer(
                      minValue: 1,
                      maxValue: 120,
                      title: new Text( str_durationInMinutes),
                      initialIntegerValue: actSchedule.gameDuration.inMinutes,
                    );
                  }).then((int value) {
                if (value != null) {
                  setState(() {
                    actSchedule.gameDuration = new Duration(minutes: value);
                    durationTextController.text =
                        formatDuration(actSchedule.gameDuration);
                  });
                }
              });
            },
            validator: (value) {
              return valCheckEmpty(value, str_err_duration);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: CheckboxListTile(
            title: Text(str_halftime),
            value: actSchedule.halftime,
            key: UniqueKey(),
            onChanged: (bool pvalue) {
              setState(() {
                actSchedule.halftime = pvalue;
                actGameSettingsForm = buildTimeForm();
              });
            },
          ),
        ),
        actSchedule.halftime?Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextFormField(
            key: UniqueKey(),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: str_halftimeDuration,
            ),
            readOnly: true,
            controller: halftimeDurationTextController,
            onTap: () {
              showDialog<int>(
                  context: context,
                  builder: (BuildContext context) {
                    return new NumberPickerDialog.integer(
                      minValue: 0,
                      maxValue: 30,
                      title: new Text( str_durationInMinutes),
                      initialIntegerValue: actSchedule.halftimeDuration.inMinutes,
                    );
                  }).then((int value) {
                if (value != null) {
                  setState(() {
                    actSchedule.halftimeDuration = new Duration(minutes: value);
                    halftimeDurationTextController.text =
                        formatDuration(actSchedule.halftimeDuration);
                  });
                }
              });
            },
              validator: (value) {
                return valCheckEmpty(value, str_err_halftimeDuration);
              },
          ),
        ):Container(),
      ],
    );
    return timeForm;
  }

  ///Builds a Form that contains all Fields for defining gameRules for a time Game
  Column buildSetForm() {
    Column SetForm = Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: DropdownButtonFormField(
            key: UniqueKey(),
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: str_setType),
            value: actSchedule.setType,
            items:
                str_list_setType.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                actSchedule.setType = newValue;
                actGameSettingsForm = buildSetForm();
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextFormField(
            key: UniqueKey(),
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp("[0-9]|^\$")),
            ],
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: str_setQuantity,
            ),
            keyboardType: TextInputType.number,
            initialValue: (actSchedule.setQuantity == null)
                ? ""
                : actSchedule.setQuantity.toString(),
            onChanged: (value) {
              if (value.isEmpty) {
                actSchedule.setQuantity = null;
              } else {
                actSchedule.setQuantity = int.parse(value);
              }
            },
            onEditingComplete: () {
              setState(() {
                actGameSettingsForm = buildSetForm();
              });
            },
            validator: (value) {
              return valCheckEmpty(value, str_err_setQuantity);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextFormField(
            key: UniqueKey(),
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp("[0-9]|^\$")),
            ],
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: str_pointsToWin,
            ),
            keyboardType: TextInputType.number,
            initialValue: (actSchedule.pointsToWin == null)
                ? ""
                : actSchedule.pointsToWin.toString(),
            onChanged: (value) {
              if (value.isEmpty) {
                actSchedule.pointsToWin = null;
              } else {
                actSchedule.pointsToWin = int.parse(value);
              }
            },
            onEditingComplete: () {
              setState(() {
                actGameSettingsForm = buildSetForm();
              });
            },
            validator: (value) {
              return valCheckEmpty(value, str_err_pointsToWin);
            },
          ),
        ),
      ],
    );
    return SetForm;
  }

  ///Builds a Form that contains all Fields for a defining a KO-tournament
  Column buildKoForm() {
    Column koForm = Column(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: CheckboxListTile(
                  title: Text(str_groupsEnables),
                  value: actSchedule.groupsEnable,
                  key: UniqueKey(),
                  onChanged: (bool pvalue) {
                    actSchedule.groupsEnable = pvalue;
                    setState(() {
                      actTournamentForm = buildKoForm();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        actSchedule.groupsEnable
            ? Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextFormField(
                      key: UniqueKey(),
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp("[0-9]|^\$")),
                      ],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: str_groupQuantity,
                      ),
                      keyboardType: TextInputType.number,
                      initialValue:
                          (actSchedule.groupQuantity == null)
                              ? ""
                              : actSchedule.groupQuantity
                                  .toString(),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          actSchedule.groupQuantity = null;
                        } else {
                          actSchedule.groupQuantity =
                              int.parse(value);
                        }
                      },
                      onEditingComplete: () {
                        setState(() {
                          actTournamentForm = buildKoForm();
                        });
                      },
                      validator: (value) {
                        String errMsg;
                        errMsg =
                            valCheckEmpty(value, str_err_groupQuantity_empty);
                        if (errMsg == null) {
                          errMsg = valCheckLess(
                              value,
                              str_err_groupQuantity_toMuch,
                              (actSchedule.teams.length / 2).round());
                        }
                        return errMsg;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextFormField(
                      key: UniqueKey(),
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp("[0-9]|^\$")),
                      ],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: str_koPhasesQuantity,
                      ),
                      keyboardType: TextInputType.number,
                      initialValue:
                          (actSchedule.koRoundQuantity == null)
                              ? ""
                              : actSchedule.koRoundQuantity
                                  .toString(),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          actSchedule.koRoundQuantity = null;
                        } else {
                          actSchedule.koRoundQuantity =
                              int.parse(value);
                        }
                      },
                      onEditingComplete: () {
                        setState(() {
                          actTournamentForm = buildKoForm();
                        });
                      },
                      validator: (value) {
                        String errMsg;
                        errMsg = valCheckEmpty(
                            value, str_err_koPhasesQuantity_empty);
                        if (errMsg == null) {
                          errMsg = valCheckLess(
                              value,
                              str_err_koPhasesQuantity_toMuch,
                              (actSchedule.teams.length / 2).round());
                        }
                        return errMsg;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextFormField(
                      key: UniqueKey(),
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp("[0-9]|^\$")),
                      ],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: str_untilPlace,
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: (actSchedule.untilPlace ==
                              null)
                          ? ""
                          : actSchedule.untilPlace.toString(),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          actSchedule.untilPlace = null;
                        } else {
                          actSchedule.untilPlace =
                              int.parse(value);
                        }
                      },
                      onEditingComplete: () {
                        setState(() {
                          actTournamentForm = buildKoForm();
                        });
                      },
                      validator: (value) {
                        String errMsg;
                        errMsg = valCheckEmpty(value, str_err_untilPlace_empty);
                        if (errMsg == null) {
                          errMsg = valCheckLess(
                              value,
                              str_err_untilPlace_toMuch,
                              (actSchedule.teams.length));
                        }
                        return errMsg;
                      },
                    ),
                  ),
                ],
              )
            : Container(),
      ],
    );
    return koForm;
  }

  ///Builds a Form that contains all Fields for a defining a Championship
  Column buildChampForm() {
    Column champForm = Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: CheckboxListTile(
            title: Text(str_doubleRoundEnabled),
            value: actSchedule.doubleRound,
            key: UniqueKey(),
            onChanged: (bool pvalue) {
              actSchedule.doubleRound = pvalue;
              setState(() {
                actTournamentForm = buildChampForm();
              });
            },
          ),
        ),
      ],
    );
    return champForm;
  }
}

///Validates if [value] is Empty.
///
/// [errMsg] is returned, if [value] is null. Otherwise null is returned
String valCheckEmpty(value, String errMsg) {
  if (value.isEmpty) {
    return errMsg;
  }
  return null;
}

///Validates if [value] is less than [maxValue]
///
/// If [value] is less, [errMsg] will be returned. Otherwise null will be returned
String valCheckLess(value, String errMsg, int maxValue) {
  if (int.parse(value) > maxValue) {
    return errMsg;
  }
  return null;
}

Future<bool> cancelDialog(context) {
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
            title: Text(str_alertCancelTitle),
            content: Text(str_alertCancelMessage),
            actions: <Widget>[
              FlatButton(
                child: Text(str_yes),
                onPressed: () {
                  Navigator.of(context).pop();
                  return true;
                },
              ),
              FlatButton(
                child: Text(str_no),
                onPressed: () {
                  Navigator.of(context).pop();
                  return false;
                },
              ),
            ],
          ));
}
