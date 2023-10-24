
import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/maps_object_updates.dart';

/// [PolylineMarker] update events to be applied to the [ArcgisMapView].
///
/// Used in [ArcgisMapController] when the map is updated.
// (Do not re-export)
class PolylineUpdates extends MapsObjectUpdates<PolylineMarker> {
  /// Computes [PolylineUpdates] given previous and current [PolylineMarker]s.
  PolylineUpdates.from(super.previous, super.current)
      : super.from(objectName: 'polyline');
}