import 'package:digital_oms_sheba/core/constant/colors_custom.dart';
import 'package:flutter/material.dart';

Decoration screenBackgroundGradient(BuildContext context) {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [primaryColorAccent(context), Colors.grey.shade100],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );
}
