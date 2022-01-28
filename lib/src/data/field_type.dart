enum FieldType {
  unknown,
  integer,
  double,
  date,
  text,
  nullable,
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
  } else if (value == null) {
    type = FieldType.nullable;
  } else {
    type = FieldType.unknown;
  }
  return {
    'type': type.toString(),
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
    case FieldType.unknown:
    case FieldType.integer:
    case FieldType.double:
    case FieldType.text:
      return value;
    case FieldType.nullable:
      return null;
    case FieldType.date:
      if (value is String) {
        return DateTime.tryParse(value);
      }
      return null;
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
