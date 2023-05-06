part of arcgis_maps_flutter;

enum ImageFormat {
  png(0),
  png8(1),
  png24(2),
  png32(3),
  jpg(4),

  /// Mixed (JPEG in the center of the cache and PNG 32 on the edge of the cache).
  mixed(5),

  /// Limited Error Raster Compression.
  lerc(6),
  unknown(-1);

  const ImageFormat(this.value);

  factory ImageFormat.fromValue(int value) {
    return ImageFormat.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ImageFormat.unknown,
    );
  }

  final int value;
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

  factory TileInfo.fromJson(Map<dynamic, dynamic> json) {
    return TileInfo(
      dpi: json['dpi'] as int,
      imageFormat: ImageFormat.fromValue(json['imageFormat'] as int),
      levelOfDetails: (json['levelOfDetails'] as List<dynamic>)
          .map((e) => LevelOfDetail.fromJson(e))
          .toList(),
      origin: Point.fromJson(json['origin'])!,
      spatialReference: SpatialReference.fromJson(json['spatialReference'])!,
      tileHeight: json['tileHeight'] as int,
      tileWidth: json['tileWidth'] as int,
    );
  }

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
    json['imageFormat'] = imageFormat.value;
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
