import 'dart:async';

import 'package:my_interval_running/models/timer_state.dart';
import 'package:my_interval_running/services/notification_service.dart';

class TimerManager {
  final NotificationService _notificationService;
  final TimerState _timerState;
  Timer? _timer;

  TimerManager({
    required NotificationService notificationService,
    required TimerState timerState,
  })  : _notificationService = notificationService,
        _timerState = timerState;

  TimerState get timerState => _timerState;

  void startTimer() {
    if (_timer != null || _timerState.intervals.isEmpty) return;

    _timerState.setIsRunning(true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _timerState.decrementTime();
      _timerState.incrementElapsedTime();

      if (_timerState.shouldNotifyInterval()) {
        _notificationService.notify(_timerState.currentInterval);

        if (!_timerState.moveToNextInterval()) {
          stopTimer();
          return;
        }
      }

      if (_timerState.isComplete()) {
        stopTimer();
        return;
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    _timerState.setIsRunning(false);
  }

  void resetTimer() {
    stopTimer();
    _timerState.reset();
  }

  void dispose() {
    stopTimer();
    _timerState.dispose();
    _notificationService.dispose();
  }
}
