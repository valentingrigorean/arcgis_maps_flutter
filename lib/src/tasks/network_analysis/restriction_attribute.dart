part of arcgis_maps_flutter;

@immutable
class RestrictionAttribute {
  const RestrictionAttribute._({
    this.parameterValues,
    required this.restrictionUsageParameterName,
  });

  factory RestrictionAttribute.fromJson(Map<String, dynamic> json) {
    return RestrictionAttribute._(
      parameterValues: parseAttributes(json['parameterValues']),
      restrictionUsageParameterName: json['restrictionUsageParameterName'],
    );
  }

  final Map<String, Object?>? parameterValues;
  final String restrictionUsageParameterName;
}
