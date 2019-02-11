import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../timerModel.dart';

class ExerciseChip extends StatelessWidget {
  final String text;
  final int count;

  ExerciseChip({this.text, this.count});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          ScopedModel.of<TimerModel>(context).incExercise(text);
        },
        child: Chip(
            label: Text(text),
            avatar: CircleAvatar(
                backgroundColor: Colors.red[700],
                child: Text('$count',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)))),
      );
}
