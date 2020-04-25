import 'package:flutter/cupertino.dart';
import 'package:flutter_route_apt/annotation/route_page.dart';

@page
class SecondPage extends StatelessWidget {
  @PageParam(key: 'secondParam')
  final String second;

  const SecondPage({Key key, this.second}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
