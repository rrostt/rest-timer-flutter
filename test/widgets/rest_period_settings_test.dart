import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../lib/widgets/rest_period_settings.dart';
import '../../lib/timerModel.dart';

Widget makeTestableWidget(model) {
  return MaterialApp(
    home: ScopedModel<TimerModel>(
      model: model,
      child: RestPeriodSettings()
    ),
  );
}

void main() {
  testWidgets('renders value', (WidgetTester tester) async {
    var model = TimerModel(nowProvider: () => 10000);

    model.setRestPeriod(20);
    await tester.pumpWidget(makeTestableWidget(model));

    expect(find.text('${model.restPeriod}s'), findsOneWidget);
  });

  testWidgets('sliding changes value', (WidgetTester tester) async {
    var model = TimerModel(nowProvider: () => 10000);

    model.setRestPeriod(10);
    await tester.pumpWidget(makeTestableWidget(model));

    var slider = find.byType(Slider);
    var topLeft = tester.getTopLeft(slider);
    var bottomRight = tester.getBottomRight(slider);
    await tester.dragFrom(topLeft + Offset(50,5), Offset(100,0));
    await tester.pumpAndSettle();

    expect(model.restPeriod, greaterThan(10));
  });

  testWidgets('pressing 60S button sets rest period to 60s', (WidgetTester tester) async {
    var model = TimerModel(nowProvider: () => 10000);

    model.setRestPeriod(10);
    await tester.pumpWidget(makeTestableWidget(model));

    var button = find.text('60S');
    var buttonPos = tester.getTopLeft(button);
    await tester.tapAt(buttonPos);
    await tester.pumpAndSettle();

    expect(model.restPeriod, 60);
  });

  testWidgets('pressing 90S button sets rest period to 90s', (WidgetTester tester) async {
    var model = TimerModel(nowProvider: () => 10000);

    model.setRestPeriod(10);
    await tester.pumpWidget(makeTestableWidget(model));

    var button = find.text('90S');
    var buttonPos = tester.getTopLeft(button);
    await tester.tapAt(buttonPos);
    await tester.pumpAndSettle();

    expect(model.restPeriod, 90);
  });

  testWidgets('pressing 2 mins button sets rest period to 120s', (WidgetTester tester) async {
    var model = TimerModel(nowProvider: () => 10000);

    model.setRestPeriod(10);
    await tester.pumpWidget(makeTestableWidget(model));

    var button = find.text('2 MINS');
    var buttonPos = tester.getTopLeft(button);
    await tester.tapAt(buttonPos);
    await tester.pumpAndSettle();

    expect(model.restPeriod, 120);
  });
}
