import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../timerModel.dart';
import '../utils.dart';

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
