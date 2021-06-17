part of arcgis_maps_flutter;

@immutable
class IdentifyLayerResult {
  const IdentifyLayerResult({
    required this.layerName,
    required this.elements,
  });

  final String layerName;

  final List<GeoElement> elements;
}
