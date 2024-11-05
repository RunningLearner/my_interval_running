
import 'package:flutter/material.dart';
import 'package:my_interval_running/models/timer_state.dart';

class TimerDisplay extends StatelessWidget {
  final TimerState timerState;

  const TimerDisplay({super.key, required this.timerState});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: timerState.timeStream,
      builder: (context, snapshot) {
        final seconds = snapshot.data ?? 0;
        final minutes = seconds ~/ 60;
        final remainingSeconds = seconds % 60;
        return Text(
          '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
        );
      },
    );
  }
}