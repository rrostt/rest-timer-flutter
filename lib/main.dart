import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './timerModel.dart';

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
  Widget build(BuildContext context) {
    final tabs = [
      ScopedModel<TimerModel>(
        model: model,
        child: MyContent(),
      ),
      Center(child: Text('settings'),)
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
              icon: new Icon(Icons.home),
              title: Text('Timer')
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.settings),
              title: Text('Settings')
            )
          ],
        ),
      );
  }
}

//
//
// Timer clock showing current split in large letters
// Total time in desaturated text
// List of split times
//
class MyContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TimerWidget(),
                TotalTimeWidget(),
                SplitTimes(),
              ],
            )));
  }
}

class TotalTimeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TimerModel>(
      builder: (context, child, model) {
        return model.times.length > 1
            ? Text(formatTime(model.time),
                style: TextStyle(fontSize: 24, color: Color(0xff888888)))
            : Container();
      },
    );
  }
}

class SplitTimes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TimerModel>(builder: (context, child, model) {
      print(model.splitTimes);
      return Column(
        children: model.splitTimes.reversed
            .map((time) => SplitTimeWidget(time))
            .toList(),
      );
    });
  }
}

String formatTime(time) {
  int minutes = (time / (1000 * 60)).floor();
  int seconds = (time / 1000).floor() % 60;
  int hundreds = (time / 10).floor() % 100;
  String secondsString = "$seconds".padLeft(2, '0');
  String hundredsString = "$hundreds".padLeft(2, '0');
  return "$minutes:$secondsString.$hundredsString";
}

class SplitTimeWidget extends StatelessWidget {
  final int time;
  SplitTimeWidget(this.time);

  @override
  Widget build(BuildContext context) {
    return Text(formatTime(time));
  }
}

class TimerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TimerModel>(builder: (context, child, model) {
      return GestureDetector(
          onTap: () {
            model.split();
          },
          child: TimerText(model.currentSplitTime));
    });
  }
}

class TimerText extends StatelessWidget {
  final int time;
  TimerText(this.time);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(formatTime(time),
              style: TextStyle(
                  fontSize: 72, color: Colors.black, fontFamily: 'monospace'))
        ]);
  }
}
