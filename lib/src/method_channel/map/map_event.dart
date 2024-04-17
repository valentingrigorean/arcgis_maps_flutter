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


class UserLocationTapEvent extends MapEvent<void> {
  const UserLocationTapEvent(int mapId) : super(mapId, null);
}

class MapLoadedEvent extends MapEvent<ArcgisError?> {
  const MapLoadedEvent(
    super.mapId,
    super.value,
  );
}

class LayerLoadedEvent extends MapEvent<String> {
  const LayerLoadedEvent(
    int mapId,
    this.error,
    String value,
  ) : super(mapId, value);

  final ArcgisError? error;
}


class ViewpointChangedEvent extends MapEvent<void> {
  const ViewpointChangedEvent(int mapId) : super(mapId, null);
}

class TimeExtentChangedEvent extends MapEvent<TimeExtent?> {
  const TimeExtentChangedEvent(super.mapId, super.value);
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
  final Point? position;

  final Offset screenPoint;
}
