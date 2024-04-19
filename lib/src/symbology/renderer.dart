part of '../../arcgis_maps_flutter.dart';

enum RotationType {
  geographic,
  arithmetic,
}

abstract class Renderer {
  const Renderer({
    this.rotationExpression,
    this.rotationType,
  });

  final String? rotationExpression;
  final RotationType? rotationType;

  String get type;

  Map<String, Object?> toJson() {
    final Map<String, Object?> json = <String, Object?>{};
    json['type'] = type;
    json.addIfNonNull('rotationExpression', rotationExpression);
    json.addIfNonNull('rotationType', rotationType?.name);
    return json;
  }
}
