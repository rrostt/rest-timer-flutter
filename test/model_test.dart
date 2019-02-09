import 'package:test/test.dart';
import '../lib/timerModel.dart';

void main() {
  test('time starts at 0', () {
    var time = 5;
    TimerModel model = TimerModel(nowProvider: () => time);
    model.start();
    model.tick();

    expect(model.time, 0);
    expect(model.currentSplitTime, 0);
  });

  test('no split times after first start', () {
    var time = 5;
    TimerModel model = TimerModel(nowProvider: () => time);
    model.split();
    model.tick();

    expect(model.splitTimes.length, 0);
  });

  test('one split times after two splits', () {
    var time = 5;
    TimerModel model = TimerModel(nowProvider: () => time);
    model.split();
    model.tick();
    time = 10;
    model.tick();
    model.split();

    expect(model.splitTimes.length, 1);
    expect(model.splitTimes[0], 5);
  });
}
