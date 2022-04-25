import 'package:flutter/material.dart';

customErrorScreen() {
  return ErrorWidget.builder = ((details) {
    return const Material(
      child: Center(
        child: Text(
          'يوجد خطا ما\nالرجاء تحديث الصفحة...',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  });
}
