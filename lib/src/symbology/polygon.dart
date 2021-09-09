part of arcgis_maps_flutter;

/// Uniquely identifies a [Polygon] among [ArcgisMapView] polygons.
///
/// This does not have to be globally unique, only unique among the list.
@immutable
class PolygonId extends MapsObjectId<Polygon> {
  /// Creates an immutable identifier for a [Polygon].
  const PolygonId(String value) : super(value);
}

/// Draws a polygon through geographical locations on the map.
@immutable
class Polygon implements MapsObject {
  /// Creates an immutable representation of a polygon through geographical locations on the map.
  const Polygon({
    required this.polygonId,
    this.consumeTapEvents = false,
    this.fillColor = Colors.black,
    this.points = const <Point>[],
    this.strokeColor = Colors.black,
    this.strokeWidth = 10,
    this.visible = true,
    this.zIndex = 0,
    this.onTap,
    this.selectedColor,
    this.visibilityFilter,
  });

  /// Uniquely identifies a [Polygon].
  final PolygonId polygonId;

  /// True if the [Polygon] consumes tap events.
  ///
  /// If this is false, [onTap] callback will not be triggered.
  final bool consumeTapEvents;

  /// Fill color in ARGB format, the same format used by Color. The default value is black (0xff000000).
  final Color fillColor;

  /// The vertices of the polygon to be drawn.
  final List<Point> points;

  /// True if the marker is visible.
  final bool visible;

  /// Line color in ARGB format, the same format used by Color. The default value is black (0xff000000).
  final Color strokeColor;

  /// Width of the polygon, used to define the width of the line to be drawn.
  ///
  /// The width is constant and independent of the camera's zoom level.
  /// The default value is 10.
  final int strokeWidth;

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

  @override
  MapsObjectId get mapsId => polygonId;

  /// Creates a new [Polygon] object whose values are the same as this instance,
  /// unless overwritten by the specified parameters.
  Polygon copyWith(
      {bool? consumeTapEventsParam,
      Color? fillColorParam,
      List<Point>? pointsParam,
      Color? strokeColorParam,
      int? strokeWidthParam,
      bool? visibleParam,
      int? zIndexParam,
      VoidCallback? onTapParam,
      Color? selectedColorParam,
      SymbolVisibilityFilter? visibilityFilterParam}) {
    return Polygon(
      polygonId: polygonId,
      consumeTapEvents: consumeTapEventsParam ?? consumeTapEvents,
      fillColor: fillColorParam ?? fillColor,
      points: pointsParam ?? points,
      strokeColor: strokeColorParam ?? strokeColor,
      strokeWidth: strokeWidthParam ?? strokeWidth,
      visible: visibleParam ?? visible,
      onTap: onTapParam ?? onTap,
      zIndex: zIndexParam ?? zIndex,
      selectedColor: selectedColorParam ?? selectedColor,
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
    addIfPresent('visible', visible);
    addIfPresent('zIndex', zIndex);
    addIfPresent('selectedColor', selectedColor?.value);
    addIfPresent('visibilityFilter', visibilityFilter?.toJson());

    json['points'] = _pointsToJson();

    return json;
  }

  @override
  int get hashCode => polygonId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Polygon &&
          runtimeType == other.runtimeType &&
          polygonId == other.polygonId &&
          consumeTapEvents == other.consumeTapEvents &&
          fillColor == other.fillColor &&
          points == other.points &&
          visible == other.visible &&
          strokeColor == other.strokeColor &&
          strokeWidth == other.strokeWidth &&
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
