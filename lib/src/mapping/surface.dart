part of arcgis_maps_flutter;

@immutable
class SurfaceId extends MapsObjectId<Surface> {
  const SurfaceId(String value) : super(value);
}

@immutable
class Surface implements MapsObject {
  const Surface({
    required this.surfaceId,
    this.elevationSources,
    this.isEnabled = true,
    this.alpha = 1,
    this.elevationExaggeration,
  }) : assert((0.0 <= alpha && alpha <= 1.0));

  final SurfaceId surfaceId;

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
  MapsObjectId get mapsId => surfaceId;

  @override
  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    void addIfPresent(String fieldName, Object? value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('SurfaceId', surfaceId.value);
    if (elevationSources != null) {
      addIfPresent(
          'elevationSources', serializeElevationSourceSet(elevationSources!));
    }
    addIfPresent('isEnabled', isEnabled);
    addIfPresent('alpha', alpha);
    addIfPresent('elevationExaggeration', elevationExaggeration);
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
