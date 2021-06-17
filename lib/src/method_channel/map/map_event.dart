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
  MapEvent(this.mapId, this.value);
}

/// An event fired when a [Marker] is tapped.
class MarkerTapEvent extends MapEvent<MarkerId> {
  /// Build a MarkerTap Event triggered from the map represented by `mapId`.
  ///
  /// The `value` of this event is a [MarkerId] object that represents the tapped Marker.
  MarkerTapEvent(
    int mapId,
    MarkerId markerId,
  ) : super(mapId, markerId);
}

/// An event fired when a [Polygon] is tapped.
class PolygonTapEvent extends MapEvent<PolygonId> {
  /// Build a PolygonTap Event triggered from the map represented by `mapId`.
  ///
  /// The `value` of this event is a [PolygonId] object that represents the tapped Polygon.
  PolygonTapEvent(
    int mapId,
    PolygonId polygonId,
  ) : super(mapId, polygonId);
}

class PolylineTapEvent extends MapEvent<PolylineId> {
  /// Build a PolylineTap Event triggered from the map represented by `mapId`.
  ///
  /// The `value` of this event is a [PolylineId] object that represents the tapped Polygon.
  PolylineTapEvent(
    int mapId,
    PolylineId polylineId,
  ) : super(mapId, polylineId);
}

class IdentifyLayerEvent extends MapEvent<LayerId> {
  IdentifyLayerEvent(
    int mapId,
    LayerId layerId,
    this.result,
  ) : super(mapId, layerId);

  final IdentifyLayerResult result;
}

class IdentifyLayersEvent extends MapEvent<void> {
  IdentifyLayersEvent(
    int mapId,
    this.results,
  ) : super(mapId, null);

  final List<IdentifyLayerResult> results;
}

class MapLoadedEvent extends MapEvent<ArcgisError?> {
  MapLoadedEvent(
    int mapId,
    ArcgisError? value,
  ) : super(mapId, value);
}

class LayerLoadedEvent extends MapEvent<LayerId> {
  LayerLoadedEvent(
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
  MapTapEvent(
    int mapId,
    Point position,
  ) : super(mapId, position, null);
}

/// An event fired while the Camera of a [mapId] moves.
class CameraMoveEvent extends MapEvent<void> {
  /// Build a CameraMove Event triggered from the map represented by `mapId`.
  ///
  CameraMoveEvent(int mapId) : super(mapId, null);
}

/// A `MapEvent` associated to a `position`.
class _PositionedMapEvent<T> extends MapEvent<T> {
  /// The position where this event happened.
  final Point position;

  /// Build a Positioned MapEvent, that relates a mapId and a position with a value.
  ///
  /// The `mapId` is the id of the map that triggered the event.
  /// `value` may be `null` in events that don't transport any meaningful data.
  _PositionedMapEvent(
    int mapId,
    this.position,
    T value,
  ) : super(mapId, value);
}
