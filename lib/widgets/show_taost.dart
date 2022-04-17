
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


enum ToastState{SUCCESS,ERROR,WARNING}

Color chooseToastColor(ToastState state){

  Color? color;

  switch (state){
    case ToastState.ERROR:
      color = Colors.red;
      break;
    case ToastState.SUCCESS:
      color = Colors.green;
      break;
    case ToastState.WARNING:
      color = Colors.amber;
      break;

  }

  return color;
}

void showToast({required ToastState state,required String msg}){
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0
  );
}
