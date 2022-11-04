// To parse this JSON data, do
//
//     final result = resultFromJson(jsonString);
//created by CHINMAYA 04/11/22
import 'dart:convert';

Result resultFromJson(String str) => Result.fromJson(json.decode(str));

String resultToJson(Result data) => json.encode(data.toJson());

class Result {
  String price;

  Result({
    required this.price,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        price: json["Price"],
      );

  Map<String, dynamic> toJson() => {
        "Price": price,
      };
}
