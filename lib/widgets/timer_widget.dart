import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../timerModel.dart';
import '../utils.dart';

class TimerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TimerModel>(builder: (context, child, model) {
      return GestureDetector(
          onTap: () {
            model.split();
          },
          child: _buildTextRow(model.currentSplitTime,
              model.currentSplitTime >= model.restPeriod * 1000));
    });
  }

  Widget _buildTextRow(int time, bool restOver) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(formatTime(time),
              style: TextStyle(
                  fontSize: 72,
                  color: restOver ? Colors.red[700] : Colors.black,
                  fontFamily: 'monospace'))
        ]);
  }
}
