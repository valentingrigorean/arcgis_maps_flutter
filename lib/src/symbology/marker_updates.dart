import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/maps_object_updates.dart';

class MarkerUpdates extends MapsObjectUpdates<Marker> {
  MarkerUpdates.from(Set<Marker> previous, Set<Marker> current)
      : super.from(previous, current, objectName: 'marker');
}
