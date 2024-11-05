
import 'package:flutter/material.dart';
import 'package:my_interval_running/models/timer_state.dart';

class TimerControls extends StatelessWidget {
  final TimerState timerState;

  const TimerControls({super.key, required this.timerState});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: timerState.isRunningStream,
      builder: (context, snapshot) {
        final isRunning = snapshot.data ?? false;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => timerState.setTime(60),
              child: const Text('1분'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => timerState.setTime(300),
              child: const Text('5분'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: isRunning ? timerState.stopTimer : timerState.startTimer,
              child: Text(isRunning ? '정지' : '시작'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: timerState.resetTimer,
              child: const Text('리셋'),
            ),
          ],
        );
      },
    );
  }
}