import 'dart:ui';

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';

class MapEvent<T> {
  /// The ID of the Map this event is associated to.
  final int mapId;

  /// The value wrapped by this event
  final T value;

  /// Build a Map Event, that relates a mapId with a given value.
  ///
  /// The `mapId` is the id of the map that triggered the event.
  /// `value` may be `null` in events that don't transport any meaningful data.
  const MapEvent(this.mapId, this.value);
}

/// An event fired when a [Marker] is tapped.
class MarkerTapEvent extends MapEvent<MarkerId> {
  /// Build a MarkerTap Event triggered from the map represented by `mapId`.
  ///
  /// The `value` of this event is a [MarkerId] object that represents the tapped Marker.
  const MarkerTapEvent(
    int mapId,
    MarkerId markerId,
  ) : super(mapId, markerId);
}

/// An event fired when a [Polygon] is tapped.
class PolygonTapEvent extends MapEvent<PolygonId> {
  /// Build a PolygonTap Event triggered from the map represented by `mapId`.
  ///
  /// The `value` of this event is a [PolygonId] object that represents the tapped Polygon.
  const PolygonTapEvent(
    int mapId,
    PolygonId polygonId,
  ) : super(mapId, polygonId);
}

class PolylineTapEvent extends MapEvent<PolylineId> {
  /// Build a PolylineTap Event triggered from the map represented by `mapId`.
  ///
  /// The `value` of this event is a [PolylineId] object that represents the tapped Polygon.
  const PolylineTapEvent(
    int mapId,
    PolylineId polylineId,
  ) : super(mapId, polylineId);
}

class UserLocationTapEvent extends MapEvent<void> {
  const UserLocationTapEvent(int mapId) : super(mapId, null);
}

class IdentifyLayerEvent extends MapEvent<LayerId> {
  const IdentifyLayerEvent(
    int mapId,
    LayerId layerId, {
    required this.result,
    required this.screenPoint,
    required this.position,
  }) : super(mapId, layerId);

  final Offset screenPoint;
  final AGSPoint position;

  final IdentifyLayerResult result;
}

class IdentifyLayersEvent extends MapEvent<void> {
  const IdentifyLayersEvent(
    int mapId, {
    required this.results,
    required this.screenPoint,
    required this.position,
  }) : super(mapId, null);

  final Offset screenPoint;
  final AGSPoint position;

  final List<IdentifyLayerResult> results;
}

class MapLoadedEvent extends MapEvent<ArcgisError?> {
  const MapLoadedEvent(
    int mapId,
    ArcgisError? value,
  ) : super(mapId, value);
}

class LayerLoadedEvent extends MapEvent<LayerId> {
  const LayerLoadedEvent(
    int mapId,
    this.error,
    LayerId value,
  ) : super(mapId, value);

  final ArcgisError? error;
}

/// An event fired when a Map is tapped.
class MapTapEvent extends _PositionedMapEvent<void> {
  /// Build an MapTap Event triggered from the map represented by `mapId`.
  ///
  /// The `position` of this event is the LatLng where the Map was tapped.
  const MapTapEvent(
    super.mapId, {
    required super.screenPoint,
    required super.position,
  }) : super(value: null);
}

class MapLongPressEvent extends _PositionedMapEvent<void> {
  const MapLongPressEvent(
    super.mapId, {
    required super.screenPoint,
    required super.position,
  }) : super(value: null);
}

class MapLongPressEndEvent extends _PositionedMapEvent<void> {
  const MapLongPressEndEvent(
      super.mapId, {
        required super.screenPoint,
        required super.position,
      }) : super(value: null);
}

class ViewpointChangedEvent extends MapEvent<void> {
  const ViewpointChangedEvent(int mapId) : super(mapId, null);
}

class LayersChangedEvent extends MapEvent<LayerType> {
  const LayersChangedEvent(
    int mapId,
    LayerType layerType,
    this.layerChangeType,
  ) : super(
          mapId,
          layerType,
        );

  final LayerChangeType layerChangeType;
}

class TimeExtentChangedEvent extends MapEvent<TimeExtent?> {
  const TimeExtentChangedEvent(int mapId, TimeExtent? value)
      : super(mapId, value);
}

/// A `MapEvent` associated to a `position`.
class _PositionedMapEvent<T> extends MapEvent<T> {
  /// Build a Positioned MapEvent, that relates a mapId and a position with a value.
  ///
  /// The `mapId` is the id of the map that triggered the event.
  /// `value` may be `null` in events that don't transport any meaningful data.
  const _PositionedMapEvent(
    int mapId, {
    required this.position,
    required this.screenPoint,
    required T value,
  }) : super(mapId, value);

  /// The position where this event happened.
  final AGSPoint position;

  final Offset screenPoint;
}
