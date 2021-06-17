import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/maps_object_updates.dart';

class MarkerUpdates extends MapsObjectUpdates<Marker> {
  MarkerUpdates.from(Set<Marker> previous, Set<Marker> current)
      : super.from(previous, current, objectName: 'marker');

  /// Set of Markers to be added in this update.
  Set<Marker> get markersToAdd => objectsToAdd;

  /// Set of MarkerIds to be removed in this update.
  Set<MarkerId> get markerIdsToRemove => objectIdsToRemove.cast<MarkerId>();

  /// Set of Markers to be changed in this update.
  Set<Marker> get markersToChange => objectsToChange;
}
