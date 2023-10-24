import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/maps_object_updates.dart';

class MarkerUpdates extends MapsObjectUpdates<Marker> {
  MarkerUpdates.from(super.previous, super.current)
      : super.from(objectName: 'marker');
}
