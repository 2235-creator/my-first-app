// To parse this JSON data, do
//
//     final customerRegisterPostRespone = customerRegisterPostResponeFromJson(jsonString);

import 'dart:convert';

CustomerRegisterPostRespone customerRegisterPostResponeFromJson(String str) => CustomerRegisterPostRespone.fromJson(json.decode(str));

String customerRegisterPostResponeToJson(CustomerRegisterPostRespone data) => json.encode(data.toJson());

class CustomerRegisterPostRespone {
    String message;
    int id;

    CustomerRegisterPostRespone({
        required this.message,
        required this.id,
    });

    factory CustomerRegisterPostRespone.fromJson(Map<String, dynamic> json) => CustomerRegisterPostRespone(
        message: json["message"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "id": id,
    };
}
