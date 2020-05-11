import 'package:flutter/cupertino.dart';
import 'package:flutter_route_apt/annotation/route_page.dart';

@page
class TenPage extends StatelessWidget {
  @PageParam(key: 'tenPageName')
  final String name;

  @PageParam(key: 'tenPageAge')
  final int age;

  @PageParam(key: 'sex')
  final int sex;

  const TenPage({Key key, this.name, this.age, this.sex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
