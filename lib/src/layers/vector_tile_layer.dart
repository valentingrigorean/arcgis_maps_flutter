part of '../../arcgis_maps_flutter.dart';

@immutable
class VectorTileLayer extends BaseTileLayer {
   VectorTileLayer.fromUrl(String url,{
    LayerId? layerId,
    super.isVisible,
    super.opacity,
  }) : super.fromUrl(
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
