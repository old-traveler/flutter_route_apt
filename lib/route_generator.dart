import 'dart:async';

import 'package:build/build.dart';
import 'package:flutter_route_apt/RouteInfo.dart';
import 'package:flutter_route_apt/annotation/route_page.dart';
import 'package:flutter_route_apt/route_collector.dart';
import 'package:source_gen/source_gen.dart';

const TypeChecker routeChecker = TypeChecker.fromRuntime(AppRoute);

class RouteGenerator extends Generator {
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    if (library.annotatedWith(routeChecker).isNotEmpty) {
      return outputAsString();
    }
    return null;
  }

  String outputAsString() {
    StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write('import \'package:flutter/material.dart\';\n');
    for (var routeInfo in routeInfoList) {
      stringBuffer.write('import \'${routeInfo.import}\';\n');
    }
    stringBuffer.write('''
        Route<dynamic> onGenerateRoute(RouteSettings settings) {
          String routeName = settings.name;
          switch (routeName) {
    ''');
    for (var routeInfo in routeInfoList) {
      stringBuffer.write('  case \'${routeInfo.name}\':\n');
      if ((routeInfo.params?.length ?? 0) > 1) {
        stringBuffer.write('Map<String,dynamic> map = settings.arguments;\n');
      }
      stringBuffer.write(
          '  return MaterialPageRoute(builder: (context) => ${routeInfo.className}(${getParamString(routeInfo.params)}));');
    }
    stringBuffer.write('''
        }
          return null;
    }''');
    return stringBuffer.toString();
  }

  String getParamString(List<ParamInfo> params) {
    if (params?.isNotEmpty != true) {
      return '';
    }
    if (params.length == 1) {
      return '${params[0].paramName}: settings.arguments,';
    }
    StringBuffer stringBuffer = StringBuffer();
    for (var value in params) {
      stringBuffer.write('${value.paramName}: map[\'${value.mapKey}\'],');
    }
    return stringBuffer.toString();
  }
}
