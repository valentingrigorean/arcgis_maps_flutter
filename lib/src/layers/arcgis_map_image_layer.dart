part of arcgis_maps_flutter;

class ArcGISMapImageLayer extends BaseTileLayer {
  const ArcGISMapImageLayer._({
    required LayerId layerId,
    required String url,
    Credential? credential,
  }) : super(
          layerId: layerId,
          url: url,
          type: "ArcGISMapImageLayer",
          credential: credential,
        );

  factory ArcGISMapImageLayer.fromUrl(
    String url, {
    LayerId? layerId,
    Credential? credential,
  }) =>
      ArcGISMapImageLayer._(
        layerId: layerId ?? LayerId(url),
        url: url,
        credential: credential,
      );

  @override
  clone() {
    return ArcGISMapImageLayer._(
      layerId: layerId,
      url: url,
      credential: credential,
    );
  }
}
