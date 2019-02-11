import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../timerModel.dart';
import '../utils.dart';

class SplitTimes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TimerModel>(builder: (context, child, model) {
      print(model.splitTimes);
      return Column(
        children: model.splitTimes.reversed
            .map((time) => Text(formatTime(time)))
            .toList(),
      );
    });
  }
}
