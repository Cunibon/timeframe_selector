import 'package:flutter/material.dart';
import 'package:timeframe_selector/timeframe_selector.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: TimeFrameExample(),
      ),
    );
  }
}

class TimeFrameExample extends StatefulWidget {
  const TimeFrameExample({super.key});

  @override
  State<TimeFrameExample> createState() => _TimeFrameExampleState();
}

class _TimeFrameExampleState extends State<TimeFrameExample> {
  DateTimeRange? selectedTimeframe;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: TimeframeSelector(
        baseTimeframe: DateTimeRange(
          start: DateTime(0, 1, 1, 10),
          end: DateTime(0, 1, 1, 24),
        ),
        noSelectionText: "No selection",
        timeSegmentLength: const Duration(minutes: 30),
        minTimeframeSegments: 4,
        selectedTimeframe: selectedTimeframe,
        blockedTimeframes: [
          DateTimeRange(
            start: DateTime(0, 1, 1, 15),
            end: DateTime(0, 1, 1, 17),
          ),
        ],
        onTimeframeChange: (newTimeframe) => setState(
          () {
            selectedTimeframe = newTimeframe;
          },
        ),
      ),
    );
  }
}
