// To parse this JSON data, do
//
//     final customerLoginPostResquest = customerLoginPostResquestFromJson(jsonString);

import 'dart:convert';

CustomerLoginPostResquest customerLoginPostResquestFromJson(String str) =>
    CustomerLoginPostResquest.fromJson(json.decode(str));

String customerLoginPostResquestToJson(CustomerLoginPostResquest data) =>
    json.encode(data.toJson());

class CustomerLoginPostResquest {
  String phone;
  String password;

  CustomerLoginPostResquest({required this.phone, required this.password});

  factory CustomerLoginPostResquest.fromJson(Map<String, dynamic> json) =>
      CustomerLoginPostResquest(
        phone: json["phone"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {"phone": phone, "password": password};
}
