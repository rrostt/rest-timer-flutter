import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './timerModel.dart';

import 'widgets/timer_widget.dart';
import 'widgets/split_times.dart';
import 'widgets/total_time_widget.dart';
import 'widgets/exercises_widget.dart';
import 'widgets/exercise_settings.dart';
import 'widgets/hint_text.dart';
import 'widgets/rest_period_settings.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rest Timer',
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyHomeState();
  }
}

class MyHomeState extends State<MyHome> {
  final TimerModel model = TimerModel();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    model.loadPrefs();
  }

  @override
  void deactivate() {
    super.deactivate();
    model.savePrefs();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ScopedModel<TimerModel>(
        model: model,
        child: MyContent(),
      ),
      ScopedModel<TimerModel>(
        model: model,
        child: Settings(),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Rest Timer'),
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: new Icon(Icons.home), title: Text('Timer')),
          BottomNavigationBarItem(
              icon: new Icon(Icons.settings), title: Text('Settings'))
        ],
      ),
    );
  }
}

//
// Horisontal row of exercises
// Hint text that is hidden when timer is started
// Timer clock showing current split in large letters
// Total time in desaturated text
// List of split times
//
class MyContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ExercisesWidget(),
                  HintText(),
                  TimerWidget(),
                  TotalTimeWidget(),
                  SplitTimes(),
                ],
              ))),
      onRefresh: () async {
        ScopedModel.of<TimerModel>(context).reset();
      },
    );
  }
}

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          RestPeriodSettings(),
          ExerciseSettings(),
        ],
      ),
    );
  }
}
