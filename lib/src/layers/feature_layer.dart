part of arcgis_maps_flutter;

@immutable
class FeatureLayer extends BaseTileLayer {
  const FeatureLayer._({
    required LayerId layerId,
    required String url,
    Credential? credential,
  }) : super(
          layerId: layerId,
          url: url,
          type: 'FeatureLayer',
          credential: credential,
        );

  factory FeatureLayer.fromUrl(
    String url, {
    LayerId? layerId,
    Credential? credential,
  }) =>
      FeatureLayer._(
        layerId: layerId ?? LayerId(url),
        url: url,
        credential: credential,
      );

  @override
  clone() {
    return FeatureLayer._(layerId: layerId, url: url);
  }
}