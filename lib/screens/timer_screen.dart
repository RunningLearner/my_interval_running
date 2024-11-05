
import 'package:flutter/material.dart';
import 'package:my_interval_running/models/timer_state.dart';
import 'package:my_interval_running/widgets/time_controls.dart';
import 'package:my_interval_running/widgets/timer_display.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  TimerScreenState createState() => TimerScreenState();
}

class TimerScreenState extends State<TimerScreen> {
  final TimerState timerState = TimerState();

  @override
  void dispose() {
    timerState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('타이머'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TimerDisplay(timerState: timerState),
            const SizedBox(height: 20),
            TimerControls(timerState: timerState),
          ],
        ),
      ),
    );
  }
}
