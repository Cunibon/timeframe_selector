import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  String? getTimeframeString() {
    if (selectedTimeframe != null) {
      final startString = DateFormat.Hm().format(
        selectedTimeframe!.start,
      );
      final endString = DateFormat.Hm().format(
        selectedTimeframe!.end,
      );
      return "$startString - $endString";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(getTimeframeString() ?? "No selection"),
          ),
          TimeframeSelector(
            baseTimeframe: DateTimeRange(
              start: DateTime(0, 1, 1, 10),
              end: DateTime(0, 1, 1, 24),
            ),
            timeSegmentLength: const Duration(minutes: 30),
            minTimeframeSegments: 4,
            maxTimeframeSegments: 8,
            selectedTimeframe: selectedTimeframe,
            overlayDatas: [
              OverlayData(
                timeframes: [
                  DateTimeRange(
                    start: DateTime(0, 1, 1, 15),
                    end: DateTime(0, 1, 1, 17),
                  ),
                ],
              ),
              OverlayData(
                timeframes: [
                  DateTimeRange(
                    start: DateTime(0, 1, 1, 20),
                    end: DateTime(0, 1, 1, 22),
                  ),
                ],
                color: Colors.green.withOpacity(0.2),
                borderColor: Colors.green.withOpacity(0.4),
                blockSelection: false,
                child: const Text("Hello world!"),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Hello world!")),
                  );
                },
              ),
            ],
            onTimeframeChange: (newTimeframe) => setState(
              () {
                selectedTimeframe = newTimeframe;
              },
            ),
          ),
        ],
      ),
    );
  }
}
