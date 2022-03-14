// Map<dynamic, dynamic> toSafeMap(dynamic o) {
//   return toSafeMapNullable(o)!;
// }
//
// Map<dynamic, dynamic>? toSafeMapNullable(dynamic o) {
//   if (o is String) {
//     return jsonDecode(o);
//   }
//   if (o is Map<dynamic, dynamic>) {
//     return o;
//   }
//   return null;
// }

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';

double toDoubleSafe(dynamic o) {
  return toDoubleSafeNullable(o)!;
}

double? toDoubleSafeNullable(dynamic o) {
  if (o is int) {
    return o.toDouble();
  }
  if (o is double) {
    return o;
  }
  return null;
}

DateTime parseDateTime(dynamic o) {
  return parseDateTimeSafeNullable(o)!;
}

DateTime? parseDateTimeSafeNullable(dynamic o) {
  if (o is String) {
    return DateTime.tryParse(o);
  }
  return null;
}

List<Object> pointToList(
  AGSPoint point, {
  required bool hasZ,
  required bool hasM,
}) {
  final pointLength = 2 + (hasZ ? 1 : 0) + (hasM ? 1 : 0);
  final List<Object> pointJson = List.generate(pointLength, (index) => 0.0);
  pointJson[0] = point.x;
  pointJson[1] = point.y;
  int i = 2;
  if (point.z != null) {
    pointJson[i] = point.z!;
    i++;
  }
  if (point.m != null) {
    pointJson[i] = point.m!;
  }
  return pointJson;
}
