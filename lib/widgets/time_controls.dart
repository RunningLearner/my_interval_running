import 'package:flutter/material.dart';
import 'package:my_interval_running/services/time_manager.dart';

class TimerControls extends StatelessWidget {
  final TimerManager timerManager;

  const TimerControls({super.key, required this.timerManager});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: timerManager.timerState.isRunningStream,
      builder: (context, snapshot) {
        final isRunning = snapshot.data ?? false;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: isRunning ? timerManager.stopTimer : timerManager.startTimer,
              child: Text(isRunning ? '정지' : '시작'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: timerManager.resetTimer,
              child: const Text('리셋'),
            ),
          ],
        );
      },
    );
  }
}