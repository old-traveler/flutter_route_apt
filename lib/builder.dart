library flutter_route_apt.builder;

import 'package:build/build.dart';
import 'package:flutter_route_apt/route_collector.dart';
import 'package:flutter_route_apt/route_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder routeBuilder(BuilderOptions options) =>
    LibraryBuilder(RouteGenerator(), generatedExtension: ".route.dart");

Builder routeCollector(BuilderOptions options) =>
    LibraryBuilder(RouteCollector(), generatedExtension: ".collector.dart");

Builder routeCollectorAllPackages(BuilderOptions options) =>
    LibraryBuilder(RouteCollector(),
        generatedExtension: ".collector_all_packages.dart");
