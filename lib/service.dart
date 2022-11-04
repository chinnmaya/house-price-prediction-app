import 'package:flutter/cupertino.dart';
import 'package:house_price/result.dart';
import 'package:http/http.dart' as http;

class RequestApi {
  TextEditingController total_sqft;
  TextEditingController bath;
  int bhk1;
  int bhk2;
  int bhk3;
  int otherbhk;
  int ec;
  int kr;
  int sr;
  int wf;
  int other_loc;
  RequestApi({
    required this.total_sqft,
    required this.bath,
    required this.bhk1,
    required this.bhk2,
    required this.bhk3,
    required this.otherbhk,
    required this.ec,
    required this.kr,
    required this.sr,
    required this.wf,
    required this.other_loc,
  });

  Future<String?> getRent() async {
    var respone = await http.post(
        Uri.parse("http://housepricepreictor.herokuapp.com/predict"),
        body: {
          "total_sqft": total_sqft.text,
          "bath": bath.text,
          "bhk1": bhk1.toString(),
          "bhk2": bhk2.toString(),
          "bhk3": bhk3.toString(),
          "bhkother": otherbhk.toString(),
          "ec": ec.toString(),
          "kr": kr.toString(),
          "sr": sr.toString(),
          "wf": wf.toString(),
          "other_loc": other_loc.toString(),
        });

    if (respone.statusCode == 200) {
      var json = respone.body;
      var data = resultFromJson(json);
      return data.price;
    }
  }
}
