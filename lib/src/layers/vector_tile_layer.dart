part of arcgis_maps_flutter;

@immutable
class VectorTileLayer extends BaseTileLayer {
   VectorTileLayer.fromUrl(String url,{
    LayerId? layerId,
    bool isVisible = true,
    double opacity = 1,
  }) : super.fromUrl(
          isVisible: isVisible,
          opacity: opacity,
          layerId: layerId ?? LayerId(url),
          url: url,
          type: 'VectorTileLayer',
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
      isVisible: isVisibleParam ?? isVisible,
      opacity: opacityParam ?? opacity,
    );
  }
}
