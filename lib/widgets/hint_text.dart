import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../timerModel.dart';

class HintText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TimerModel>(
      builder: (context, child, model) {
        return Container(
            margin: EdgeInsets.all(32.0),
            child: Text(
              'Press time to start, pull down to reset',
              style: TextStyle(
                  fontSize: 24,
                  color: model.isStarted ? Color(0) : Color(0xff888888),
                  fontFamily: 'monospace'),
            ));
      },
    );
  }
}
