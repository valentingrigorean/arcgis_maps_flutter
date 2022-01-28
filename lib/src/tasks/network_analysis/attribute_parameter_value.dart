part of arcgis_maps_flutter;

@immutable
class AttributeParameterValue {
  const AttributeParameterValue._({
    required this.attributeName,
    required this.parameterName,
    this.parameterValue,
  });

  static AttributeParameterValue fromJson(Map<dynamic, dynamic> json) {
    return AttributeParameterValue._(
      attributeName: json['attributeName'] as String,
      parameterName: json['parameterName'] as String,
      parameterValue: fromNativeField(json['parameterValue']),
    );
  }

  final String attributeName;
  final String parameterName;

  final Object? parameterValue;
}
