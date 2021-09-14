part of arcgis_maps_flutter;

enum ImageFormat {
  png,
  png8,
  png24,
  png32,
  jpg,
  mixed,
  lerc,
  unknown,
}

@immutable
class TileInfo {
  const TileInfo({
    required this.dpi,
    required this.imageFormat,
    required this.levelOfDetails,
    required this.origin,
    required this.spatialReference,
    required this.tileHeight,
    required this.tileWidth,
  });


  /// The Dots-Per-Inch (DPI) resolution of tiled images.
  final int dpi;
  final ImageFormat imageFormat;
  final List<LevelOfDetail> levelOfDetails;
  /// The tiling scheme origin which specifies the starting location of Row 0 and Column 0.
  final Point origin;

  final SpatialReference spatialReference;

  /// Height (in points) of an individual tile image
  final int tileHeight;
  /// Width (in points) of an individual tile image
  final int tileWidth;

  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    json['dpi'] = dpi;
    json['imageFormat'] = imageFormat.index;
    json['levelOfDetails'] = _levelOfDetailsToJson();
    json['origin'] = origin.toJson();
    json['spatialReference'] = spatialReference.toJson();
    json['tileHeight'] = tileHeight;
    json['tileWidth'] = tileWidth;

    return json;
  }

  Object _levelOfDetailsToJson() {
    final List<Object> result = <Object>[];
    for (final LevelOfDetail levelOfDetail in levelOfDetails) {
      result.add(levelOfDetail.toJson());
    }
    return result;
  }
}
