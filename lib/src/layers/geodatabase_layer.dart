part of arcgis_maps_flutter;

@immutable
class GeodatabaseLayer extends Layer {
  const GeodatabaseLayer({
    required LayerId layerId,
    required this.path,
    this.featureLayersIds,
  }) : super(
          layerId: layerId,
          isVisible: true,
          opacity: 1,
        );

  final String path;

  /// A list of layers to be included
  /// [featureLayersIds] is null will include all layers in the geodatabase.
  final List<int>? featureLayersIds;

  @override
  GeodatabaseLayer clone() {
    return GeodatabaseLayer(
      layerId: layerId,
      path: path,
      featureLayersIds: featureLayersIds,
    );
  }

  @override
  Map<String, Object> toJson() {
    final json = super.toJson();
    json["layerType"] = "GeodatabaseLayer";
    json['url'] = path;
    if (featureLayersIds != null) {
      json['featureLayersIds'] = featureLayersIds!;
    }
    return json;
  }
}
