part of arcgis_maps_flutter;

@immutable
class ServiceImageTiledLayer extends BaseTileLayer {
  const ServiceImageTiledLayer({
    required LayerId layerId,

    /// Defines the structure to create the URLs for the tiles. `{s}` means one of
    /// the available subdomains (can be omitted) `{z}` zoom level `{x}` and `{y}`
    ///
    /// Example:
    ///
    /// https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png
    ///
    /// Is translated to this:
    ///
    /// https://a.tile.openstreetmap.org/12/2177/1259.png
    required String urlTemplate,
    required this.tileInfo,
    required this.fullExtent,
    this.subdomains = const [],
    this.additionalOptions = const <String, String>{},
    bool isVisible = true,
    double opacity = 1.0,
  }) : super.fromUrl(
          type: 'ServiceImageTiledLayer',
          url: urlTemplate,
          layerId: layerId,
          isVisible: isVisible,
          opacity: opacity,
        );

  final TileInfo tileInfo;
  final Envelope fullExtent;

  final List<String> subdomains;
  final Map<String, String> additionalOptions;

  @override
  Layer clone() {
    return ServiceImageTiledLayer(
      layerId: layerId,
      urlTemplate: url!,
      tileInfo: tileInfo,
      fullExtent: fullExtent,
      subdomains: subdomains,
      isVisible: isVisible,
      opacity: opacity,
    );
  }

  @override
  Map<String, Object> toJson() {
    var json = super.toJson();
    json['tileInfo'] = tileInfo.toJson();
    json['fullExtent'] = fullExtent.toJson();
    json['subdomains'] = subdomains;
    json['additionalOptions'] = additionalOptions;
    return json;
  }

  @override
  List<Object?> get props => super.props
    ..addAll([
      tileInfo,
      fullExtent,
      subdomains,
      additionalOptions,
    ]);
}
