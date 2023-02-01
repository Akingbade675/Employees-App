import 'package:employee/const/color.const.dart';
import 'package:employee/gen/assets.gen.dart';
import 'package:employee/ui/forgot_password/reset_password.ui.dart';
import 'package:employee/widgets/custom_text_field.widget.dart';
import 'package:employee/widgets/primary_button.ui.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.whitePurple,
      ),
      body: Container(
        width: double.infinity,
        color: AppColors.whitePurple,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Assets.images.blueLogo.image(width: 140),
            const SizedBox(height: 20.0),
            const Text("Hello Again!",
                style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10.0),
            const Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Amet, urna, a, fusce",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: AppColors.lightGrey),
            ),
            const SizedBox(
              height: 50.0,
            ),
            const CustomTextField(hint: "Enter your E-mail"),
            const SizedBox(
              height: 150.0,
            ),
            PrimaryButton(
              title: "Send Password",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ResetPassword()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
