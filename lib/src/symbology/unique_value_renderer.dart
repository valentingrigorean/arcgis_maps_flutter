part of '../../arcgis_maps_flutter.dart';

class UniqueValue {
  const UniqueValue({
    this.description = '',
    this.label = '',
    this.symbol,
    this.values = const [],
  });

  final String description;
  final String label;
  final Symbol? symbol;
  final List<String> values;

  Map<String, Object?> toJson() {
    final Map<String, Object?> json = <String, Object?>{};
    json['description'] = description;
    json['label'] = label;
    json['symbol'] = symbol?.toJson();
    json['values'] = values;
    return json;
  }
}

class UniqueValueRenderer extends Renderer {
  const UniqueValueRenderer({
    this.defaultLabel = '',
    this.defaultSymbol,
    this.fieldsNames = const [],
    this.uniqueValues = const [],
  });

  final String defaultLabel;
  final Symbol? defaultSymbol;

  final List<String> fieldsNames;

  final List<UniqueValue> uniqueValues;

  @override
  Map<String, Object?> toJson() {
    final Map<String, Object?> json = <String, Object?>{};
    json['defaultLabel'] = defaultLabel;
    json['defaultSymbol'] = defaultSymbol?.toJson();
    json['fieldsNames'] = fieldsNames;
    json['uniqueValues'] = uniqueValues.map((e) => e.toJson()).toList();
    return json;
  }
}
