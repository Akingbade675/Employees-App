import 'package:flutter/material.dart';

extension IntExtension on int {
  
  String secondsToTimeString() {
    int hours = (this / 3600).floor();
    int remainingSeconds = this - (hours * 3600);
    int minutes = (remainingSeconds / 60).floor();
    remainingSeconds = remainingSeconds - (minutes * 60);

    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  // String minutesToTime() {
  //   int hours = (this / 60).floor();
  //   int remainingSeconds = this - (hours * 3600);
  //   int minutes = (remainingSeconds / 60).floor();
  //   remainingSeconds = remainingSeconds - (minutes * 60);

  //   return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  // }
}


extension StringExtension on String {
  
  int timeToMninutes() {
    final timeArray = split(":");
    return ((timeArray[0] as int) * 60) + (timeArray[1] as int);
  }

  TimeOfDay getFormattedTimeOfDay(){
    final timeArray = split(":");
    final hour = int.parse(timeArray[0]);
    final minute = int.parse(timeArray[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }
}
