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
  final List<TextEditingController> _messageControllers = [];
  final List<TextEditingController> _timeControllers = [];
  
  @override
  void dispose() {
    timerState.dispose();
    for (var controller in _messageControllers) {
      controller.dispose();
    }
    for (var controller in _timeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addInterval() {
    setState(() {
      _messageControllers.add(TextEditingController());
      _timeControllers.add(TextEditingController());
    });
  }

  void _saveIntervals() {
    final intervals = <TimerInterval>[];
    
    for (var i = 0; i < _messageControllers.length; i++) {
      final seconds = int.tryParse(_timeControllers[i].text) ?? 0;
      final message = _messageControllers[i].text;
      if (seconds > 0) {
        intervals.add(TimerInterval(seconds, message));
      }
    }
    
    timerState.setIntervals(intervals);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('인터벌 타이머')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messageControllers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: _timeControllers[index],
                          decoration: const InputDecoration(
                            labelText: '시간(초)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _messageControllers[index],
                          decoration: const InputDecoration(
                            labelText: '알림 메시지',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _addInterval,
                  child: const Text('구간 추가'),
                ),
                ElevatedButton(
                  onPressed: _saveIntervals,
                  child: const Text('저장'),
                ),
              ],
            ),
          ),
          TimerDisplay(timerState: timerState),
          const SizedBox(height: 20),
          TimerControls(timerState: timerState),
        ],
      ),
    );
  }
}