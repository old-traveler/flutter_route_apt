// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// RouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:example/page/first_page.dart';
import 'package:example/page/second_page.dart';
import 'package:example/page/ten_page.dart';
import 'package:example/page/home_page.dart';
import 'package:example/page/four_page.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  String routeName = settings.name;
  switch (routeName) {
    case 'FirstPage':
      return MaterialPageRoute(
          builder: (context) => FirstPage(
                firstPageTitle: settings.arguments,
              ));
    case 'SecondPage':
      return MaterialPageRoute(
          builder: (context) => SecondPage(
                second: settings.arguments,
              ));
    case 'TenPage':
      return MaterialPageRoute(builder: (context) => TenPage());
    case 'lianjiabeikeft://home':
      Map<String, dynamic> map = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => HomePage(
                homeTitle: map['homeTitle'],
                homeTime: map['time'],
              ));
    case 'lianjiabeikeft:four':
      return MaterialPageRoute(
          builder: (context) => FourPage(
                cityId: settings.arguments,
              ));
  }
  return null;
}
