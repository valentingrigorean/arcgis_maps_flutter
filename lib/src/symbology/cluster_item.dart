import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:fluster/fluster.dart';

class CLusterItem extends Clusterable {
  CLusterItem({required this.marker})
      : super(
          latitude: marker.position.y,
          longitude: marker.position.x,
          markerId: marker.markerId.value,
        );

  final Marker marker;
}
