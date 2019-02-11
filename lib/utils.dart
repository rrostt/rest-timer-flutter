String formatTime(time) {
  int minutes = (time / (1000 * 60)).floor();
  int seconds = (time / 1000).floor() % 60;
  int tens = (time / 100).floor() % 10;
  String secondsString = "$seconds".padLeft(2, '0');
  String tensString = "$tens".padLeft(1, '0');
  return "$minutes:$secondsString.$tensString";
}
