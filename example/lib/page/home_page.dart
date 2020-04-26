import 'package:flutter/cupertino.dart';
import 'package:flutter_route_apt/annotation/route_page.dart';

@RoutePage(scheme: 'lianjiabeikeft://home')
class HomePage extends StatelessWidget {
  @PageParam()
  final String homeTitle;
  @PageParam(key: 'time')
  final String homeTime;

  const HomePage({Key key, this.homeTitle, this.homeTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
