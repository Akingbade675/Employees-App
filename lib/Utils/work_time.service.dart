import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';

class WorkTimeService {
  static _localStorage() async {
    return (Hive.isBoxOpen('timer'))
        ? await Hive.openBox('timer')
        : Hive.box('timer');
  }

  static currentBreakTime() async {
    // List<Map<String, dynamic>> breakTimeList =
        // await _localStorage().then((value) => value.get('breakTimeList'));

    log('break time list = ${await _localStorage().then((value) => value.get('breakTimeList'))}');
  }
}
