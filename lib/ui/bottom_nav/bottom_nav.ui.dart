import 'package:employee/const/color.const.dart';
import 'package:employee/gen/assets.gen.dart';
import 'package:employee/ui/emails/emails.ui.dart';
import 'package:employee/ui/profile/profile.ui.dart';
import 'package:employee/ui/work_time/work_time.ui.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int index = 1;
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
      body: items.elementAt(index),
    );
  }
}
