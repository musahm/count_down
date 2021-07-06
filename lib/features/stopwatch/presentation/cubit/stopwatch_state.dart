part of 'stopwatch_cubit.dart';

@immutable
abstract class StopwatchState {}

class StopwatchInitial extends StopwatchState {}

class StartTimer extends StopwatchState {
  StartTimer();

  Duration getDuration(String displayText) {
    print(displayText);
    int hrs = int.parse(displayText.substring(0, 2));
    int mins = int.parse(displayText.substring(2, 4));
    int secs = int.parse(displayText.substring(4));

    return Duration(hours: hrs, minutes: mins, seconds: secs);
  }
}

class NumberButtonPressed extends StopwatchState {
  final String number;
  NumberButtonPressed({required this.number});

  String shiftNumbersToLeft(String displayText, String number) {
    List<String> temp = displayText.split("");

    if (temp[0] == "0") {
      for (int i = 0; i < temp.length - 1; i++) {
        temp[i] = temp[i + 1];
      }

      temp[temp.length - 1] = number;
    }

    return temp.join();
  }

  String getValue(String displayText, String number) {
    return this.shiftNumbersToLeft(displayText, number);
  }
}

class ClearButtonPress extends StopwatchState {
  ClearButtonPress();

  String shiftNumbersToRight(String displayText) {
    List<String> temp = displayText.split("");

    if (int.parse(temp.join()) > 0) {
      for (int i = temp.length - 1; i > 0; i--) {
        temp[i] = temp[i - 1];
      }

      temp[0] = "0";
    }

    return temp.join();
  }

  String getValue(String displayText) {
    return this.shiftNumbersToRight(displayText);
  }
}
