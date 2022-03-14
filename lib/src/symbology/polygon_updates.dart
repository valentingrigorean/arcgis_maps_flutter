import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/maps_object_updates.dart';

/// [Polygon] update events to be applied to the [ArcgisMapView].
///
// (Do not re-export)
class PolygonUpdates extends MapsObjectUpdates<Polygon> {
  /// Computes [PolygonUpdates] given previous and current [Polygon]s.
  PolygonUpdates.from(Set<Polygon> previous, Set<Polygon> current)
      : super.from(previous, current, objectName: 'polygon');
}
