import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

void errorhandlefun(
    {required Response response,
    required BuildContext context,
    required VoidCallback onsucess}) {
  switch (response.statusCode) {
    case 200:
      onsucess();
      break;
    case 400:
      showSnackBar(context, jsonDecode(response.body)['msg']);
      break;
    case 500:
      showSnackBar(context, jsonDecode(response.body)['msg']);
      break;
    default:
      showSnackBar(context, response.body);
  }
}
