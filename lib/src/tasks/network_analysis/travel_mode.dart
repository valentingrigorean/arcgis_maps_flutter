part of arcgis_maps_flutter;

@immutable
class TravelMode {
  const TravelMode._({
    required this.attributeParameterValues,
    required this.travelModeDescription,
    required this.distanceAttributeName,
    required this.impedanceAttributeName,
    required this.name,
    required this.outputGeometryPrecision,
    required this.restrictionAttributeNames,
    required this.timeAttributeName,
    required this.type,
    required this.useHierarchy,
    required this.uTurnPolicy,
  });

  factory TravelMode.fromJson(Map<dynamic, dynamic> json) {
    return TravelMode._(
      attributeParameterValues:
          (json['attributeParameterValues'] as List<dynamic>)
              .map((e) => AttributeParameterValue.fromJson(e))
              .toList(),
      travelModeDescription: json['travelModeDescription'],
      distanceAttributeName: json['distanceAttributeName'],
      impedanceAttributeName: json['impedanceAttributeName'],
      name: json['name'],
      outputGeometryPrecision: json['outputGeometryPrecision'],
      restrictionAttributeNames:
          (json['restrictionAttributeNames'] as List<dynamic>).cast<String>(),
      timeAttributeName: json['timeAttributeName'] as String,
      type: json['type'] as String,
      useHierarchy: json['useHierarchy'] as bool,
      uTurnPolicy: UTurnPolicy.values[json['uTurnPolicy'] as int],
    );
  }

  static List<TravelMode> fromJsonList(List<dynamic> json) {
    return json
        .map((e) => TravelMode.fromJson(e as Map<dynamic, dynamic>))
        .toList();
  }

  /// Overrides to the attribute values of a cost attribute specified in
  /// [impedanceAttributeName], or to the attribute values of a restriction
  /// attribute specified in [restrictionAttributeNames].
  final List<AttributeParameterValue> attributeParameterValues;

  /// Description of this travel mode
  final String travelModeDescription;

  /// The name of the attribute that can be set as [impedanceAttributeName]
  /// to optimize routes based on distance travelled.
  final String distanceAttributeName;

  /// The name of the attribute to use as the impedance.
  /// Routes will be optimized in order to minimize this impedance along the route.
  /// To minimize time taken by the route, use [timeAttributeName].
  /// To minimize distance travelled by the route, use [distanceAttributeName].
  /// You can also use other attributes that are available in
  /// [RouteTaskInfo.costAttributes] as the impedance.
  final String impedanceAttributeName;

  /// Name of the travel mode
  final String name;

  /// The desired precision (in Meters) of the output route geometry after generalization.
  final double outputGeometryPrecision;

  /// The list of network attribute names to be used as restrictions while computing the route.
  /// Possible values are specified in [RouteTaskInfo.restrictionAttributes]
  final List<String> restrictionAttributeNames;

  /// The name of the attribute that can be set as [impedanceAttributeName]
  /// to optimize routes based on time taken.
  final String timeAttributeName;

  /// The type of travel mode this instance represents
  final String type;

  /// Specifies whether hierarchy of elements in the transportation network should be considered.
  /// https://desktop.arcgis.com/en/arcmap/latest/extensions/network-analyst/network-analysis-with-hierarchy.htm
  final bool useHierarchy;

  /// Specifies how U-Turns should be handled. U-turns can be allowed everywhere,
  /// nowhere, only at dead ends, or only at intersections and dead ends.
  /// Allowing U-turns implies the vehicle can turn around at a junction
  /// and double back on the same street.
  final UTurnPolicy uTurnPolicy;

  Object toJson() {
    return {
      'attributeParameterValues':
          attributeParameterValues.map((e) => e.toJson()).toList(),
      'travelModeDescription': travelModeDescription,
      'distanceAttributeName': distanceAttributeName,
      'impedanceAttributeName': impedanceAttributeName,
      'name': name,
      'outputGeometryPrecision': outputGeometryPrecision,
      'restrictionAttributeNames': restrictionAttributeNames,
      'timeAttributeName': timeAttributeName,
      'type': type,
      'useHierarchy': useHierarchy,
      'uTurnPolicy': uTurnPolicy.index,
    };
  }
}
