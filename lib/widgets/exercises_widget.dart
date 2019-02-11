import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../timerModel.dart';

import './exercise_chip.dart';

class ExercisesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TimerModel>(builder: (context, child, model) {
      return ExerciseRow(
        exercises: model.exercises,
      );
    });
  }
}

class ExerciseRow extends StatelessWidget {
  final exercises;
  ExerciseRow({this.exercises});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: exercises
              .map<Widget>(
                  (e) => ExerciseChip(text: e['text'], count: e['count']))
              .toList(),
        ));
  }
}
