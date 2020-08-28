import 'dart:ui';

import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
      textTheme: _getTextTheme(),
      scaffoldBackgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      fontFamily: 'Roboto',
      canvasColor: Colors.white,
      errorColor: Colors.red,
      primaryColor: Color(0xffE0E0E0),
      accentColor: Color(0xfff2994a),
      buttonColor: Color(0xfff2994a),
      backgroundColor: Colors.white,
      bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.transparent
      ),
      buttonTheme: ButtonThemeData(
          minWidth: 209,
          height: 50,
          buttonColor: Color(0xfff2994a),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0))),
      visualDensity: VisualDensity.adaptivePlatformDensity);

  //TODO
  static final ThemeData darkTheme = ThemeData(
      textTheme: _getTextTheme(),
      scaffoldBackgroundColor: Colors.black,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      fontFamily: 'Roboto',
      canvasColor: Colors.white,
      errorColor: Colors.red,
      primaryColor: Colors.black,
      accentColor: Colors.green,
      buttonColor: Colors.green,
      backgroundColor: Colors.black,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.transparent
      ),
      buttonTheme: ButtonThemeData(
          minWidth: 50,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0))),
      visualDensity: VisualDensity.adaptivePlatformDensity);

  static TextTheme _getTextTheme() {
    return TextTheme(
        headline1: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 50.0, color: Colors.black),
        headline2: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 30.0, color: Colors.black),
        headline3: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 24.0, color: Colors.black),
        headline4: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20.0,
            color: Color(0xFF828282)),
        headline5: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 24.0,
            color: Color(0xff8E8E93)),
        headline6: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 20.0, color: Color(0xFF4F4F4F)),
        subtitle1: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            color: Color(0xff828282)),
        subtitle2: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14.0,
            color: Color(0xffBDBDBD)),
        bodyText1: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16.0,
            color: Colors.black),
        bodyText2: TextStyle(
            fontWeight: FontWeight.normal, fontSize: 14.0, color: Colors.white),
        button: TextStyle(
            fontWeight: FontWeight.normal, fontSize: 18.0, color: Colors.white),
        caption: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12.0,
            color: Colors.white),
        overline: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12.0,
            color: Colors.black));
  }
}
