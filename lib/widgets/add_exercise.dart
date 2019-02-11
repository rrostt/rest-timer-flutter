import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../timerModel.dart';

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
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: controller,
              ),
            ),
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  if (controller.text != '') {
                    if (!ScopedModel.of<TimerModel>(context)
                        .addExercise(controller.text)) {
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
          ],
        ),
        error != null
            ? Text(error, style: TextStyle(color: Colors.red[700]))
            : Container()
      ]),
    );
  }
}
