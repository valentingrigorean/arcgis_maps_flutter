import 'dart:convert';

Map<dynamic, dynamic> toSafeMap(dynamic o) {
  return toSafeMapNullable(o)!;
}

Map<dynamic, dynamic>? toSafeMapNullable(dynamic o) {
  if (o is String) {
    return jsonDecode(o);
  }
  if (o is Map<dynamic, dynamic>) {
    return o;
  }
  return null;
}

double? toDoubleNullable(dynamic o) {
  if (o is int) {
    return o.toDouble();
  }
  if (o is double) {
    return o;
  }
  return null;
}
