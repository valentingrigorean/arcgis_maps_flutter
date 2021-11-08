import 'dart:io';

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';

final Map<GeometryType, int> _toAndroidMap = {
  GeometryType.point: 0,
  GeometryType.envelope: 1,
  GeometryType.polyline: 2,
  GeometryType.polygon: 3,
  GeometryType.multipoint: 4,
  GeometryType.unknown: 5,
};

final Map<int, GeometryType> _toFlutterMapAndroid = {
  0: GeometryType.point,
  1: GeometryType.envelope,
  2: GeometryType.polyline,
  3: GeometryType.polygon,
  4: GeometryType.multipoint,
  5: GeometryType.unknown,
};

final Map<GeometryType, int> _toIOSMap = {
  GeometryType.point: 1,
  GeometryType.envelope: 2,
  GeometryType.polyline: 3,
  GeometryType.polygon: 4,
  GeometryType.multipoint: 5,
  GeometryType.unknown: -1,
};

final Map<int, GeometryType> _toFlutterMapIOS = {
  1: GeometryType.point,
  2: GeometryType.envelope,
  3: GeometryType.polyline,
  4: GeometryType.polygon,
  5: GeometryType.multipoint,
  -1: GeometryType.unknown,
};


int geometryTypeToPlatformIndex(GeometryType geometryType) {
  if (Platform.isAndroid) {
    return _toAndroidMap[geometryType]!;
  }
  return _toIOSMap[geometryType]!;
}

GeometryType geometryTypeFromPlatformIndex(int index) {
  if (Platform.isAndroid) {
    return _toFlutterMapAndroid[index]!;
  }
  return _toFlutterMapIOS[index]!;
}