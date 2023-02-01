// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

AllEmployeeModel AllEmployeeModelFromJson(String str) =>
    AllEmployeeModel.fromJson(json.decode(str));

String AllEmployeeModelToJson(AllEmployeeModel data) =>
    json.encode(data.toJson());

class AllEmployeeModel {
  AllEmployeeModel({
    required this.dataList,
  });

  List<DataList> dataList;

  factory AllEmployeeModel.fromJson(Map<String, dynamic> json) =>
      AllEmployeeModel(
        dataList: List<DataList>.from(
            json["dataList"].map((x) => DataList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "dataList": List<dynamic>.from(dataList.map((x) => x.toJson())),
      };
}

class DataList {
  DataList({
    required this.id,
    required this.image,
    required this.name,
    required this.surname,
    required this.mobile,
    required this.phone,
    required this.address,
    required this.jobtitle,
  });

  String id;
  String image;
  String name;
  String surname;
  String mobile;
  String phone;
  String address;
  String jobtitle;

  factory DataList.fromJson(Map<String, dynamic> json) => DataList(
        id: json["id"],
        image: json["image"],
        name: json["name"],
        surname: json["surname"],
        mobile: json["mobile"],
        phone: json["phone"],
        address: json["address"],
        jobtitle: json["jobtitle"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "surname": surname,
        "mobile": mobile,
        "phone": phone,
        "address": address,
        "jobtitle": jobtitle,
      };
}
