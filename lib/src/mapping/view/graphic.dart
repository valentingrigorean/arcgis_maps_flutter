part of '../../../arcgis_maps_flutter.dart';

class Graphic extends GeoElement {
  const Graphic({
    this.attributes = const {},
    this.geometry,
    this.symbol,
  });

  /// The geometry of the graphic.
  @override
  final Geometry? geometry;

  /// The attributes of the graphic.
  @override
  final Map<String, Object?> attributes;

  /// The symbol of the graphic.
  final Symbol? symbol;

  @override
  String get type => 'Graphic';

  Map<String, Object> toJson() {
    final Map<String, Object> json = <String, Object>{};
    json.addIfNonNull('geometry', geometry?.toJson());
    json.addIfNonNull('attributes', serializeAttributes(attributes));
    json.addIfNonNull('symbol', symbol?.toJson());
    json['type'] = type;
    return json;
  }
}
