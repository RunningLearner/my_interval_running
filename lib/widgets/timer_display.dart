import 'package:flutter/material.dart';
import 'package:my_interval_running/models/timer_state.dart';

class TimerDisplay extends StatelessWidget {
  final TimerState timerState;

  const TimerDisplay({super.key, required this.timerState});

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<int>(
          stream: timerState.timeStream,
          builder: (context, snapshot) {
            final time = snapshot.data ?? 0;
            return Text(
              _formatTime(time),
              style: const TextStyle(fontSize: 60),
            );
          },
        ),
        StreamBuilder<int>(
          stream: timerState.currentIntervalStream,
          builder: (context, snapshot) {
            final currentInterval = snapshot.data ?? 0;
            return Text(
              '구간 ${currentInterval + 1}',
              style: const TextStyle(fontSize: 24),
            );
          },
        ),
      ],
    );
  }
}