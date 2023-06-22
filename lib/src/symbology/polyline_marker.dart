part of arcgis_maps_flutter;

enum SimpleLineSymbolStyle {
  dash(0),
  dashDot(1),
  dashDotDot(2),
  dot(3),
  longDash(4),
  longDashDot(5),
  none(6),
  shortDash(7),
  shortDashDotDot(8),
  shortDashDot(9),
  shortDot(10),
  solid(11),
  ;

  const SimpleLineSymbolStyle(this.value);

  factory SimpleLineSymbolStyle.fromValue(int value) {
    return SimpleLineSymbolStyle.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SimpleLineSymbolStyle.none,
    );
  }

  final int value;
}

/// Uniquely identifies a [PolylineMarker] among [ArcgisMapView] polylines.
///
/// This does not have to be globally unique, only unique among the list.
@immutable
class PolylineId extends SymbolId<PolylineMarker> {
  /// Creates an immutable object representing a [PolylineId] among [ArcgisMapView] polylines.
  ///
  /// An [AssertionError] will be thrown if [value] is null.
  const PolylineId(String value) : super(value);
}

@immutable
class PolylineMarker extends Symbol {
  /// Creates an immutable object representing a line drawn through geographical locations on the map.
  const PolylineMarker({
    required this.polylineId,
    this.consumeTapEvents = false,
    this.color = Colors.black,
    this.style = SimpleLineSymbolStyle.solid,
    this.spatialReference,
    this.points = const <Point>[],
    this.visible = true,
    this.width = 10,
    this.zIndex = 0,
    this.antialias = true,
    this.onTap,
    this.selectedColor,
    this.visibilityFilter,
  }) : super(symbolId: polylineId);

  /// Uniquely identifies a [PolylineMarker].
  final PolylineId polylineId;

  /// True if the [PolylineMarker] consumes tap events.
  ///
  /// If this is false, [onTap] callback will not be triggered.
  final bool consumeTapEvents;

  /// Line segment color in ARGB format, the same format used by Color. The default value is black (0xff000000).
  final Color color;

  /// Style of the line
  final SimpleLineSymbolStyle style;


  final SpatialReference? spatialReference;

  /// The vertices of the polygon to be drawn.
  final List<Point> points;

  /// True if the marker is visible.
  final bool visible;

  /// Width of the polyline, used to define the width of the line segment to be drawn.
  ///
  /// The width is constant and independent of the camera's zoom level.
  /// The default value is 10.
  final int width;

  /// The z-index of the polyline, used to determine relative drawing order of
  /// map overlays.
  ///
  /// Overlays are drawn in order of z-index, so that lower values means drawn
  /// earlier, and thus appearing to be closer to the surface of the Earth.
  final int zIndex;

  ///  Whether the line should be anti-aliased. Defaults to true.
  final bool antialias;

  /// Callbacks to receive tap events for polyline placed on this map.
  final VoidCallback? onTap;

  final Color? selectedColor;

  final SymbolVisibilityFilter? visibilityFilter;

  /// Creates a new [PolylineMarker] object whose values are the same as this instance,
  /// unless overwritten by the specified parameters.
  PolylineMarker copyWith({
    bool? consumeTapEventsParam,
    Color? colorParam,
    SimpleLineSymbolStyle? styleParam,
    SpatialReference? spatialReferenceParam,
    List<Point>? pointsParam,
    bool? visibleParam,
    int? widthParam,
    int? zIndexParam,
    bool? antialiasParam,
    VoidCallback? onTapParam,
    Color? selectedColorParam,
    SymbolVisibilityFilter? visibilityFilterParam,
  }) {
    return PolylineMarker(
      polylineId: polylineId,
      color: colorParam ?? color,
      consumeTapEvents: consumeTapEventsParam ?? consumeTapEvents,
      style: styleParam ?? style,
      spatialReference: spatialReferenceParam ?? spatialReference,
      points: pointsParam ?? points,
      visible: visibleParam ?? visible,
      width: widthParam ?? width,
      zIndex: zIndexParam ?? zIndex,
      antialias: antialiasParam ?? antialias,
      onTap: onTapParam ?? onTap,
      selectedColor: selectedColorParam ?? selectedColor,
      visibilityFilter: visibilityFilterParam ?? visibilityFilter,
    );
  }

  @override
  clone() {
    return copyWith(
      pointsParam: List<Point>.of(points),
    );
  }

  @override
  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    void addIfPresent(String fieldName, Object? value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('polylineId', polylineId.value);
    addIfPresent('consumeTapEvents', consumeTapEvents);
    addIfPresent('color', color.value);
    addIfPresent('style', style.value);
    addIfPresent('spatialReference', spatialReference?.toJson());
    json['points'] = _pointsToJson();
    addIfPresent('visible', visible);
    addIfPresent('width', width);
    addIfPresent('zIndex', zIndex);
    addIfPresent('antialias', antialias);
    addIfPresent('selectedColor', selectedColor?.value);
    addIfPresent('visibilityFilter', visibilityFilter?.toJson());
    return json;
  }

  @override
  int get hashCode => polylineId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PolylineMarker &&
          runtimeType == other.runtimeType &&
          polylineId == other.polylineId &&
          consumeTapEvents == other.consumeTapEvents &&
          color == other.color &&
          style == other.style &&
          points == other.points &&
          visible == other.visible &&
          width == other.width &&
          zIndex == other.zIndex &&
          antialias == other.antialias &&
          selectedColor == other.selectedColor &&
          visibilityFilter == other.visibilityFilter;

  Object _pointsToJson() {
    final List<Object> result = <Object>[];
    for (final Point point in points) {
      result.add(point.toJson());
    }
    return result;
  }
}
