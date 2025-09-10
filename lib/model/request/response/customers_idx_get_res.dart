// To parse this JSON data, do
//
//     final customerIdxGetResponse = customerIdxGetResponseFromJson(jsonString);

import 'dart:convert';

List<CustomerIdxGetResponse> customerIdxGetResponseFromJson(String str) => List<CustomerIdxGetResponse>.from(json.decode(str).map((x) => CustomerIdxGetResponse.fromJson(x)));

String customerIdxGetResponseToJson(List<CustomerIdxGetResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomerIdxGetResponse {
    int idx;
    String fullname;
    String phone;
    String email;
    String image;

    CustomerIdxGetResponse({
        required this.idx,
        required this.fullname,
        required this.phone,
        required this.email,
        required this.image,
    });

    factory CustomerIdxGetResponse.fromJson(Map<String, dynamic> json) => CustomerIdxGetResponse(
        idx: json["idx"],
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "idx": idx,
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
    };
}
