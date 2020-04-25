import 'package:flutter/cupertino.dart';
import 'package:flutter_route_apt/annotation/route_page.dart';

@page
class FirstPage extends StatelessWidget {
  @PageParam()
  final firstPageTitle;

  const FirstPage({Key key, this.firstPageTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
