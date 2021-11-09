enum FieldType { unknown, integer, double, date, text, nullable }

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
  final Map<String, Object> result = <String, Object>{};
  attributes.forEach((key, value) {
    result[key] = fromNativeField(value);
  });
  return result;
}
