part of arcgis_maps_flutter;

@immutable
class WmsLayerStyle extends Equatable {
  const WmsLayerStyle({
    required this.name,
    required this.title,
    required this.description,
    this.legendUrl,
  });

  final String name;
  final String title;

  final String description;

  final WmsLegendUrl? legendUrl;

  @override
  List<Object?> get props => [];
}

@immutable
class WmsLegendUrl extends Equatable {
  const WmsLegendUrl({
    required this.url,
    required this.imageFormat,
    this.width = 0,
    this.height = 0,
  });

  final String url;

  final ImageFormat imageFormat;

  final int width;
  final int height;

  @override
  List<Object?> get props => [
        url,
        imageFormat,
        width,
        height,
      ];
}
