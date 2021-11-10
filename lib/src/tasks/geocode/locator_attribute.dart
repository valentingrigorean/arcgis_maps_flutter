part of arcgis_maps_flutter;

enum LocatorAttributeType {
  integer,
  double,
  string,
  boolean,
  unknown,
}

@immutable
class LocatorAttribute {
  const LocatorAttribute({
    required this.name,
    required this.displayName,
    required this.required,
    this.type = LocatorAttributeType.unknown,
  });

  factory LocatorAttribute.fromJson(Map<dynamic, dynamic> json) {
    return LocatorAttribute(
      name: json['name'] as String,
      displayName: json['displayName'] as String,
      required: json['required'] as bool,
      type: json.containsKey('type')
          ? LocatorAttributeType.values[json['type'] as int]
          : LocatorAttributeType.unknown,
    );
  }

  /// Name of the attribute
  final String name;

  /// User-friendly name of the attribute
  final String displayName;

  /// Whether the attribute is mandatory to be specified as input.
  final bool required;

  final LocatorAttributeType type;

  @override
  String toString() {
    return 'LocatorAttribute{name: $name, displayName: $displayName, required: $required, type: $type}';
  }
}
