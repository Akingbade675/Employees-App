import 'dart:async';
import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:employee/Utils/extension.dart';
import 'package:employee/const/color.const.dart';
import 'package:employee/const/url.const.dart';
import 'package:employee/gen/assets.gen.dart';
import 'package:employee/service/api_service.dart';
import 'package:employee/ui/work_time/lock_timer_notification.dart';
import 'package:employee/ui/work_time/work_time.enum.dart';
import 'package:employee/widgets/dialog.widget.dart';
import 'package:employee/widgets/primary_button.ui.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:is_lock_screen/is_lock_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class WorkTimePage extends StatefulWidget {
  const WorkTimePage({super.key});

  @override
  State<WorkTimePage> createState() => _WorkTimePageState();
}

bool appRunning = false;

class _WorkTimePageState extends State<WorkTimePage>
    with WidgetsBindingObserver {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  //flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>().requestPermission();
  bool timerRunning = false;
  Timer? _timer;
  Timer? _lockTimer;

  bool _isPaused = true;
  // DateTime? startTime;
  int _elapsedTime = 0;

  bool onLeave = false;
  bool onBreak = false;
  final assetsAudioPlayer = AssetsAudioPlayer();
  bool resmued = false;

  double? lat, long;

  WorkStatus? workStatus;
  int breakMinutes = 0;
  bool breakRunning = false;

  bool restrictedTimer = false;
  bool isOutsideLocation = false;

  bool isActive = true;

  Future<void> lateWork(String minutes) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    final formData = FormData.fromMap({
      "employee_id": Hive.box("user").get("empid"),
      "time": minutes,
    });
    final response = await ApiService().post(
      Urls.lateWork,
      data: formData,
    );
    Navigator.pop(context);
    Navigator.pop(context);
    Flushbar(
      message: "Requested Successfully",
      backgroundColor: AppColors.lightPurple,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  applyLeave() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    final formData = FormData.fromMap({
      "employee_id": Hive.box("user").get("empid"),
      "date":
          "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
      "reasion": "test"
    });
    final response = await ApiService().post(
      Urls.leave,
      data: formData,
    );
    final box = Hive.box("user");
    box.put("leaveData", DateTime.now());
    onLeave = true;
    setState(() {});
    final box2 = await Hive.openBox("timer");
    box2.clear();
    Navigator.pop(context);
    Navigator.pop(context);
    Flushbar(
      message: "Requested Successfully",
      backgroundColor: AppColors.lightPurple,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  Future<String?> startWork() async {
    final formData = FormData.fromMap({
      "employee_id": Hive.box("user").get("empid"),
    });
    final response = await ApiService().post(
      Urls.startWork,
      data: formData,
    );
    return response;
  }

  stopWork() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    // convert seconds to hour and minute and seconds
    int hours = (_elapsedTime ~/ 3600).toInt();
    int minutes = ((_elapsedTime % 3600) ~/ 60).toInt();
    int seconds = (_elapsedTime % 60).toInt();
    DateTime date = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, hours, minutes, seconds);
    final formData = FormData.fromMap({
      "employee_id": Hive.box("user").get("empid"),
      "time": Timestamp.fromDate(date)
    });
    final response = await ApiService().post(
      Urls.endWork,
      data: formData,
    );
    _timer?.cancel();
    _elapsedTime = 0;
    final box = Hive.box("timer");
    box.clear();
    // box.put("elapsedTime", _elapsedTime);
    setState(() {});
    Navigator.pop(context);
    Navigator.pop(context);
    Flushbar(
      message: response.toString(),
      backgroundColor: AppColors.lightPurple,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  addBreak(int time) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    final box = await Hive.openBox("timer");
    box.put("break", true);
    onBreak = true;
    breakRunning = true;
    workStatus = WorkStatus.endBreak;
    saveWorkStatus(workStatus ?? WorkStatus.endBreak);
    Future.delayed(Duration(seconds: time.abs()), () {
      assetsAudioPlayer.open(Audio(Assets.audios.alarm),
          loopMode: LoopMode.single);
      setState(() {
        breakRunning = false;
      });
    });
    setState(() {});
    final formData = FormData.fromMap({
      "employee_id": Hive.box("user").get("empid"),
      "time": time.toString(),
    });
    final response = await ApiService().post(
      Urls.addBreak,
      data: formData,
    );
    Navigator.pop(context);
    Navigator.pop(context);
    Flushbar(
      message: "jj".toString(),
      backgroundColor: AppColors.lightPurple,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  Future<void> endBreak() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    final box = await Hive.openBox("timer");
    box.put("break", false);
    final formData = FormData.fromMap({
      "employee_id": Hive.box("user").get("empid"),
    });
    final response = await ApiService().post(
      Urls.endBreak,
      data: formData,
    );
    _timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _elapsedTime++;
          box.put("elapsedTime", _elapsedTime);
        });
      }
    });
    workStatus = WorkStatus.endTime;
    saveWorkStatus(WorkStatus.endTime);
    final time = getWorkTime(workStatus ?? WorkStatus.endTime);
    final duration = DateTime.now()
        .difference(DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, time.hour, time.minute))
        .inSeconds;
    scheduleBreakPopup(duration.abs() + (breakMinutes * 60),
        isEndWorkPopup: true);
    setState(() {});
    Navigator.pop(context);
    Flushbar(
      message: response.toString(),
      backgroundColor: AppColors.lightPurple,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  void start() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    // Get cuurent time in minutes
    TimeOfDay now = TimeOfDay.now();
    int nowInMinutes = now.hour * 60 + now.minute;

    // Get startTime in minutes
    TimeOfDay startTime = getWorkTime(WorkStatus.startTime);
    int startTimeInMinutes = startTime.hour * 60 + startTime.minute;
    // Check if not yet work time
    // if (nowInMinutes < startTimeInMinutes) {
    //   Navigator.pop(context);
    //   showCustomDialog(context,
    //       title: "Working Time",
    //       message: "Your working time has not started",
    //       buttons: const SizedBox());
    //   return;
    // }
    final box = await Hive.openBox("timer");
    _elapsedTime = box.get("elapsedTime", defaultValue: 0);
    _isPaused = false;
    timerRunning = true;
    workStatus = WorkStatus.startBreak;
    saveWorkStatus(workStatus ?? WorkStatus.startBreak);
    if (box.get("break", defaultValue: false)) {
      await endBreak();
    }
    // if (startTime != null) {
    //   _elapsedTime =
    //       (startTime?.difference(DateTime.now()).inSeconds ?? 0).abs();
    // } else {
    //   box.put("startTime", DateTime.now());
    // }
    final response = await startWork();
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _elapsedTime++;
          box.put("elapsedTime", _elapsedTime);
        });
      }
    });
    Navigator.pop(context);
    Flushbar(
      message: response.toString(),
      backgroundColor: AppColors.lightPurple,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      duration: const Duration(seconds: 3),
    ).show(context);
    final time = getWorkTime(workStatus ?? WorkStatus.startBreak);
    breakMinutes = box.get("breakMinutes", defaultValue: 0);
    final duration = DateTime.now()
        .difference(DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, time.hour, time.minute))
        .inSeconds;
    log(duration.toString());
    scheduleBreakPopup(duration.abs() + (breakMinutes * 60));
  }

  void stop() {
    _timer?.cancel();
  }

  void pause() async {
    _isPaused = true;

    setState(() {});
  }

  void resume() async {
    _isPaused = true;
    final box = await Hive.openBox("timer");
    if (box.get("break", defaultValue: false)) {
      endBreak();
      assetsAudioPlayer.stop();
    }
    _isPaused = false;
    setState(() {});
  }

  void updateNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        sound: null, importance: Importance.max, priority: Priority.high);
    //var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'WORK TIMER',
        _elapsedTime.secondsToTimeString(), platformChannelSpecifics,
        payload: _elapsedTime.toString());
    // await flutterLocalNotificationsPlugin.periodicallyShow(0, 'WORK TIMER',
    //     secondsToTimeString(_elapsedTime), RepeatInterval.everyMinute, platformChannelSpecifics,
    //     androidAllowWhileIdle: true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {

    print("state 1 = $state");

    if (state == AppLifecycleState.resumed) {
      AwesomeNotifications().dismiss(10);
      _lockTimer?.cancel();
      flutterLocalNotificationsPlugin.cancelAll();
    } else if (state == AppLifecycleState.paused) {
      final isLock = await isLockScreen() ?? false;
      if (isLock && _timer != null && !_isPaused) {
        // Show timer in lock screen
        // _lockTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        //   AwesomeNotifications().cancel(8);
        //   AwesomeNotifications().createNotification(
        //       content: NotificationContent(
        //           id: 8,
        //           channelKey: 'basic_channel',
        //           locked: true,
        //           title: 'Timer',
        //           body: secondsToTimeString(_elapsedTime),
        //           category: NotificationCategory.Service,
        //           actionType: ActionType.Default));
        //   assetsAudioPlayer.stop();
        // });
        // assetsAudioPlayer.stop();
        _lockTimer = Timer.periodic(Duration(seconds: 1), (timer) {
          updateNotification();
        });
      }
      if (!isLock) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 10,
                channelKey: 'basic_channel',
                locked: true,
                title: 'Timer Paused',
                body: 'Timer is paused. Open the app to resume the timer',
                category: NotificationCategory.Service,
                actionType: ActionType.Default));
        pause();
      }
    } else if (state == AppLifecycleState.inactive) {
      final isLock = await isLockScreen();

      if (isLock ?? false) {
        return;
      } else {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 10,
                channelKey: 'basic_channel',
                title: 'Timer Paused',
                body: 'Timer is paused. Open the app to resume the timer',
                category: NotificationCategory.Service,
                locked: true,
                actionType: ActionType.Default));
        pause();
      }
    } else if (state == AppLifecycleState.detached) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 10,
              locked: true,
              channelKey: 'basic_channel',
              title: 'Timer Paused',
              body: 'Timer is paused. Open the app to resume the timer',
              category: NotificationCategory.Service,
              actionType: ActionType.Default));
      pause();
    }
  }

  Stream<Position>? locationStream;

  @override
  void dispose() {
    super.dispose();
    stop();
    WidgetsBinding.instance.removeObserver(this);
    _timer = null;
    _lockTimer = null;
    locationStream?.listen((event) {}).cancel();
    locationStream = null;
    Geolocator.getServiceStatusStream().listen((event) {}).cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("hola");

    LockScreenTimerNotification.initialize(flutterLocalNotificationsPlugin);
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration.zero, () async {
      Geolocator.getServiceStatusStream().listen((event) {
        if (event == ServiceStatus.enabled) {
          setState(() {
            restrictedTimer = false;
          });
        } else if (event == ServiceStatus.disabled) {
          setState(() {
            restrictedTimer = true;
          });
        }
      });

      locationStream = Geolocator.getPositionStream();
      final userBox = await Hive.openBox("user");

      locationStream?.listen((event) {
        final d = Geolocator.distanceBetween(
            event.latitude,
            event.longitude,
            double.parse(userBox.get("lat", defaultValue: "0") ?? "0"),
            double.parse(userBox.get("long", defaultValue: "0") ?? "0"));
        if (d > 200 && !isOutsideLocation) {
          pause();
          setState(() {
            isOutsideLocation = true;
          });
          assetsAudioPlayer.open(Audio(Assets.audios.alarm),
              loopMode: LoopMode.single);
          showCustomDialog(context, onDimiss: () {
            assetsAudioPlayer.stop();
          },
              title: "Timer Paused",
              message: "You stepped out of your location",
              buttons: const SizedBox());
        } else if (d < 200 && isOutsideLocation) {
          setState(() {
            isOutsideLocation = false;
          });
        }
        // else if() {
        //   setState(() {
        //     isOutsideLocation = false;
        //   });
        // }
      });
      workStatus = getWorkStatus();
      if (workStatus == WorkStatus.startBreak) {
        final timeBox = await Hive.openBox("timer");
        _elapsedTime = timeBox.get("elapsedTime");
        if (appRunning && !isOutsideLocation) {
          start();
        }
        // start();
      } else if (workStatus == WorkStatus.endBreak) {
        breakRunning = true;
        final time = getWorkTime(workStatus ?? WorkStatus.endBreak);
        final duration = DateTime.now()
            .difference(DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, time.hour, time.minute))
            .inSeconds;
        final box = await Hive.openBox("timer");
        breakMinutes = box.get("breakMinutes", defaultValue: 0);
        Future.delayed(Duration(seconds: duration.abs() + breakMinutes), () {
          assetsAudioPlayer.open(Audio(Assets.audios.alarm),
              loopMode: LoopMode.single);
          setState(() {
            breakRunning = false;
          });
        });
      } else if (workStatus == WorkStatus.endTime) {
        final time = getWorkTime(workStatus ?? WorkStatus.endTime);
        final duration = DateTime.now()
            .difference(DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, time.hour, time.minute))
            .inSeconds;
        final box = await Hive.openBox("timer");
        _elapsedTime = box.get("elapsedTime", defaultValue: 0);

        breakMinutes = box.get("breakMinutes", defaultValue: 0);
        scheduleBreakPopup(duration.abs() + (breakMinutes * 60),
            isEndWorkPopup: true);
      }
      setState(() {});
      final box = Hive.box("user");
      final DateTime? leave = box.get(
        "leaveData",
      );
      if (leave != null &&
          (leave.day == DateTime.now().day &&
              leave.month == DateTime.now().month &&
              leave.year == DateTime.now().year)) {
        onLeave = true;
        setState(() {});
      }
      // _elapsedTime = box.get("elapsedTime", defaultValue: 0);
      // setState(() {});
    });
    appRunning = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whitePurple,
      // appBar: AppBar(
      //   elevation: 0.0,
      //   backgroundColor: AppColors.whitePurple,
      // ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 70.0,
            ),
            Text(
              getWorkStatusText(workStatus ?? WorkStatus.startTime),
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 25.0),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              _elapsedTime.secondsToTimeString(),
              style: const TextStyle(fontSize: 68.0),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 5.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 2)),
              child: Text(
                getFormattedTime(
                    getWorkTime(
                      workStatus ?? WorkStatus.startTime,
                    ),
                    breakTime: breakMinutes),
                style:
                    const TextStyle(color: AppColors.lightBlue, fontSize: 40.0),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onLeave ||
                      breakRunning ||
                      restrictedTimer ||
                      isOutsideLocation
                  ? () {
                      if (isOutsideLocation) {
                        Flushbar(
                          message: "You're outside working location",
                          backgroundColor: AppColors.lightPurple,
                          flushbarPosition: FlushbarPosition.TOP,
                          flushbarStyle: FlushbarStyle.GROUNDED,
                          duration: const Duration(seconds: 3),
                        ).show(context);
                      } else {
                        Flushbar(
                          message: restrictedTimer
                              ? "GPS is disabled!"
                              : (breakRunning
                                  ? "You're on break!"
                                  : "You're on leave today!"),
                          backgroundColor: AppColors.lightPurple,
                          flushbarPosition: FlushbarPosition.TOP,
                          flushbarStyle: FlushbarStyle.GROUNDED,
                          duration: const Duration(seconds: 3),
                        ).show(context);
                      }
                    }
                  : () {
                      if (_isPaused) {
                        if (_elapsedTime == 0) {
                          start();
                        } else if (workStatus == WorkStatus.startBreak ||
                            _timer == null) {
                          start();
                        } else {
                          resume();
                        }
                      } else {
                        pause();
                      }
                    },
              child: _isPaused
                  ? Assets.images.timerOff.image(
                      width: MediaQuery.of(context).size.width * 0.8,
                    )
                  : Assets.images.timerOn.image(
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Spacer(),
            if (!timerRunning)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PrimaryButton(
                      color: Colors.black,
                      textColor: Colors.white,
                      onPressed: () {
                        showCustomDialog(context,
                            title: "Too late?",
                            message: "Do you want to work longer ?",
                            buttons: Column(
                              children: [
                                PrimaryButton(
                                  onPressed: () async {
                                    await lateWork("15");
                                  },
                                  title: "15 Minutes",
                                  color: Colors.black,
                                  textColor: Colors.white,
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                PrimaryButton(
                                  onPressed: () async {
                                    await lateWork("20");
                                  },
                                  title: "20 Minutes",
                                  color: Colors.black,
                                  textColor: Colors.white,
                                ),
                              ],
                            ));
                      },
                      width: MediaQuery.of(context).size.width * 0.4,
                      title: "Late for work?"),
                  PrimaryButton(
                    title: "Inform Sickness",
                    onPressed: () {
                      showCustomDialog(context,
                          title: "Sick?",
                          message: "Do you want to take leave?",
                          buttons: Column(
                            children: [
                              PrimaryButton(
                                onPressed: () async {
                                  applyLeave();
                                },
                                title: "Yes",
                                color: Colors.black,
                                textColor: Colors.white,
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              PrimaryButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                },
                                title: "No",
                                color: Colors.black,
                                textColor: Colors.white,
                              ),
                            ],
                          ));
                    },
                    width: MediaQuery.of(context).size.width * 0.4,
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }

  scheduleBreakPopup(int duration, {bool isEndWorkPopup = false}) {
    Future.delayed(Duration(seconds: duration), () {
      pause();
      showCustomDialog(context, onDimiss: () {
        assetsAudioPlayer.stop();
      },
          title: "Continue worktime",
          message: "DO you want to Continue work ?",
          buttons: Column(
            children: [
              PrimaryButton(
                onPressed: () async {
                  breakMinutes += 15;
                  final box = await Hive.openBox("timer");
                  box.put("breakMinutes", breakMinutes);
                  resume();
                  // if (!isEndWorkPopup) {
                  scheduleBreakPopup(breakMinutes * 60,
                      isEndWorkPopup: isEndWorkPopup);
                  // }
                  Navigator.pop(context);
                },
                title: "15 Minutes",
                color: Colors.black,
                textColor: Colors.white,
              ),
              const SizedBox(
                height: 15.0,
              ),
              PrimaryButton(
                onPressed: () async {
                  breakMinutes += 30;
                  final box = await Hive.openBox("timer");
                  box.put("breakMinutes", breakMinutes);
                  resume();
                  // setState(() {});
                  // if (!isEndWorkPopup) {
                  scheduleBreakPopup(breakMinutes * 60,
                      isEndWorkPopup: isEndWorkPopup);
                  // }
                  Navigator.pop(context);
                },
                title: "30 Minutes",
                color: Colors.black,
                textColor: Colors.white,
              ),
              const SizedBox(
                height: 15.0,
              ),
              PrimaryButton(
                title: isEndWorkPopup ? "Stop work" : "Start Break",
                onPressed: () {
                  if (!isEndWorkPopup) {
                    final time = getWorkTime(WorkStatus.endBreak);
                    final duration = DateTime.now()
                        .difference(DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                            time.hour,
                            time.minute))
                        .inSeconds;
                    addBreak(duration.abs() + (breakMinutes * 60));
                  } else {
                    stopWork();
                  }
                },
              )
            ],
          ));
      assetsAudioPlayer.open(Audio(Assets.audios.alarm),
          loopMode: LoopMode.single);
    });
  }
}
