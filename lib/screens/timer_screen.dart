import 'package:flutter/material.dart';
import 'package:my_interval_running/models/timer_state.dart';
import 'package:my_interval_running/widgets/time_controls.dart';
import 'package:my_interval_running/widgets/timer_display.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  TimerScreenState createState() => TimerScreenState();
}

class TimerScreenState extends State<TimerScreen> {
  final TimerState timerState = TimerState();
  final TextEditingController _messageController = TextEditingController();
  // 클래스 내부

  //테스트 코드
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("ko-KR");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
  }

  Future<void> _testTts() async {
    print("테스트가 실행되었습니다");
    String testMessage = _messageController.text.isEmpty
        ? "TTS 테스트입니다"
        : _messageController.text;
    await flutterTts.speak(testMessage);
  }
  //테스트 코드

  @override
  void dispose() {
    timerState.dispose();
    _messageController.dispose();
    flutterTts.stop(); //테스트 코드
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('타이머'),
  //     ),
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.all(16.0),
  //             child: TextField(
  //               controller: _messageController,
  //               decoration: const InputDecoration(
  //                 labelText: '알림 메시지',
  //                 hintText: '타이머 종료시 표시할 메시지를 입력하세요',
  //               ),
  //               onChanged: (value) => timerState.setNotificationMessage(value),
  //             ),
  //           ),
  //           TimerDisplay(timerState: timerState),
  //           const SizedBox(height: 20),
  //           TimerControls(timerState: timerState),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('타이머'),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: _testTts,
            tooltip: 'TTS 테스트',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: '알림 메시지',
                      hintText: '타이머 종료시 표시할 메시지를 입력하세요',
                    ),
                    onChanged: (value) =>
                        timerState.setNotificationMessage(value),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _testTts,
                    icon: const Icon(Icons.volume_up),
                    label: const Text('메시지 읽기 테스트'),
                  ),
                ],
              ),
            ),
            TimerDisplay(timerState: timerState),
            const SizedBox(height: 20),
            TimerControls(timerState: timerState),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => flutterTts.speak("3, 2, 1, 시작"),
                  child: const Text('카운트다운 테스트'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => flutterTts.speak("타이머가 종료되었습니다"),
                  child: const Text('종료 알림 테스트'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
