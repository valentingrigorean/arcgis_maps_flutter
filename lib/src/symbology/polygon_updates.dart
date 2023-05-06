import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/maps_object_updates.dart';

/// [PolygonMarker] update events to be applied to the [ArcgisMapView].
///
// (Do not re-export)
class PolygonUpdates extends MapsObjectUpdates<PolygonMarker> {
  /// Computes [PolygonUpdates] given previous and current [PolygonMarker]s.
  PolygonUpdates.from(Set<PolygonMarker> previous, Set<PolygonMarker> current)
      : super.from(previous, current, objectName: 'polygon');
}
