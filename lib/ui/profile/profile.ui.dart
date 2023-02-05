// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:employee/const/color.const.dart';
import 'package:employee/const/url.const.dart';
import 'package:employee/service/api_service.dart';
import 'package:employee/ui/login/login.ui.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> profile = {};
  getProfile() async {
    final res = await ApiService().get(
      Urls.employeeDetail,
      queryParameters: {"empid": Hive.box("user").get("empid")},
    );
    print(res);
    final temp = jsonDecode(res ?? "");
    if (mounted) {
      setState(() {
        profile = temp;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.whitePurple,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () async {
                  final box = await Hive.openBox("user");
                    final box2 = await Hive.openBox("timer");
                  final formData = FormData.fromMap({
                    "employee_id": box.get('empid')
                  });
                  final response = await ApiService()
                  
                      .post(Urls.login, data: formData);
                  final res = jsonDecode(response);
                  if (res.errorCode == '0000') {
                    
                      box.clear();
                      box2.clear();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (route) => false);
                    }
                  }
                  ,
                child: const Text(
                  "Logout",
                  style: TextStyle(
                      color: AppColors.lightPurple,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
              ),
            ),
            Container(
              width: 100.0,
              height: 110.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        // profile["image"] ??
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjBqBHVe6sgC-lKbpBQQmOyLKNDasEFqYCUw&usqp=CAU",
                      ))),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              profile["name"] ?? "Demo",
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 28.0),
            ),
            const Spacer(),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Settings",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            ...[
              "Change Password",
              "Change E-Mail",
              "AGB",
              "Impressum",
              "Datenschutzerklärung"
            ]
                .map((String e) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(6, 4),
                                blurRadius: 24,
                                spreadRadius: 0,
                                color:
                                    const Color(0xff1e20240f).withOpacity(0.06))
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0)),
                      child: ListTile(
                        title: Text(
                          e,
                          style: const TextStyle(fontSize: 16),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.black,
                        ),
                      ),
                    ))
                .toList(),
            const SizedBox(
              height: 10.0,
            )
          ],
        ),
      ),
    );
  }
}
