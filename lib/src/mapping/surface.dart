part of '../../arcgis_maps_flutter.dart';

@immutable
class Surface implements MapsObject {
  const Surface({
    required this.surfaceId,
    this.elevationSources,
    this.isEnabled = true,
    this.alpha = 1,
    this.elevationExaggeration,
  }) : assert((0.0 <= alpha && alpha <= 1.0));

  final String surfaceId;

  final Set<ElevationSource>? elevationSources;

  final bool isEnabled;

  /// The opacity of the surface, between 0.0 and 1.0 inclusive.
  ///
  /// 0.0 means fully transparent, 1.0 means fully opaque.
  final double alpha;

  final double? elevationExaggeration;

  Surface copyWith({
    Set<ElevationSource>? elevationSources,
    bool? isEnabled,
    double? alpha,
  }) {
    return Surface(
      surfaceId: surfaceId,
      elevationSources: elevationSources ?? this.elevationSources,
      isEnabled: isEnabled ?? this.isEnabled,
      alpha: alpha ?? this.alpha,
    );
  }

  @override
  clone() => copyWith();

  @override
  String get mapsId => surfaceId;

  @override
  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    json.addIfNonNull('SurfaceId', surfaceId);
    if (elevationSources != null) {
      json.addIfNonNull(
          'elevationSources', serializeElevationSourceSet(elevationSources!));
    }
    json.addIfNonNull('isEnabled', isEnabled);
    json.addIfNonNull('alpha', alpha);
    json.addIfNonNull('elevationExaggeration', elevationExaggeration);
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Surface &&
          runtimeType == other.runtimeType &&
          surfaceId == other.surfaceId &&
          elevationSources == other.elevationSources &&
          isEnabled == other.isEnabled &&
          alpha == other.alpha &&
          elevationExaggeration == other.elevationExaggeration;

  @override
  int get hashCode => surfaceId.hashCode;
}
