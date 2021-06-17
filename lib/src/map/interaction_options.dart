part of arcgis_maps_flutter;

@immutable
class InteractionOptions {
  const InteractionOptions({
    this.isEnabled = true,
    this.isRotateEnabled = true,
    this.isPanEnabled = true,
    this.isZoomEnabled = true,
    this.isMagnifierEnabled = true,
    this.allowMagnifierToPan = true,
  });

  ///  Whether all the user interaction is enabled on the [ArcgisMapView].
  ///  Default is true
  final bool isEnabled;

  /// Whether the user can rotate the [ArcgisMapView].
  /// Default is true
  final bool isRotateEnabled;

  /// Whether the user can pan the [ArcgisMapView].
  /// If this is disabled then zooming will zoom to center instead of any anchor point.
  /// Also when diabled this will prevent the magnifier panning the [ArcgisMapView] regardless of what [allowMagnifierToPan] is set to.
  /// Default is true
  final bool isPanEnabled;

  /// Whether the user can zoom in or out on the [ArcgisMapView].
  /// Default is true
  final bool isZoomEnabled;

  /// Indicates whether a magnifier should be shown on the [ArcgisMapView] when the user performs a long press.
  /// Default is true
  final bool isMagnifierEnabled;

  /// Indicates whether the [ArcgisMapView] should be panned automatically when the magnifier gets near the edge of the [ArcgisMapView].
  /// Default is true
  final bool allowMagnifierToPan;

  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    json['isEnabled'] = isEnabled;
    json['isRotateEnabled'] = isRotateEnabled;
    json['isPanEnabled'] = isPanEnabled;
    json['isZoomEnabled'] = isZoomEnabled;
    json['isMagnifierEnabled'] = isMagnifierEnabled;
    json['allowMagnifierToPan'] = allowMagnifierToPan;
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InteractionOptions &&
          runtimeType == other.runtimeType &&
          isEnabled == other.isEnabled &&
          isRotateEnabled == other.isRotateEnabled &&
          isPanEnabled == other.isPanEnabled &&
          isZoomEnabled == other.isZoomEnabled &&
          isMagnifierEnabled == other.isMagnifierEnabled &&
          allowMagnifierToPan == other.allowMagnifierToPan;

  @override
  int get hashCode =>
      isEnabled.hashCode ^
      isRotateEnabled.hashCode ^
      isPanEnabled.hashCode ^
      isZoomEnabled.hashCode ^
      isMagnifierEnabled.hashCode ^
      allowMagnifierToPan.hashCode;
}
