This package implements a timeframe selector, similar as what you would use in a calender.
It is meant to be used like a DateTimeRange picker, but for timeframes instead of days.

After not finding what I was searching for I made my own and now you found it

Check out the Demo: https://firebon.de:8081/TimeframeDemo/

https://github.com/user-attachments/assets/4cbceeea-703d-48ab-8040-af25a8de41c8

## Features

* Move and scale timeframe
* Block specific time ranges from selection
* Define minimum amount of segments

## Usage

Since its a fairly simple widget that does not handle its own state you should put it in a StatefulWidget

```dart
  TimeframeSelector(
    baseTimeframe: DateTimeRange(
      start: DateTime(0, 1, 1, 10),
      end: DateTime(0, 1, 1, 24),
    ),
    noSelectionText: "No selection",
    timeSegmentLength: const Duration(minutes: 30),
    minTimeframeSegments: 4,
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
    ],
    onTimeframeChange: (newTimeframe) => setState(
      () {
        selectedTimeframe = newTimeframe;
      },
    ),
  ),
```

## Additional information

Feel free to create a ticket on the Github repo, I will try to answer as fast as possible, but I also work fulltime.
If you want to support me please check out my game on steam :D 
https://store.steampowered.com/app/2226140/Crypt_Architect/

