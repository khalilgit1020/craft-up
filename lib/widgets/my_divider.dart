import 'package:flutter/material.dart';
import 'package:graduation/constants.dart';

Padding MyDivider({double? startIndent = 0, double? endIndent = 0})=> Padding(
  padding:const EdgeInsets.all(1),
  child: Divider(
    thickness: 1.5,
    indent: startIndent,
    endIndent: endIndent,
  ),
);