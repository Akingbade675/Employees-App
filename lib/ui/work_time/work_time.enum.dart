import 'package:employee/Utils/extension.dart';
import 'package:employee/ui/login/login.ui.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum WorkStatus {
  startTime,
  endTime,
  startBreak,
  endBreak,
}

String getWorkStatusText(WorkStatus status) {
  switch (status) {
    case WorkStatus.startTime:
      return "Start Work";
    case WorkStatus.endTime:
      return "End Working Time";
    case WorkStatus.startBreak:
      return "Break";
    case WorkStatus.endBreak:
      return "End Break";
    default:
      return "Start";
  }
}

TimeOfDay getWorkTime(WorkStatus status) {
  return getWorkTimeLocal(status).getFormattedTimeOfDay();
}

String getWorkTimeLocal(WorkStatus status) {
  final box = Hive.box("user");
  switch (status) {
    case WorkStatus.startTime:
      return box.get("startWorkTime");
    case WorkStatus.endTime:
      return box.get("endWorkTime");
    case WorkStatus.startBreak:
      return box.get('startBreakTime');
    case WorkStatus.endBreak:
      return box.get('endBreakTime');
    default:
      return "00:00";
  }
}

void saveWorkStatus(WorkStatus status) {
  final box = Hive.box("user");
  box.put("workStatus", status.name);
}

WorkStatus getWorkStatus() {
  final box = Hive.box("user");
  final text = box.get("workStatus");
  return WorkStatus.values.byName(text ?? "startTime");
}

String getFormattedTime(TimeOfDay time, {required int breakTime}) {
  int hour = time.hour;
  int minute = time.minute;
  if ((minute + breakTime) / 60 >= 1) {
    hour = hour + int.parse(((minute + breakTime) / 60).toStringAsFixed(0));
    minute = ((((minute + breakTime) / 60) -
                int.parse(((minute + breakTime) / 60).toStringAsFixed(0))) *
            60)
        .toInt();
  } else {
    minute += breakTime;
  }
  return "${hour.toString().padLeft(2, "0")}:${minute.toString().padLeft(2, "0")}";
}
