import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../timerModel.dart';

import './add_exercise.dart';

class ExerciseSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TimerModel>(
      builder: (context, child, model) {
        List<Widget> exercises = model.exercises
            .map<Widget>((exercise) => ExerciseListEntry(exercise: exercise, model: model))
            .toList();
        List<Widget> children = List.from(exercises);
        children.add(AddExercise());
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16),
                child: Text('Exercises', style: TextStyle(fontSize: 16)),
              ),
              Card(
                child: Column(children: children),
              ),
            ]);
      },
    );
  }
}

class ExerciseListEntry extends StatelessWidget {
  final exercise;
  final model;

  ExerciseListEntry({@required this.exercise, @required this.model});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(exercise['text']),
      child: ListTile(
          title: Text(exercise['text']),
          leading: Icon(Icons.subject),
        ),
      background: Container(decoration: BoxDecoration(color: Colors.red[900])),
      onDismissed: (direction) {
        model.removeExercise(exercise['text']);
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed ${exercise['text']}'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                model.addExercise(exercise['text']);
              },
            ),
          )
        );
      },
    );
  }
}