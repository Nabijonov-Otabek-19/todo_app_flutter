import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void toast(String message) {
  Fluttertoast.showToast(
    msg: message,
    fontSize: 16,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black54,
    toastLength: Toast.LENGTH_SHORT,
    textColor: Colors.white,
    gravity: ToastGravity.BOTTOM,
  );
}
