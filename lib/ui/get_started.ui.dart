import 'package:employee/const/color.const.dart';
import 'package:employee/gen/assets.gen.dart';
import 'package:employee/ui/login/login.ui.dart';
import 'package:employee/widgets/primary_button.ui.dart';
import 'package:flutter/material.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({super.key});

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: AppColors.darkPurple,
        child: Column(
          children: [
            const SizedBox(
              height: 100.0,
            ),
            Assets.images.whiteLogo.image(width: 100),
            const SizedBox(
              height: 40.0,
            ),
            Assets.images.loginImage.image(
              width: MediaQuery.of(context).size.width,
            ),
            const Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              // height: 450,
              child: Stack(
                children: [
                  Assets.images.loginBg.image(
                    height: 460,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40.0,
                        ),
                        const Text(
                          "Keeping proper track of the time spent at work at ease",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 50.0,
                              fontFamily: "Lato",
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        PrimaryButton(
                          title: "Get Started",
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
