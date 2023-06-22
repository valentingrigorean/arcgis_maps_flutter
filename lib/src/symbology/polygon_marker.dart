part of arcgis_maps_flutter;

/// Uniquely identifies a [PolygonMarker] among [ArcgisMapView] polygons.
///
/// This does not have to be globally unique, only unique among the list.
@immutable
class PolygonId extends SymbolId<PolygonMarker> {
  /// Creates an immutable identifier for a [PolygonMarker].
  const PolygonId(String value) : super(value);
}

/// Draws a polygon through geographical locations on the map.
@immutable
class PolygonMarker extends Symbol {
  /// Creates an immutable representation of a polygon through geographical locations on the map.
  const PolygonMarker({
    required this.polygonId,
    this.consumeTapEvents = false,
    this.fillColor = Colors.black,
    this.points = const <Point>[],
    this.spatialReference,
    this.strokeColor = Colors.black,
    this.strokeWidth = 10,
    this.strokeStyle = SimpleLineSymbolStyle.solid,
    this.visible = true,
    this.zIndex = 0,
    this.onTap,
    this.selectedColor,
    this.visibilityFilter,
  }) : super(symbolId: polygonId);

  /// Uniquely identifies a [PolygonMarker].
  final PolygonId polygonId;

  /// True if the [PolygonMarker] consumes tap events.
  ///
  /// If this is false, [onTap] callback will not be triggered.
  final bool consumeTapEvents;

  /// Fill color in ARGB format, the same format used by Color. The default value is black (0xff000000).
  final Color fillColor;

  /// The vertices of the polygon to be drawn.
  final List<Point> points;

  final SpatialReference? spatialReference;

  /// True if the marker is visible.
  final bool visible;

  /// Line color in ARGB format, the same format used by Color. The default value is black (0xff000000).
  final Color strokeColor;

  /// Width of the polygon, used to define the width of the line to be drawn.
  ///
  /// The width is constant and independent of the camera's zoom level.
  /// The default value is 10.
  final double strokeWidth;

  /// Style of the stroke.
  final SimpleLineSymbolStyle strokeStyle;

  /// The z-index of the polygon, used to determine relative drawing order of
  /// map overlays.
  ///
  /// Overlays are drawn in order of z-index, so that lower values means drawn
  /// earlier, and thus appearing to be closer to the surface of the Earth.
  final int zIndex;

  /// Callbacks to receive tap events for polygon placed on this map.
  final VoidCallback? onTap;

  final Color? selectedColor;

  final SymbolVisibilityFilter? visibilityFilter;

  /// Creates a new [PolygonMarker] object whose values are the same as this instance,
  /// unless overwritten by the specified parameters.
  PolygonMarker copyWith({
    bool? consumeTapEventsParam,
    Color? fillColorParam,
    List<Point>? pointsParam,
    Color? strokeColorParam,
    double? strokeWidthParam,
    SimpleLineSymbolStyle? strokeStyleParam,
    bool? visibleParam,
    int? zIndexParam,
    VoidCallback? onTapParam,
    Color? selectedColorParam,
    SpatialReference? spatialReferenceParam,
    SymbolVisibilityFilter? visibilityFilterParam,
  }) {
    return PolygonMarker(
      polygonId: polygonId,
      consumeTapEvents: consumeTapEventsParam ?? consumeTapEvents,
      fillColor: fillColorParam ?? fillColor,
      points: pointsParam ?? points,
      strokeColor: strokeColorParam ?? strokeColor,
      strokeWidth: strokeWidthParam ?? strokeWidth,
      strokeStyle: strokeStyleParam ?? strokeStyle,
      visible: visibleParam ?? visible,
      onTap: onTapParam ?? onTap,
      zIndex: zIndexParam ?? zIndex,
      selectedColor: selectedColorParam ?? selectedColor,
      spatialReference: spatialReferenceParam ?? spatialReference,
      visibilityFilter: visibilityFilterParam ?? visibilityFilter,
    );
  }

  @override
  clone() {
    return copyWith(pointsParam: List<Point>.of(points));
  }

  @override
  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    void addIfPresent(String fieldName, Object? value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('polygonId', polygonId.value);
    addIfPresent('consumeTapEvents', consumeTapEvents);
    addIfPresent('fillColor', fillColor.value);
    addIfPresent('strokeColor', strokeColor.value);
    addIfPresent('strokeWidth', strokeWidth);
    addIfPresent('strokeStyle', strokeStyle.value);
    addIfPresent('visible', visible);
    addIfPresent('zIndex', zIndex);
    addIfPresent('selectedColor', selectedColor?.value);
    addIfPresent('visibilityFilter', visibilityFilter?.toJson());
    addIfPresent('spatialReference', spatialReference?.toJson());

    json['points'] = _pointsToJson();

    return json;
  }

  @override
  int get hashCode => polygonId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PolygonMarker &&
          runtimeType == other.runtimeType &&
          polygonId == other.polygonId &&
          consumeTapEvents == other.consumeTapEvents &&
          fillColor == other.fillColor &&
          points == other.points &&
          visible == other.visible &&
          strokeColor == other.strokeColor &&
          strokeWidth == other.strokeWidth &&
          strokeStyle == other.strokeStyle &&
          zIndex == other.zIndex &&
          selectedColor == other.selectedColor &&
          visibilityFilter == other.visibilityFilter;

  Object _pointsToJson() {
    final List<Object> result = <Object>[];
    for (final point in points) {
      result.add(point.toJson());
    }
    return result;
  }
}
