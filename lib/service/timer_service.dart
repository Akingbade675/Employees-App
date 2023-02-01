import 'dart:async';

class TimerService {
  static final TimerService _instance = TimerService._internal();
  factory TimerService() => _instance;
  TimerService._internal();

  Timer? _timer;
  int _elapsedTime = 0;

  final StreamController<int> _timerController =
      StreamController<int>.broadcast();

  int get time => _elapsedTime;

  void updateTime(int time) {
    _elapsedTime = time;
    _timerController.add(_elapsedTime);
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedTime++;
      _timerController.add(_elapsedTime);
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void resetTimer() {
    stopTimer();
    _elapsedTime = 0;
    _timerController.add(_elapsedTime);
  }
}
