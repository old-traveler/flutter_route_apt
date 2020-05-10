import 'dart:async';

import 'package:build/build.dart';
import 'package:flutter_route_apt/RouteInfo.dart';
import 'package:flutter_route_apt/annotation/route_page.dart';
import 'package:flutter_route_apt/route_collector.dart';
import 'package:source_gen/source_gen.dart';

const TypeChecker routeChecker = TypeChecker.fromRuntime(AppRoute);
AssetId outputId;

class RouteGenerator extends Generator {
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    if (library.annotatedWith(routeChecker).isNotEmpty) {
      outputId = AssetId(buildStep.inputId.package,
          buildStep.inputId.path.replaceFirst('.dart', '.route.dart'));
      return outputAsString();
    }
    if (rewrite && outputId != null) {
      buildStep.writeAsString(outputId, outputAsString());
    }
    return null;
  }

  String outputAsString() {
    rewrite = false;
    final routeList = routeInfoList.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write('import \'package:flutter/material.dart\';\n');
    for (var routeInfo in routeList) {
      stringBuffer.write('import \'${routeInfo.import}\';\n');
    }
    stringBuffer.write('''
        Route<dynamic> onGenerateRoute(RouteSettings settings) {
          String routeName = settings.name;
          switch (routeName) {
    ''');
    for (var routeInfo in routeList) {
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
