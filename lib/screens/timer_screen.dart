import 'package:flutter/material.dart';
import 'package:my_interval_running/models/timer_interval.dart';
import 'package:my_interval_running/models/timer_state.dart';
import 'package:my_interval_running/services/notification_service.dart';
import 'package:my_interval_running/services/time_manager.dart';
import 'package:my_interval_running/widgets/time_controls.dart';
import 'package:my_interval_running/widgets/timer_display.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  TimerScreenState createState() => TimerScreenState();
}

class TimerScreenState extends State<TimerScreen> {
  late final TimerState _timerState;
  late final NotificationService _notificationService;
  late final TimerManager _timerManager;
  final List<TextEditingController> _messageControllers = [];
  final List<TextEditingController> _timeControllers = [];
  final List<TextEditingController> _nameControllers = [];

  @override
  void initState() {
    super.initState();
    _timerState = TimerState();
    _notificationService = NotificationService();
    _timerManager = TimerManager(
      timerState: _timerState,
      notificationService: _notificationService,
    );
  }

  @override
  void dispose() {
    _timerManager.dispose();
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
      _nameControllers.add(TextEditingController());
      _messageControllers.add(TextEditingController());
      _timeControllers.add(TextEditingController());
    });
  }

  void _saveIntervals() {
    final intervals = <TimerInterval>[];

    for (var i = 0; i < _messageControllers.length; i++) {
      final seconds = int.tryParse(_timeControllers[i].text) ?? 0;
      final message = _messageControllers[i].text;
      final name = _nameControllers[i].text;
      if (seconds > 0) {
        intervals.add(TimerInterval(seconds, message, name));
      }
    }

    _timerState.setIntervals(intervals);
  }

  void _removeInterval(int index) {
    setState(() {
      _messageControllers[index].dispose();
      _timeControllers[index].dispose();
      _nameControllers[index].dispose();
      _messageControllers.removeAt(index);
      _timeControllers.removeAt(index);
      _nameControllers.removeAt(index);
    });
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
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _nameControllers[index],
                          decoration: const InputDecoration(
                            labelText: '구간 이름',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
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
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeInterval(index),
                          ),
                        ),
                      ],
                    ),
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
                ElevatedButton.icon(
                  onPressed: _addInterval,
                  icon: const Icon(Icons.add),
                  label: const Text('구간 추가'),
                ),
                ElevatedButton.icon(
                  onPressed: _saveIntervals,
                  icon: const Icon(Icons.save),
                  label: const Text('저장'),
                ),
              ],
            ),
          ),
          TimerDisplay(timerState: _timerState),
          const SizedBox(height: 20),
          TimerControls(timerManager: _timerManager),
        ],
      ),
    );
  }
}
