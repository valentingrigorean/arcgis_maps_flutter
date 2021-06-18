part of arcgis_maps_flutter;

class TiledLayer extends BaseTileLayer {
  TiledLayer._({
    required LayerId layerId,
    required String url,
    Credential? credential,
  }) : super(
          layerId: layerId,
          url: url,
          type: "TiledLayer",
          credential: credential,
        );

  factory TiledLayer.fromUrl(
    String url, {
    LayerId? layerId,
    Credential? credential,
  }) =>
      TiledLayer._(
        layerId: layerId ?? LayerId(url),
        url: url,
        credential: credential,
      );

  @override
  clone() {
    return TiledLayer._(
      layerId: layerId,
      url: url,
      credential: credential,
    );
  }
}
