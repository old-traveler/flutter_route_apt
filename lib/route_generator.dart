import 'dart:async';

import 'package:build/build.dart';
import 'package:flutter_route_apt/annotation/route_page.dart';
import 'package:flutter_route_apt/route_collector.dart';
import 'package:source_gen/source_gen.dart';

const TypeChecker routeChecker = TypeChecker.fromRuntime(AppRoute);

class RouteGenerator extends Generator {
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    if (library.annotatedWith(routeChecker).isNotEmpty) {
      StringBuffer stringBuffer = StringBuffer();
      for (var routeInfo in routeInfoList) {
        stringBuffer.write(routeInfo.toString());
      }
      return 'String route = \'\'\'${stringBuffer.toString()}\'\'\';';
    }
    return null;
  }
}
