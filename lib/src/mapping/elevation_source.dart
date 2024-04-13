part of '../../arcgis_maps_flutter.dart';


abstract class ElevationSource implements MapsObject {
  @override
  clone() {
    throw UnimplementedError();
  }

  @override
  String get mapsId => throw UnimplementedError();

  @override
  Object toJson() {
    throw UnimplementedError();
  }
}
