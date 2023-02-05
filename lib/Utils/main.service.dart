import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dio/dio.dart';
import 'package:employee/Utils/work_time.service.dart';
import 'package:employee/const/url.const.dart';
import 'package:employee/gen/assets.gen.dart';
import 'package:employee/service/api_service.dart';
import 'package:employee/ui/work_time/work_time.enum.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MainService {
  //This method is to send break status to the server
  //depending on the application state
  static Future<void> sendStatus(bool appActive) async {
    saveWorkStatus((appActive) ? WorkStatus.endBreak : WorkStatus.startBreak);

    final formData =
        FormData.fromMap({"employee_id": Hive.box("user").get("empid")});

    await ApiService().post(
      (appActive) ? Urls.endBreak : Urls.addBreak,
      data: formData,
    );
    if (appActive) updateTime();
  }

  //This method is to update the locastorage time
  //when the user returns back to the app
  static Future<void> updateTime() async {
    final box = Hive.box('user');

    final formData = FormData.fromMap({
      "phone": box.get("phone"),
      "password": box.get("password"),
    });

    final res = await ApiService().post(Urls.login, data: formData);

    if (res['success']) {
      box.put("empid", res["userId"]);
      box.put("startWorkTime", res["startWorkTime"]);
      box.put("endWorkTime", res["endWorkTime"]);
      box.put("startBreakTime", res["startBreakTime"]);
      box.put("endBreakTime", res["endBreakTime"]);
      box.put("lat", res["latitude"]);
      box.put("long", res["longitude"]);
      box.put('radius', res["radius"]);
    }
  }

  static Stream<void> ringAlarm() async* {
    final box = Hive.box("timer");
    log('message = 09876');
    // while (true) {
    // Get cuurent time in minutes
    TimeOfDay now = TimeOfDay.now();
    int nowInMinutes = now.hour * 60 + now.minute;

    TimeOfDay startTime = getWorkTime(WorkStatus.startTime);
    int startTimeInMinutes = startTime.hour * 60 + startTime.minute;

    // Get endTime in minutes
    TimeOfDay endTime = getWorkTime(WorkStatus.endTime);
    int endTimeInMinutes = endTime.hour * 60 + endTime.minute;

    // await Future.delayed(const Duration(seconds: 5));

    if (!box.get('startedWorking') ?? false) {
      if (nowInMinutes == startTimeInMinutes) {
        _alarm(1);
      }
    } else if (box.get('startedWorking') ?? false) {
      if (nowInMinutes == endTimeInMinutes) {
        _alarm(1);
      } else {
        dynamic breakTime = Hive.box('timer').get('breakTimeList') as List;
        for (var brk in breakTime) {
          
          var t1 = brk.startBreakTime.toString().split(':');
          var t2 = brk.endBreakTime.toString().split(':');
          
          var startBrkInMinutes = t1[0] * 60 + t1[1];
          var endBrkInMinutes = t2[0] * 60 + t2[1];
          
          log('timing = $startBrkInMinutes $endBrkInMinutes');

          if (nowInMinutes == startBrkInMinutes ||
              nowInMinutes == endBrkInMinutes) {
            _alarm(1);
            log('break alarm');
          }
        }
      }
    }

    log('working');

  }

  static _alarm(int count) {
    var assetsAudioPlayer = AssetsAudioPlayer();
    for (var i = 0; i < count; i++) {
      assetsAudioPlayer.open(Audio(Assets.audios.alarm),
          loopMode: LoopMode.single);
      log('i = $i');
    }
    log('alarm ringing');
  }
}
