part of arcgis_maps_flutter;

class IdentifyGraphicsOverlayResult {
  const IdentifyGraphicsOverlayResult({
    required this.markers,
    required this.polygons,
    required this.polylines,
  });

  final List<Marker> markers;

  final List<PolygonMarker> polygons;

  final List<PolylineMarker> polylines;
}