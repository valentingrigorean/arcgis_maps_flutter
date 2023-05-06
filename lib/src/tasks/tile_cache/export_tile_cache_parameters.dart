part of arcgis_maps_flutter;

class ExportTileCacheParameters {
  const ExportTileCacheParameters({
    this.areaOfInterest,
    this.compressionQuality = 0.75,
    this.levelIds = const [],
  });

  factory ExportTileCacheParameters.fromJson(Map<dynamic, dynamic> json) {
    final compressionQuality = json['compressionQuality'] as double;
    return ExportTileCacheParameters(
      areaOfInterest: json['areaOfInterest'] == null
          ? null
          : Geometry.fromJson(json['areaOfInterest']),
      compressionQuality:  compressionQuality,
      levelIds: (json['levelIds'] as List<dynamic>?)?.cast<int>().toList() ??
          const [],
    );
  }

  /// An [Polygon] or [Envelope] geometry that defines the geographic area
  /// for which tiles are needed. Where an @c AGSPolygon is supplied,
  /// tiles will be filtered according to the polygon geometry, which can help
  /// reduce the size of the resulting tile package. Note that the filtered set
  /// of tiles may vary, depending on the underlying service.
  /// [Point] and [Polyline] geometries are not supported.
  /// If this is not specified, the full extent of the service will be used.
  final Geometry? areaOfInterest;

  /// The quality that must be maintained while compressing the tiles.
  /// A value in the range 0-100. Defaults to -1 which preserves the compression
  /// quality specified on the service.
  ///
  /// The value cannot be greater than the default compression quality already
  /// set on the service. For example, if the default value is 75, the value
  /// provided must be between 0 and 75. A value greater than 75 in this example
  /// will attempt to up sample an already compressed tile and will
  /// further degrade the quality of tiles.
  ///
  /// Providing a value smaller than the default set on the service will result
  /// in greater compression being applied to the tiles to reduce size,
  /// but may also degrade quality.
  final double compressionQuality;

  /// The levels of detail that should be included in the tile cache.
  /// The values should correspond to Level IDs in the service's tiling scheme.
  /// You can specify consecutive levels (for example 1,2,3,4,5) or skip some
  /// levels (for example for the ranges 1-3 and 7-9 you would specify 1,2,3,7,8,9).
  final List<int> levelIds;

  ExportTileCacheParameters copyWith({
    Geometry? areaOfInterest,
    double? compressionQuality,
    List<int>? levelIds,
  }) {
    return ExportTileCacheParameters(
      areaOfInterest: areaOfInterest ?? this.areaOfInterest,
      compressionQuality: compressionQuality ?? this.compressionQuality,
      levelIds: levelIds ?? this.levelIds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (areaOfInterest != null) 'areaOfInterest': areaOfInterest!.toJson(),
      'compressionQuality': compressionQuality,
      'levelIds': levelIds,
    };
  }
}
