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
  void initState() {
    super.initState();
    model.loadPrefs();
  }

  @override
  void dispose() {
    super.dispose();
    model.savePrefs();
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

class RestPeriodSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TimerModel>(builder: (context, child, model) {
      var onChanged = (value) { model.setRestPeriod(value.toInt()); };
      return _buildCard(model.restPeriod, onChanged);
    },);
  }

  Widget _buildCard(int restPeriod, onChanged) {
    return Card(child: Row(children: <Widget>[
      Padding(padding: EdgeInsets.all(16.0), child: Column(children: <Widget>[Icon(Icons.timer),Text('${restPeriod}s', style: TextStyle(fontSize: 10))]),),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Padding(padding: EdgeInsets.only(left: 16), child: Text('Rest period', style: TextStyle(fontSize: 16)),),
        Slider(value: restPeriod.toDouble(), onChanged: onChanged, min: 0, max: 180,),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          FlatButton(child: Text('60S'), textColor: Colors.blue[700], onPressed: () { onChanged(60); },),
          FlatButton(child: Text('90S'), textColor: Colors.blue[700], onPressed: () { onChanged(90); },),
          FlatButton(child: Text('2 MINS'), textColor: Colors.blue[700], onPressed: () { onChanged(120); },),
        ],)
      ],))
    ],),);
  }
}

class ExerciseSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TimerModel>(builder: (context, child, model) {
      List <Widget> exercises = model.exercises.map<Widget>((exercise) =>
            ListTile(
              title: Text(exercise['text']),
              leading: Icon(Icons.subject),
              trailing: IconButton(icon: Icon(Icons.delete),onPressed: () => model.removeExercise(exercise['text']),),
            )
          ).toList();
      List<Widget> children = List.from(exercises);
      children.add(AddExercise());
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Padding(padding: EdgeInsets.all(16), child: Text('Exercises', style: TextStyle(fontSize: 16)),),
        Card(child: Column(
          children: children
        ),),
      ]);
    },);
  }
}

class AddExercise extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddExerciseState();
  }
}

class AddExerciseState extends State<AddExercise> {
  final controller = TextEditingController();
  String error;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Column(children: <Widget>[
        Row(children: <Widget>[
          Expanded(child: TextField(controller: controller,),),
          IconButton(icon: Icon(Icons.add), onPressed: () {
            if (controller.text != '') {
              if (!ScopedModel.of<TimerModel>(context).addExercise(controller.text)) {
                setState(() {
                  error = '"${controller.text}" already exists';
                });
              } else {
                setState(() {
                  error = null;
                });
                controller.text = '';
              }
            }
            FocusScope.of(context).requestFocus(new FocusNode());
          }),
        ],),
        error != null ? Text(error, style: TextStyle(color: Colors.red[700])) : Container()
      ]),
    );
  }
}

class HintText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TimerModel>(builder: (context, child, model) {
      return Container(
        margin: EdgeInsets.all(32.0),
        child: Text(
          'Press time to start, pull down to reset',
          style: TextStyle(
            fontSize: 24,
            color: model.isStarted ? Color(0) : Color(0xff888888),
            fontFamily: 'monospace'
          ),)
      );
    },);
  }

}

class ExercisesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TimerModel>(builder: (context, child, model) {
      return ExerciseRow(exercises: model.exercises,);
    });
  }
}

class ExerciseRow extends StatelessWidget {
  final exercises;
  ExerciseRow({this.exercises});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: exercises.map<Widget>((e) => ExerciseChip(text: e['text'], count: e['count'])).toList(),
    ));

  }

}

typedef void ExerciseChipOnTap(String name);

class ExerciseChip extends StatelessWidget {
  final String text;
  final int count;

  ExerciseChip({this.text, this.count});

  @override
  Widget build(BuildContext context) =>
    GestureDetector(
      onTap: () {
        ScopedModel.of<TimerModel>(context).incExercise(text);
      },
      child:
        Chip(
          label: Text(text),
          avatar: CircleAvatar(
              backgroundColor: Colors.red[700],
              child: Text('$count', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold))
          )
        ),
    );
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
  int tens = (time / 100).floor() % 10;
  String secondsString = "$seconds".padLeft(2, '0');
  String tensString = "$tens".padLeft(1, '0');
  return "$minutes:$secondsString.$tensString";
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
          child: TimerText(model.currentSplitTime, model.currentSplitTime >= model.restPeriod * 1000));
    });
  }
}

class TimerText extends StatelessWidget {
  final int time;
  final bool restOver;
  TimerText(this.time, this.restOver);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(formatTime(time),
              style: TextStyle(
                  fontSize: 72, color: restOver ? Colors.red[700] : Colors.black, fontFamily: 'monospace'))
        ]);
  }
}
