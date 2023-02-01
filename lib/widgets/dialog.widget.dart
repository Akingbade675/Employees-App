import 'package:employee/const/color.const.dart';
import 'package:employee/widgets/primary_button.ui.dart';
import 'package:flutter/material.dart';

showCustomDialog(BuildContext context,
    {bool isYesNo = false,
    required String title,
    required String message,
    required Widget buttons,
    Function? onDimiss}) async {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            width: MediaQuery.of(context).size.width * 0.95,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(24)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 34,
                        color: AppColors.lightGrey,
                      ),
                    )),
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 25.0),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(fontSize: 16, color: AppColors.lightGrey),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                buttons,
                const SizedBox(
                  height: 30.0,
                )
              ],
            ),
          ),
        );
      }).then((value) {
    if (onDimiss != null) {
      onDimiss();
    }
  });
}

showSingleButtonDialog(BuildContext context) async {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            width: MediaQuery.of(context).size.width * 0.95,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(24)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 34,
                        color: AppColors.lightGrey,
                      ),
                    )),
                const Text(
                  'Nachricht makieren',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25.0),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  """Wichtig

Ausstehend

zur Besprechung

Erledigt

Kommentar löschen""",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: AppColors.lightGrey),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                const PrimaryButton(
                  title: "Kommentieren",
                  color: Colors.black,
                  textColor: Colors.white,
                ),
                const SizedBox(
                  height: 30.0,
                )
              ],
            ),
          ),
        );
      });
}
