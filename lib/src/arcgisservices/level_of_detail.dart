part of arcgis_maps_flutter;

@immutable
class LevelOfDetail {
  const LevelOfDetail({
    required this.level,
    required this.resolution,
    required this.scale,
  });

  final int level;
  final double resolution;
  final double scale;

  Object toJson() {
    return [
      level,
      resolution,
      scale
    ];
  }

  @override
  String toString() {
    return 'LevelOfDetail{level: $level, resolution: $resolution, scale: $scale}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelOfDetail &&
          runtimeType == other.runtimeType &&
          level == other.level &&
          resolution == other.resolution &&
          scale == other.scale;

  @override
  int get hashCode => level.hashCode ^ resolution.hashCode ^ scale.hashCode;
}
