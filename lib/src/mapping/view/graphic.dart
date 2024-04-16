part of '../../../arcgis_maps_flutter.dart';

class Graphic extends GeoElement  {
  const Graphic({
    required this.graphicId,
    this.attributes = const {},
    this.geometry,
    this.symbol,
    this.zIndex,
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

  final int? zIndex;

  @override
  String get type => 'Graphic';

  Map<String, Object> toJson() {
    final Map<String, Object> json = <String, Object>{};
    json['graphicId'] = graphicId;
    json['type'] = type;
    json.addIfNonNull('geometry', geometry?.toJson());
    json.addIfNonNull('attributes', serializeAttributes(attributes));
    json.addIfNonNull('symbol', symbol?.toJson());
    json.addIfNonNull('zIndex', zIndex);
    return json;
  }
}
