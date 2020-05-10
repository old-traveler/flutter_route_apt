import 'package:flutter/cupertino.dart';
import 'package:flutter_route_apt/annotation/route_page.dart';

@RoutePage(scheme: 'lianjiabeikeft:four')
class FourPage extends StatelessWidget {
  @PageParam()
  final String cityId;


  const FourPage({Key key, this.cityId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(cityId),
    );
  }
}
