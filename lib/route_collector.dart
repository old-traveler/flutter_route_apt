import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:flutter_route_apt/annotation/route_page.dart';
import 'package:source_gen/source_gen.dart';

import 'RouteInfo.dart';

const TypeChecker pageRoute = TypeChecker.fromRuntime(RoutePage);
const TypeChecker pageParam = TypeChecker.fromRuntime(PageParam);

List<RouteInfo> routeInfoList = [];

class RouteCollector extends Generator {
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    for (var annotatedElement in library.annotatedWith(pageRoute)) {
      final className = annotatedElement.element.displayName;
      final path = buildStep.inputId.path;
      final package = buildStep.inputId.package;
      final import = "package:$package/${path.replaceFirst('lib/', '')}";
      final routeName =
          annotatedElement.annotation.peek('scheme')?.stringValue ?? className;
      routeInfoList.add(RouteInfo(import, routeName, className,
          findParamFromClassElement(annotatedElement.element)));
    }
    return null;
  }

  List<ParamInfo> findParamFromClassElement(Element element) {
    final paramKeyList = <ParamInfo>[];
    if (element is ClassElement) {
      for (var annotatedElement in pageParamWith(element)) {
        String fieldName = annotatedElement.element.displayName;
        String fieldKey =
            annotatedElement.annotation.peek('key')?.stringValue ?? fieldName;
        paramKeyList.add(ParamInfo(fieldName, fieldKey));
      }
    } else {
      throw Exception('PageRoute must be decorated on class');
    }
    return paramKeyList;
  }

  Iterable<AnnotatedElement> pageParamWith(ClassElement classElement) sync* {
    for (var fieldElement in classElement.fields) {
      final annotation = pageParam.firstAnnotationOf(fieldElement);
      if (annotation != null) {
        yield AnnotatedElement(ConstantReader(annotation), fieldElement);
      }
    }
  }
}
