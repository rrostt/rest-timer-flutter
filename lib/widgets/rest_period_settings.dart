import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../timerModel.dart';

class RestPeriodSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TimerModel>(
      builder: (context, child, model) {
        var onChanged = (value) {
          model.setRestPeriod(value.toInt());
        };
        return _buildCard(model.restPeriod, onChanged);
      },
    );
  }

  Widget _buildCard(int restPeriod, onChanged) {
    return Card(
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(children: <Widget>[
              Icon(Icons.timer),
              Text('${restPeriod}s', style: TextStyle(fontSize: 10))
            ]),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text('Rest period', style: TextStyle(fontSize: 16)),
              ),
              Slider(
                value: restPeriod.toDouble(),
                onChanged: onChanged,
                min: 0,
                max: 180,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: Text('60S'),
                    textColor: Colors.blue[700],
                    onPressed: () {
                      onChanged(60);
                    },
                  ),
                  FlatButton(
                    child: Text('90S'),
                    textColor: Colors.blue[700],
                    onPressed: () {
                      onChanged(90);
                    },
                  ),
                  FlatButton(
                    child: Text('2 MINS'),
                    textColor: Colors.blue[700],
                    onPressed: () {
                      onChanged(120);
                    },
                  ),
                ],
              )
            ],
          ))
        ],
      ),
    );
  }
}
