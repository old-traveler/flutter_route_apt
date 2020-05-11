import 'dart:async';

import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:flutter_route_apt/RouteInfo.dart';
import 'package:flutter_route_apt/annotation/route_page.dart';
import 'package:flutter_route_apt/route_collector.dart';
import 'package:source_gen/source_gen.dart';

const TypeChecker routeChecker = TypeChecker.fromRuntime(AppRoute);
AssetId outputId = AssetId('example', 'lib/main.route.dart');

class RouteGenerator extends Generator {
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    if (library.annotatedWith(routeChecker).isNotEmpty) {
      return outputAsString();
    }
    if (rewrite) {
      buildStep.writeAsString(
          outputId, DartFormatter().format(outputAsString(needHeader: true)));
    }
    return null;
  }

  String outputAsString({bool needHeader: false}) {
    rewrite = false;
    final routeList = routeInfoList.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    StringBuffer stringBuffer = StringBuffer();
    if (needHeader) {
      stringBuffer.write(getGeneratorHeader());
    }
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

  String getGeneratorHeader() {
    return '''
    // GENERATED CODE - DO NOT MODIFY BY HAND

    // **************************************************************************
    // RouteGenerator
    // **************************************************************************
    
    ''';
  }
}
