import 'package:flutter/material.dart';
import 'package:flutter_route_apt/annotation/route_page.dart';

void main() => runApp(MyApp());

@AppRoute()
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
    );
  }
}

