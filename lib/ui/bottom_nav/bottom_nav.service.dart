import 'package:dio/dio.dart';
import 'package:employee/const/url.const.dart';
import 'package:employee/service/api_service.dart';
import 'package:employee/ui/work_time/work_time.enum.dart';
import 'package:hive/hive.dart';

class MainService {
  //This method is to send break status to the server
  //depending on the application state
  static Future<void> sendStatus(bool appActive) async {
    saveWorkStatus((appActive) ? WorkStatus.endBreak : WorkStatus.startBreak);

    final formData =
        FormData.fromMap({"employee_id": Hive.box("user").get("empid")});

    await ApiService().post(
      (appActive) ? Urls.endBreak : Urls.addBreak,
      data: formData,
    );
    if (appActive) updateTime();
  }

  //This method is to update the locastorage time
  //when the user returns back to the app
  static Future<void> updateTime() async {
    final box = Hive.box('user');

    final formData = FormData.fromMap({
      "phone": box.get("phone"),
      "password": box.get("password"),
    });

    final res = await ApiService().post(
      Urls.login,
      data: formData,
    );

    if (res['success']) {
      box.put("empid", res["userId"]);
      box.put("startWorkTime", res["startWorkTime"]);
      box.put("endWorkTime", res["endWorkTime"]);
      box.put("startBreakTime", res["startBreakTime"]);
      box.put("endBreakTime", res["endBreakTime"]);
      box.put("lat", res["latitude"]);
      box.put("long", res["longitude"]);
      box.put('radius', res["radius"]);
    }
  }
}
