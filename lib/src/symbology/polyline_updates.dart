
import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/maps_object_updates.dart';

/// [Polyline] update events to be applied to the [ArcgisMapView].
///
/// Used in [ArcgisMapController] when the map is updated.
// (Do not re-export)
class PolylineUpdates extends MapsObjectUpdates<Polyline> {
  /// Computes [PolylineUpdates] given previous and current [Polyline]s.
  PolylineUpdates.from(Set<Polyline> previous, Set<Polyline> current)
      : super.from(previous, current, objectName: 'polyline');

  /// Set of Polylines to be added in this update.
  Set<Polyline> get polylinesToAdd => objectsToAdd;

  /// Set of PolylineIds to be removed in this update.
  Set<PolylineId> get polylineIdsToRemove =>
      objectIdsToRemove.cast<PolylineId>();

  /// Set of Polylines to be changed in this update.
  Set<Polyline> get polylinesToChange => objectsToChange;
}