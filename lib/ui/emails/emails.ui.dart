import 'dart:convert';

import 'package:employee/const/url.const.dart';
import 'package:employee/models/all_employee.model.dart';
import 'package:employee/service/api_service.dart';
import 'package:employee/ui/chat/chat.ui.dart';
import 'package:flutter/material.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  AllEmployeeModel? employees;
  getEmployeeList() async {
    final res = await ApiService().get(
      Urls.allEmployee,
    );
    print(res);
    employees = AllEmployeeModel.fromJson(jsonDecode(res));
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      getEmployeeList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0.0),
      body: Container(
        color: Colors.white,
        child: ListView.separated(
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChatPage()));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    employees?.dataList[index].name ?? "",
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w600),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                height: 40.0,
                thickness: 1,
                color: Colors.black,
              );
            },
            itemCount: employees?.dataList.length ?? 0),
      ),
    );
  }
}
