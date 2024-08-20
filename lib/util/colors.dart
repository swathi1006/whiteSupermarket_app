import 'package:flutter/material.dart';

const Color primary = Color(0xff302F7F);
const Color secondary = Color(0xff4AC2C1);
const Color greylight = Color(0xffE9E9E9);
const Color greyextralight = Color(0xffFF9F9F9);
const Color greenTint = Color(0xff02DAC5);
const Color textHintWhite = Colors.white60;
const Color white = Colors.white;
const Color lightBlue = Colors.lightBlue;
const Color black26=Colors.black26;
const Color black12=Colors.black12;
const Color black54=Colors.black54;
const Color black=Colors.black;
const Color grey=Colors.grey;
const Color green=Colors.green;
const Color blue=Colors.blue;
MaterialColor primaryColor = createMaterialColor(primary);
MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}