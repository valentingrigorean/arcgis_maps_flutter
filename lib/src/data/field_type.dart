import 'dart:typed_data';

import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';

enum FieldType {
  unknown(0),
  integer(1),
  double(2),
  date(3),
  text(4),
  nullable(5),
  blob(6),
  geometry(7);

  const FieldType(this.value);

  final int value;
}

Object toNativeField(Object? value) {
  late final FieldType type;
  if (value is int) {
    type = FieldType.integer;
  } else if (value is double) {
    type = FieldType.double;
  } else if (value is DateTime) {
    type = FieldType.date;
    value = value.toIso8601String();
  } else if (value is String) {
    type = FieldType.text;
  } else if (value is Uint8List) {
    type = FieldType.blob;
  } else if (value is Geometry) {
    type = FieldType.geometry;
    value = value.toJson();
  } else if (value == null) {
    type = FieldType.nullable;
  } else {
    type = FieldType.unknown;
  }
  return {
    'type': type.value,
    'value': value,
  };
}

dynamic fromNativeField(Map<dynamic, dynamic>? map) {
  if (map == null) {
    return null;
  }
  final FieldType fieldType = FieldType.values[map['type']!];
  final value = map['value'];
  switch (fieldType) {
    case FieldType.double:
      return (value as num).toDouble();
    case FieldType.unknown:
    case FieldType.integer:
    case FieldType.text:
    case FieldType.blob:
      return value;
    case FieldType.nullable:
      return null;
    case FieldType.date:
      if (value is String) {
        return DateTime.tryParse(value);
      }
      return null;
    case FieldType.geometry:
      return Geometry.fromJson(value);
  }
}

Map<String, Object?>? parseAttributes(Map<dynamic, dynamic>? attributes) {
  if (attributes == null) {
    return null;
  }
  final Map<String, Object?> result = <String, Object?>{};
  attributes.forEach((key, value) {
    result[key] = fromNativeField(value);
  });
  return result;
}
