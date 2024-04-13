part of '../../../arcgis_maps_flutter.dart';

@immutable
class CostAttribute {
  const CostAttribute._({
    this.parameterValues,
    required this.unit,
  });

  factory CostAttribute.fromJson(Map<dynamic, dynamic> json) {
    return CostAttribute._(
      parameterValues: deserializeAttributes(json['parameterValues']),
      unit: json.containsKey('unit')
          ? AttributeUnit.fromValue(json['unit'] as int)
          : AttributeUnit.unknown,
    );
  }

  final Map<String, Object?>? parameterValues;

  final AttributeUnit unit;

  @override
  String toString(){
    return 'CostAttribute{parameterValues: $parameterValues, unit: $unit}';
  }
}
