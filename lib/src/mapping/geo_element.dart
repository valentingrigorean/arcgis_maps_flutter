part of '../../arcgis_maps_flutter.dart';

@immutable
abstract class GeoElement {
  const GeoElement();

  String get type;

  Map<String, Object?> get attributes;

  Geometry? get geometry;

  factory GeoElement.fromJson(Map<dynamic, dynamic> json) {
    final Map<String, Object?> attributes =
        deserializeAttributes(json['attributes']) ?? {};
    Geometry? geometry;

    geometry = Geometry.fromJson(json['geometry']);

    if (json.containsKey('type')) {
      switch (json['type']) {
        case 'Graphic':
          return Graphic(
            graphicId: json['graphicId'] ?? '',
            attributes: attributes,
            geometry: geometry,
            symbol: Symbol.fromJson(
              json['symbol'],
            ),
          );
        default:
          break;
      }
    }

    return _GeoElementImpl(attributes, geometry);
  }

  GeoElement copyWith({
    Map<String, Object?>? attributesParam,
    Geometry? geometryParam,
  }) {
    return _GeoElementImpl(
      attributesParam ?? attributes,
      geometryParam ?? geometry,
    );
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

  @override
  GeoElement copyWith({
    Map<String, Object?>? attributesParam,
    Geometry? geometryParam,
  }) {
    return _GeoElementImpl(
      attributesParam ?? _attributes,
      geometryParam ?? _geometry,
    );
  }

  @override
  String get type => 'GeoElement';
}
