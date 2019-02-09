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

class ExerciseInfo {
  int count;
  ExerciseInfo({this.count});
}

class TimerModel extends Model {
  static final defaultNowProvider = () => DateTime.now().millisecondsSinceEpoch;
  final nowProvider;

  TimerModel({ nowProvider }) : this.nowProvider = nowProvider ?? defaultNowProvider {}

  // internal data
  Timer _timer;
  int _startedAt = 0; // epoch when timer was started
  int _time = 0; // epoch of the timer
  List<int> _times = <int>[]; // array of epoch split times

  Map<String, ExerciseInfo> _exercises = {
    'bench': ExerciseInfo(count: 0),
    'squats': ExerciseInfo(count: 0),
    'pullups': ExerciseInfo(count: 0),
  };

  // getters
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

  bool get isStarted => _startedAt != 0;

  List<Map> get exercises => _exercises.keys.map((text) => {'text': text, 'count': _exercises[text].count}).toList();

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
    if (_timer != null)
      _timer.cancel();
    _timer = null;
  }

  void reset() {
    stop();
    _startedAt = 0;
    _time = 0;
    _times = [];
    _exercises.values.forEach((exercise) { exercise.count = 0; });
    notifyListeners();
  }

  void incExercise(String name) {
    _exercises[name].count++;
    notifyListeners();
  }

  bool addExercise(String name) {
    if (_exercises.containsKey(name)) {
      return false;
    } else {
      _exercises.putIfAbsent(name, () => ExerciseInfo(count: 0));
      return true;
    }
  }

  bool removeExercise(String name) {
    _exercises.remove(name);
    notifyListeners();
  }
}
