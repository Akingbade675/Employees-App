import 'dart:convert';
import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:employee/const/color.const.dart';
import 'package:employee/const/url.const.dart';
import 'package:employee/gen/assets.gen.dart';
import 'package:employee/service/api_service.dart';
import 'package:employee/ui/bottom_nav/bottom_nav.ui.dart';
import 'package:employee/ui/forgot_password/forgot_password.ui.dart';
import 'package:employee/widgets/custom_text_field.widget.dart';
import 'package:employee/widgets/dialog.widget.dart';
import 'package:employee/widgets/primary_button.ui.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isDeviceConnected = false;
  bool isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      final b = await Permission.locationWhenInUse.request();
      final a = await Permission.locationAlways.request();
      log(a.isDenied.toString());

// You can can also directly ask the permission about its status.
      if (await Permission.location.isPermanentlyDenied) {
        Flushbar(
          message: "Please grant location permissions",
        ).show(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // formkey
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.whitePurple,
      ),
      body: Container(
        width: double.infinity,
        color: AppColors.whitePurple,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: formKey,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Assets.images.blueLogo.image(width: 140),
              const SizedBox(height: 20.0),
              const Text("Hello Again!",
                  style:
                      TextStyle(fontSize: 40.0, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10.0),
              const Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Amet, urna, a, fusce",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: AppColors.lightGrey),
              ),
              const SizedBox(
                height: 50.0,
              ),
              CustomTextField(
                hint: "Phone",
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                length: 15,
                keyboardType: TextInputType.number,
                controller: emailController,
                isRequired: true,
              ),
              const SizedBox(
                height: 20.0,
              ),
              CustomTextField(
                hint: "Password",
                controller: passwordController,
                isPassword: true,
                isRequired: true,
              ),
              const SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPassword()));
                },
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              PrimaryButton(
                title: isLoading ? "Please wait..." : "Login",
                onPressed: isLoading
                    ? null
                    : () async {
                        if (await getConnectivity() == false) return;
                        if (!formKey.currentState!.validate()) return;
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          final formData = FormData.fromMap({
                            "phone": emailController.text,
                            "password": passwordController.text,
                          });
                          final response = await ApiService()
                              .post(Urls.login, data: formData);
                          log(response.toString());

                          if (response.toString().contains("Invalid")) {
                            setState(() {
                              isLoading = false;
                            });
                            Flushbar(
                              flushbarPosition: FlushbarPosition.TOP,
                              backgroundColor: Colors.redAccent,
                              flushbarStyle: FlushbarStyle.GROUNDED,
                              message: "Invalid Credentials",
                              duration: const Duration(seconds: 3),
                            ).show(context);
                            return;
                          } else {
                            final res = jsonDecode(response);
                            if (res['status'] == "success") {
                              final box = Hive.box('user');

                              // Checks if another user is logging on one device
                              if (box.get('empid') != null && box.get('empid') != res["userId"]) {
                                setState(() {
                                  isLoading = false;
                                });
                                Flushbar(
                                  flushbarPosition: FlushbarPosition.TOP,
                                  backgroundColor: Colors.redAccent,
                                  flushbarStyle: FlushbarStyle.GROUNDED,
                                  message: "Another user already logged in using this device",
                                  duration: const Duration(seconds: 3),
                                ).show(context);
                                return;
                              }

                              box.put("empid", res["userId"]);
                              box.put("startWorkTime", res["startWorkTime"]);
                              box.put("endWorkTime", res["endWorkTime"]);
                              box.put("startBreakTime", res["startBreakTime"]);
                              box.put("endBreakTime", res["endBreakTime"]);
                              box.put("lat", res["latitude"]);
                              box.put("long", res["longitude"]);
                              final token =
                                  await FirebaseMessaging.instance.getToken();
                              await ApiService().post(Urls.updateToken, data: {
                                "employee_id": res["userId"],
                                "token": token
                              });
                              emailController.clear();
                              passwordController.clear();
                              AwesomeNotifications()
                                  .isNotificationAllowed()
                                  .then((isAllowed) {
                                if (!isAllowed) {
                                  // This is just a basic example. For real apps, you must show some
                                  // friendly dialog box before call the request method.
                                  // This is very important to not harm the user experience
                                  AwesomeNotifications()
                                      .requestPermissionToSendNotifications();
                                }
                              });
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const BottomNav()),
                                  (route) => false);
                            }
                          }
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });
                          Flushbar(
                            flushbarPosition: FlushbarPosition.TOP,
                            backgroundColor: Colors.redAccent,
                            flushbarStyle: FlushbarStyle.GROUNDED,
                            message: "Something went wrong\n$e",
                            duration: const Duration(seconds: 3),
                          ).show(context);
                        }
                      },
              ),
              const Spacer(),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: const [
              //     Text(
              //       "Don't have an account? ",
              //       style: TextStyle(fontSize: 16.0),
              //     ),
              //     Text(
              //       "Register",
              //       style: TextStyle(
              //           fontWeight: FontWeight.w700,
              //           fontSize: 16,
              //           color: AppColors.lightPurple),
              //     )
              //   ],
              // ),
              const SizedBox(
                height: 60.0,
              )
            ],
          ),
        ),
      ),
    );
  }

   Future<bool> getConnectivity() async {
    isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected) {
      showCustomDialog(context,
          title: "No Connection",
          message: "Check your internet connectivity",
          buttons: const SizedBox());
      return false;
    }
    else
      return true;
  }
}

TimeOfDay getFormattedTimeOfDay(String time) {
  final timeArray = time.split(":");
  final hour = int.parse(timeArray[0]);
  final minute = int.parse(timeArray[1]);
  return TimeOfDay(hour: hour, minute: minute);
}
