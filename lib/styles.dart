import 'package:flutter/material.dart';

class AppStyles {
  static const logoStyle = TextStyle(
    color: Color.fromARGB(255, 221, 233, 246),
    fontSize: 26,
    fontWeight: FontWeight.bold,
    fontFamily: "Arial",
  );

  static const plainText = TextStyle(
    fontStyle: FontStyle.normal,
    color: Colors.black,
    fontSize: 14.0,
  );

  static const italicText = TextStyle(
    fontStyle: FontStyle.italic,
    color: Colors.black,
    fontSize: 14.0,
  );

  static const boldText = TextStyle(
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    fontSize: 14.0,
  );

  static const headerText = TextStyle(
    fontStyle: FontStyle.normal,
    color: Colors.black,
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
  );

  static const largeHeader = TextStyle(
    fontStyle: FontStyle.normal,
    color: Colors.black,
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
  );

  static const calendarDates = TextStyle(
    fontStyle: FontStyle.normal,
    color: Colors.black,
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
  );

  static const feedButton = TextStyle(
    fontSize: 14.0,
    fontFamily: 'Eurofurence',
  );

  static const stripes = Color.fromARGB(255, 221, 233, 246);
  static const resultExcluded = Color.fromARGB(255, 200, 200, 255);
  static const resultIncluded = Color.fromARGB(255, 200, 255, 200);
}
