// To parse this JSON data, do
//
//     final customerIdxGetResponse = customerIdxGetResponseFromJson(jsonString);

import 'dart:convert';

List<CustomerIdxGetResponse> customerIdxGetResponseFromJson(String str) => List<CustomerIdxGetResponse>.from(json.decode(str).map((x) => CustomerIdxGetResponse.fromJson(x)));

String customerIdxGetResponseToJson(List<CustomerIdxGetResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomerIdxGetResponse {
    int idx;
    String name;
    String country;
    int destinationid;
    String coverimage;
    String detail;
    int price;
    int duration;

    CustomerIdxGetResponse({
        required this.idx,
        required this.name,
        required this.country,
        required this.destinationid,
        required this.coverimage,
        required this.detail,
        required this.price,
        required this.duration,
    });

    factory CustomerIdxGetResponse.fromJson(Map<String, dynamic> json) => CustomerIdxGetResponse(
        idx: json["idx"],
        name: json["name"],
        country: json["country"],
        destinationid: json["destinationid"],
        coverimage: json["coverimage"],
        detail: json["detail"],
        price: json["price"],
        duration: json["duration"],
    );

    Map<String, dynamic> toJson() => {
        "idx": idx,
        "name": name,
        "country": country,
        "destinationid": destinationid,
        "coverimage": coverimage,
        "detail": detail,
        "price": price,
        "duration": duration,
    };
}
