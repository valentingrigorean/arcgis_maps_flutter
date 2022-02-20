
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
