import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TimerState {
  final _isRunningController = StreamController<bool>.broadcast();
  final _timeController = StreamController<int>.broadcast();
  final FlutterLocalNotificationsPlugin flutterLocalNotifications = FlutterLocalNotificationsPlugin();
  final FlutterTts flutterTts = FlutterTts();
  
  Timer? _timer;
  int _currentTime = 0;
  String _notificationMessage = "타이머가 완료되었습니다!";
  
  Stream<bool> get isRunningStream => _isRunningController.stream;
  Stream<int> get timeStream => _timeController.stream;
  
  TimerState() {
    _initNotifications();
    _initTts();
  }

  Future<void> _initNotifications() async {
    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    
    await flutterLocalNotifications.initialize(initializationSettings);
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("ko-KR");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  void setNotificationMessage(String message) {
    _notificationMessage = message;
  }

  void setTime(int seconds) {
    _currentTime = seconds;
    _timeController.sink.add(_currentTime);
  }

  void startTimer() {
    if (_timer != null) return;
    
    _isRunningController.sink.add(true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentTime <= 0) {
        stopTimer();
        _showNotification();
        _speakNotification();
        return;
      }
      
      _currentTime--;
      _timeController.sink.add(_currentTime);
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    _isRunningController.sink.add(false);
  }

  void resetTimer() {
    stopTimer();
    _currentTime = 0;
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
    
    var details = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotifications.show(
      0,
      '타이머 알림',
      _notificationMessage,
      details,
    );
  }

  Future<void> _speakNotification() async {
    await flutterTts.speak(_notificationMessage);
  }

  void dispose() {
    stopTimer();
    _isRunningController.close();
    _timeController.close();
    flutterTts.stop();
  }
}