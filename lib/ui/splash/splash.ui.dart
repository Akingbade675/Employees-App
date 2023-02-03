import 'package:employee/const/url.const.dart';
import 'package:employee/gen/assets.gen.dart';
import 'package:employee/service/api_service.dart';
import 'package:employee/ui/bottom_nav/bottom_nav.ui.dart';
import 'package:employee/ui/login/login.ui.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  checkUser() async {
    final box = await Hive.openBox("user");
    final empid = box.get("empid");

    if (empid != null && empid != "") {
      final token = await FirebaseMessaging.instance.getToken();
      ApiService()
          .post(Urls.updateToken, data: {"employee_id": empid, "token": token});
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BottomNav()),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Hive.box('user').clear();
    Future.delayed(const Duration(seconds: 1), () {
      checkUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Assets.images.blueLogo.image(),
      ),
    );
  }
}
