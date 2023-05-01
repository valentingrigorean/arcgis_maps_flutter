part of arcgis_maps_flutter;



@immutable
class LocatorAttribute {
  const LocatorAttribute._({
    required this.name,
    required this.displayName,
    required this.required,
  });

  static LocatorAttribute fromJson(Map<dynamic, dynamic> json) {
    return LocatorAttribute._(
      name: json['name'] as String,
      displayName: json['displayName'] as String,
      required: json['required'] as bool,
    );
  }

  /// Name of the attribute
  final String name;

  /// User-friendly name of the attribute
  final String displayName;

  /// Whether the attribute is mandatory to be specified as input.
  final bool required;

  @override
  String toString() {
    return 'LocatorAttribute{name: $name, displayName: $displayName, required: $required}';
  }
}
