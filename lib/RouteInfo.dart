class RouteInfo {
  final String import;
  final String name;
  final String className;
  final List<ParamInfo> params;

  RouteInfo(this.import, this.name, this.className, this.params);

  @override
  String toString() {
    return '\nimport: $import\nname: $name\nclassName: $className\nparams: $params';
  }

  @override
  bool operator ==(other) {
    if (other is! RouteInfo) {
      return false;
    }
    return this.name == other.name;
  }

  @override
  int get hashCode => name.hashCode;
}

class ParamInfo {
  final String paramName;
  final String mapKey;

  ParamInfo(this.paramName, this.mapKey);
}
