import 'dart:async';
import 'package:my_interval_running/models/timer_interval.dart';

class TimerState {
  final _isRunningController = StreamController<bool>.broadcast();
  final _timeController = StreamController<int>.broadcast();
  final _currentIntervalController = StreamController<int>.broadcast();

  List<TimerInterval> _intervals = [];
  int _currentIntervalIndex = 0;
  int _currentTime = 0;
  int _elapsedTime = 0;

  Stream<bool> get isRunningStream => _isRunningController.stream;
  Stream<int> get timeStream => _timeController.stream;
  Stream<int> get currentIntervalStream => _currentIntervalController.stream;
  List<TimerInterval> get intervals => _intervals;
  TimerInterval get currentInterval => _intervals[_currentIntervalIndex];

  void setIntervals(List<TimerInterval> intervals) {
    _intervals = intervals;
    reset();
  }

  void decrementTime() {
    _currentTime--;
    _timeController.sink.add(_currentTime);
  }

  void incrementElapsedTime() {
    _elapsedTime++;
  }

  bool shouldNotifyInterval() {
    int currentIntervalEnd = _intervals
        .take(_currentIntervalIndex + 1)
        .fold(0, (sum, interval) => sum + interval.seconds);
    return _elapsedTime == currentIntervalEnd;
  }

  bool moveToNextInterval() {
    _currentIntervalIndex++;
    _currentIntervalController.sink.add(_currentIntervalIndex);
    return _currentIntervalIndex < _intervals.length;
  }

  bool isComplete() => _currentTime <= 0;

  void setIsRunning(bool isRunning) {
    _isRunningController.sink.add(isRunning);
  }

  void reset() {
    _currentIntervalIndex = 0;
    _elapsedTime = 0;
    _currentTime = _calculateTotalTime();
    _timeController.sink.add(_currentTime);
    _currentIntervalController.sink.add(_currentIntervalIndex);
  }

  int _calculateTotalTime() {
    return _intervals.fold(0, (sum, interval) => sum + interval.seconds);
  }

  void dispose() {
    _isRunningController.close();
    _timeController.close();
    _currentIntervalController.close();
  }
}
