part of arcgis_maps_flutter;

enum AttributeUnit {
  unknown,
  inches,
  feet,
  yards,
  miles,
  millimeters,
  centimeters,
  meters,
  kilometers,
  nauticalMiles,
  decimalDegrees,
  seconds,
  minutes,
  hours,
  days,
}

@immutable
class CostAttribute {
  const CostAttribute._({
    this.parameterValues,
    required this.unit,
  });

  factory CostAttribute.fromJson(Map<dynamic, dynamic> json) {
    return CostAttribute._(
      parameterValues: parseAttributes(json['parameterValues']),
      unit: json.containsKey('unit')
          ? AttributeUnit.values[json['unit'] as int]
          : AttributeUnit.unknown,
    );
  }

  final Map<String, Object?>? parameterValues;

  final AttributeUnit unit;
}
