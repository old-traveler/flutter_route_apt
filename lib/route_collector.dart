import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:flutter_route_apt/annotation/route_page.dart';
import 'package:source_gen/source_gen.dart';

import 'RouteInfo.dart';

const TypeChecker pageRoute = TypeChecker.fromRuntime(RoutePage);
const TypeChecker pageParam = TypeChecker.fromRuntime(PageParam);

Set<RouteInfo> routeInfoList = Set();
Map<String, Set<RouteInfo>> routeRecord = {};
/// watch模式下是增量编译，并不会收集到原有的Route信息
/// 所以会导致覆盖掉原有的数据，暂时无法使用
bool rewrite = false;

class RouteCollector extends Generator {
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    // dart文件路径
    final inputId = buildStep.inputId.toString();
    Set<RouteInfo> stepRoute = Set();
    for (var annotatedElement in library.annotatedWith(pageRoute)) {
      final className = annotatedElement.element.displayName;
      final path = buildStep.inputId.path;
      final package = buildStep.inputId.package;
      final import = "package:$package/${path.replaceFirst('lib/', '')}";
      final routeName =
          annotatedElement.annotation.peek('scheme')?.stringValue ?? className;
      stepRoute.add(RouteInfo(import, routeName, className,
          findParamFromClassElement(annotatedElement.element)));
      rewrite = true;
    }
    // 如果上一次的记录存在则清除上次记录
    if (routeRecord[inputId]?.isNotEmpty == true) {
      rewrite = true;
      routeInfoList.removeAll(routeRecord[inputId]);
    }
    routeInfoList.addAll(stepRoute);
    routeRecord[inputId] = stepRoute;
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
