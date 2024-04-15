part of '../../../arcgis_maps_flutter.dart';

class Graphic extends GeoElement implements MapsObject<Graphic> {
  const Graphic({
    required this.graphicId,
    this.attributes = const {},
    this.geometry,
    this.symbol,
  });

  final String graphicId;

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

  @override
  String get mapsId => graphicId;

  @override
  Graphic clone() {
    return this;
  }

  @override
  Map<String, Object> toJson() {
    final Map<String, Object> json = <String, Object>{};
    json['graphicId'] = graphicId;
    json['type'] = type;
    json.addIfNonNull('geometry', geometry?.toJson());
    json.addIfNonNull('attributes', serializeAttributes(attributes));
    json.addIfNonNull('symbol', symbol?.toJson());
    return json;
  }
}
