part of '../../../arcgis_maps_flutter.dart';

class IdentifyGraphicsOverlayResult {
  final Object? error;

  final List<GeoElement> geoElements;

  final String graphicsOverlayId;

  const IdentifyGraphicsOverlayResult({
    this.error,
    required this.geoElements,
    required this.graphicsOverlayId,
  });

  factory IdentifyGraphicsOverlayResult.fromJson(Map<dynamic, dynamic> json) {
    final List<dynamic> geoElementsJson = json['geoElements'];
    final List<GeoElement> geoElements = geoElementsJson
        .map((dynamic element) => GeoElement.fromJson(element))
        .toList();

    return IdentifyGraphicsOverlayResult(
      error: json['error'],
      geoElements: geoElements,
      graphicsOverlayId: json['graphicsOverlayId'],
    );
  }
}
