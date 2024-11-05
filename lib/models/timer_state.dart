import 'dart:async';

class TimerState {
  int _seconds = 0;
  bool _isRunning = false;
  Timer? _timer;

  final _timeController = StreamController<int>.broadcast();
  final _isRunningController = StreamController<bool>.broadcast();

  Stream<int> get timeStream => _timeController.stream;
  Stream<bool> get isRunningStream => _isRunningController.stream;

  void setTime(int seconds) {
    _seconds = seconds;
    _timeController.add(_seconds);
  }

  void startTimer() {
    if (!_isRunning) {
      _isRunning = true;
      _isRunningController.add(_isRunning);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_seconds > 0) {
          _seconds--;
          _timeController.add(_seconds);
        } else {
          stopTimer();
        }
      });
    }
  }

  void stopTimer() {
    _timer?.cancel();
    _isRunning = false;
    _isRunningController.add(_isRunning);
  }

  void resetTimer() {
    stopTimer();
    _seconds = 0;
    _timeController.add(_seconds);
  }

  void dispose() {
    _timer?.cancel();
    _timeController.close();
    _isRunningController.close();
  }
}