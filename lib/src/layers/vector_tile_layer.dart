part of arcgis_maps_flutter;

@immutable
class VectorTileLayer extends BaseTileLayer {
   VectorTileLayer.fromUrl(String url,{
    LayerId? layerId,
    Credential? credential,
    bool isVisible = true,
    double opacity = 1,
  }) : super.fromUrl(
          isVisible: isVisible,
          opacity: opacity,
          layerId: layerId ?? LayerId(url),
          url: url,
          type: 'VectorTileLayer',
          credential: credential,
        );


  @override
  clone() {
    return copyWith();
  }

  VectorTileLayer copyWith({
    bool? isVisibleParam,
    double? opacityParam,
  }) {
    return VectorTileLayer.fromUrl(
      url!,
      layerId: layerId,
      credential: credential,
      isVisible: isVisibleParam ?? isVisible,
      opacity: opacityParam ?? opacity,
    );
  }
}
