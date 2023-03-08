//dart 기본 패키지
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

var mainTheme = ThemeData(
    appBarTheme: AppBarTheme(
      color: Colors.white,
      titleTextStyle:TextStyle(fontFamily: "NanumSquareRoundEB", color:  Color(0xff2E3C7E), fontSize: 25),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xff2E3C7E),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
    )
);