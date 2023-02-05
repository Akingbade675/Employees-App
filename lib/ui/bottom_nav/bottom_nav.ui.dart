import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:employee/Utils/main.service.dart';
import 'package:employee/const/color.const.dart';
import 'package:employee/gen/assets.gen.dart';
import 'package:employee/service/api_service.dart';
import 'package:employee/ui/emails/emails.ui.dart';
import 'package:employee/ui/profile/profile.ui.dart';
import 'package:employee/ui/work_time/work_time.ui.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../const/url.const.dart';
import '../work_time/work_time.enum.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with WidgetsBindingObserver {
  int index = 1;
  int counter = 0;
  PageController? _pageController;
  bool appActive = false;
  WorkStatus? workStatus;
  var state = null;
  Stream<TimeOfDay>? alarmStream = TimeOfDay.now().minute as Stream<TimeOfDay>?;
  @override
  initState() {
    super.initState();
    appActive = true;
    _pageController = PageController(initialPage: index);
    log('09e77e77e65gsytyg');
    alarmStream?.listen((event) {
      () => MainService.ringAlarm();
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  dispose() {
    super.dispose();
    appActive = true;
    WidgetsBinding.instance.removeObserver(this);
    _pageController?.dispose();
    alarmStream?.listen((event) {});
    alarmStream = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) async {
    super.didChangeAppLifecycleState(appState);
    appActive = appState == AppLifecycleState.resumed;
    state = appState;
    await MainService.sendStatus(appActive);
  }

  List<Widget> items = [
    const ProfilePage(),
    const WorkTimePage(),
    const EmailPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFAAAFB6), width: 0.5)),
        ),
        child: BottomNavigationBar(
            currentIndex: index,
            onTap: (value) {
              setState(() {
                index = value;
                _pageController?.animateToPage(index,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.ease);
              });
            },
            items: [
              BottomNavigationBarItem(
                  activeIcon: Assets.icons.profile
                      .image(width: 35.0, color: AppColors.lightPurple),
                  icon: Assets.icons.profile
                      .image(width: 35.0, color: Colors.grey),
                  label: ''),
              BottomNavigationBarItem(
                  activeIcon: Assets.icons.stopwatch
                      .image(width: 40.0, color: AppColors.lightPurple),
                  icon: Assets.icons.stopwatch
                      .image(width: 40.0, color: Colors.grey),
                  label: ''),
              BottomNavigationBarItem(
                  activeIcon: Assets.icons.message
                      .image(width: 40.0, color: AppColors.lightPurple),
                  icon: Assets.icons.message
                      .image(width: 40.0, color: Colors.grey),
                  label: '')
            ]),
      ),
      body: PageView(
        allowImplicitScrolling: false,
        scrollDirection: Axis.horizontal,
        controller: _pageController,
        children: items,
      ),
    );
  }
}
