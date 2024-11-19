import 'package:my_interval_running/models/timer_interval.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tts/flutter_tts.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications;
  final FlutterTts _tts;

  NotificationService()
      : _notifications = FlutterLocalNotificationsPlugin(),
        _tts = FlutterTts() {
    _init();
  }

  Future<void> _init() async {
    await _initNotifications();
    await _initTts();
  }

  Future<void> _initNotifications() async {
    var androidSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var settings = InitializationSettings(android: androidSettings);
    await _notifications.initialize(settings);
  }

  Future<void> _initTts() async {
    await _tts.setLanguage("ko-KR");
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  Future<void> notify(TimerInterval interval) async {
    await _showNotification(interval.message);
    await _speakNotification(interval.message);
  }

  Future<void> _showNotification(String message) async {
    var androidDetails = const AndroidNotificationDetails(
      'timer_channel_id',
      'Timer Notifications',
      channelDescription: 'Notifications for timer completion',
      importance: Importance.max,
      priority: Priority.high,
    );

    var details = NotificationDetails(android: androidDetails);
    await _notifications.show(0, '타이머 알림', message, details);
  }

  Future<void> _speakNotification(String message) async {
    await _tts.speak(message);
  }

  void dispose() {
    _tts.stop();
  }
}
