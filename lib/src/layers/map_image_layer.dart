part of arcgis_maps_flutter;

@immutable
class MapImageLayer extends BaseTileLayer {
  MapImageLayer.fromUrl(
    String url, {
    LayerId? layerId,
    bool isVisible = true,
    double opacity = 1,
  }) : super.fromUrl(
          isVisible: isVisible,
          opacity: opacity,
          layerId: layerId ?? LayerId(url),
          url: url,
          type: 'MapImageLayer',
        );

  @override
  clone() {
    return copyWith();
  }

  MapImageLayer copyWith({
    bool? isVisibleParam,
    double? opacityParam,
  }) {
    return MapImageLayer.fromUrl(
      url!,
      layerId: layerId,
      isVisible: isVisibleParam ?? isVisible,
      opacity: opacityParam ?? opacity,
    );
  }
}
