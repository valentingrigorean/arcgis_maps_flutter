part of arcgis_maps_flutter;

@immutable
class VectorTileLayer extends BaseTileLayer {
  const VectorTileLayer._({
    required LayerId layerId,
    required String url,
    Credential? credential,
  }) : super(
          layerId: layerId,
          url: url,
          type: "VectorTileLayer",
          credential: credential,
        );

  factory VectorTileLayer.fromUrl(
    String url, {
    LayerId? layerId,
    Credential? credential,
  }) =>
      VectorTileLayer._(
        layerId: layerId ?? LayerId(url),
        url: url,
        credential: credential,
      );

  @override
  clone() {
    return VectorTileLayer._(
      layerId: layerId,
      url: url,
      credential: credential,
    );
  }
}
