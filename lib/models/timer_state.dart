import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TimerInterval {
  final int seconds;
  final String message;
  
  TimerInterval(this.seconds, this.message);
}

class TimerState {
  final _isRunningController = StreamController<bool>.broadcast();
  final _timeController = StreamController<int>.broadcast();
  final _currentIntervalController = StreamController<int>.broadcast();
  final FlutterLocalNotificationsPlugin flutterLocalNotifications = FlutterLocalNotificationsPlugin();
  final FlutterTts flutterTts = FlutterTts();

  Timer? _timer;
  List<TimerInterval> _intervals = [];
  int _currentIntervalIndex = 0;
  int _currentTime = 0;
  int _elapsedTime = 0;

  Stream<bool> get isRunningStream => _isRunningController.stream;
  Stream<int> get timeStream => _timeController.stream;
  Stream<int> get currentIntervalStream => _currentIntervalController.stream;

  TimerState() {
    _initNotifications();
    _initTts();
  }

  Future<void> _initNotifications() async {
    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotifications.initialize(initializationSettings);
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("ko-KR");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  void setIntervals(List<TimerInterval> intervals) {
    _intervals = intervals;
    _currentIntervalIndex = 0;
    _elapsedTime = 0;
    if (intervals.isNotEmpty) {
      _currentTime = _calculateTotalTime();
      _timeController.sink.add(_currentTime);
      _currentIntervalController.sink.add(_currentIntervalIndex);
    }
  }

  int _calculateTotalTime() {
    return _intervals.fold(0, (sum, interval) => sum + interval.seconds);
  }

  void startTimer() {
    if (_timer != null || _intervals.isEmpty) return;

    _isRunningController.sink.add(true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _currentTime--;
      _elapsedTime++;

      // 현재 구간의 종료 시간 계산
      int currentIntervalEnd = 0;
      for (int i = 0; i <= _currentIntervalIndex; i++) {
        currentIntervalEnd += _intervals[i].seconds;
      }

      // 구간 종료 시점에서 알림
      if (_elapsedTime == currentIntervalEnd) {
        _showNotification();
        _speakNotification();

        _currentIntervalIndex++;
        if (_currentIntervalIndex >= _intervals.length) {
          stopTimer();
          return;
        }
      }

      // 전체 타이머 종료 체크
      if (_currentTime <= 0) {
        stopTimer();
        return;
      }

      _timeController.sink.add(_currentTime);
      _currentIntervalController.sink.add(_currentIntervalIndex);
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    _isRunningController.sink.add(false);
  }

  void resetTimer() {
    stopTimer();
    _currentIntervalIndex = 0;
    _elapsedTime = 0;
    if (_intervals.isNotEmpty) {
      _currentTime = _calculateTotalTime();
      _currentIntervalController.sink.add(_currentIntervalIndex);
    } else {
      _currentTime = 0;
    }
    _timeController.sink.add(_currentTime);
  }

  Future<void> _showNotification() async {
    var androidDetails = const AndroidNotificationDetails(
      'timer_channel_id',
      'Timer Notifications',
      channelDescription: 'Notifications for timer completion',
      importance: Importance.max,
      priority: Priority.high,
    );

    var details = NotificationDetails(android: androidDetails);

    await flutterLocalNotifications.show(
      0,
      '타이머 알림',
      _intervals[_currentIntervalIndex].message,
      details,
    );
  }

  Future<void> _speakNotification() async {
    await flutterTts.speak(_intervals[_currentIntervalIndex].message);
  }

  void dispose() {
    stopTimer();
    _isRunningController.close();
    _timeController.close();
    _currentIntervalController.close();
    flutterTts.stop();
  }
}