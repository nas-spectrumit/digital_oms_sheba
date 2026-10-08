import 'package:flutter/material.dart';

////////// Colors Part //////////
Color primaryColor(BuildContext context) {
  return Theme.of(context).primaryColor;
}

Color primaryColorAccent(BuildContext context) {
  return Theme.of(context).hintColor;
}

Color myGreen = Color(0xff137547);
const Color myGreenAccent = Color(0xffd2f6e1);

const Color myBlue = Color(0xff00607a);
const Color myBlueAccent = Color(0xffb2f3ff);

const Color myRed = Color(0xff8d001b);
const Color myRedAccent = Color(0xffffccd5);

const Color myYellow = Color(0xffe3bb00);
const Color myYellowAccent = Color(0xfffdf8e1);

const Color myPurple = Colors.purple;

TextTheme textTheme(BuildContext context) {
  return Theme.of(context).textTheme;
}
