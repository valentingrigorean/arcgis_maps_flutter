import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/maps_object_updates.dart';

class GraphicUpdates extends MapsObjectUpdates<Graphic> {
  GraphicUpdates.from(super.previous, super.current)
      : super.from(objectName: 'graphic');
}
