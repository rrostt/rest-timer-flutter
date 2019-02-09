import 'package:scoped_model/scoped_model.dart';
import 'dart:async';

List<List<int>> zip(List<int> a, List<int> b) {
  final List<List<int>> list = [];

  final ia = a.iterator;
  final ib = b.iterator;

  while (ia.moveNext() && ib.moveNext()) {
    list.add([ia.current, ib.current]);
  }

  return list;
}

class TimerModel extends Model {
  static final defaultNowProvider = () => DateTime.now().millisecondsSinceEpoch;
  final nowProvider;

  TimerModel({ nowProvider }) : this.nowProvider = nowProvider ?? defaultNowProvider {}

  Timer _timer;
  int _startedAt = 0; // epoch when timer was started
  int _time = 0; // epoch of the timer
  List<int> _times = <int>[]; // array of epoch split times

  int get time => _time - _startedAt;
  List<int> get times => _times.map((time) => time - _startedAt).toList();
  int get currentSplitTime =>
      _time - (_times.length > 0 ? _times.last : _startedAt);
  List<int> get splitTimes => _times.length == 0
      ? []
      : zip(_times, _times.sublist(1))
          .toList()
          .map((ts) => ts[1] - ts[0])
          .toList();

  void tick() {
    setTime(nowProvider());
  }

  void setTime(time) {
    _time = time;
    notifyListeners();
  }

  void split() {
    if (_timer == null) {
      start();
      return;
    }

    _times.add(_time);
    notifyListeners();
  }

  void start() {
    _startedAt = nowProvider();
    _times.add(_startedAt);
    _timer = new Timer.periodic(new Duration(milliseconds: 50), (Timer t) {
      tick();
    });
  }

  void stop() {
    _timer.cancel();
  }
}
