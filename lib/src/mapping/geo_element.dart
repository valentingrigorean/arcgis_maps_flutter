part of arcgis_maps_flutter;

@immutable
abstract class GeoElement {
  /// Attribute types supported are null, String, Date, and Numbers.
  /// Other attribute types will be ignored.
  Map<String, Object?> get attributes;

  Geometry? get geometry;

  factory GeoElement.fromJson(Map<dynamic, dynamic> json) {
    final Map<String, Object?> attributes = {};
    final Map<dynamic, dynamic> attributesData = json['attributes'];
    attributesData.forEach((key, value) {
      attributes[key] = fromNativeField(value);
    });

    Geometry? geometry;
    try {
      geometry = Geometry.fromJson(toSafeMapNullable(json['geometry']));
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
    }

    return _GeoElementImpl(attributes, geometry);
  }
}

class _GeoElementImpl implements GeoElement {
  final Map<String, Object?> _attributes;
  final Geometry? _geometry;

  _GeoElementImpl(this._attributes, this._geometry);

  @override
  Map<String, Object?> get attributes => _attributes;

  @override
  Geometry? get geometry => _geometry;
}
