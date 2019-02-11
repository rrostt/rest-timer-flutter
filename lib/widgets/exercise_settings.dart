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
            .map<Widget>((exercise) => ListTile(
                  title: Text(exercise['text']),
                  leading: Icon(Icons.subject),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => model.removeExercise(exercise['text']),
                  ),
                ))
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
