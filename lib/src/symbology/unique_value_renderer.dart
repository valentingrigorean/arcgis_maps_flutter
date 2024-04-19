part of '../../arcgis_maps_flutter.dart';

class UniqueValue extends Equatable {
  const UniqueValue({
    this.description = '',
    this.label = '',
    this.symbol,
    this.values = const [],
  });

  final String description;
  final String label;
  final GraphicSymbol? symbol;
  final List<Object> values;

  Map<String, Object?> toJson() {
    final Map<String, Object?> json = <String, Object?>{};
    json['description'] = description;
    json['label'] = label;
    json['symbol'] = symbol?.toJson();
    json['values'] = values;
    return json;
  }

  @override
  List<Object?> get props => [description, label, symbol, values];
}

class UniqueValueRenderer extends Renderer with EquatableMixin {
  const UniqueValueRenderer({
    super.rotationExpression,
    super.rotationType,
    this.defaultLabel = '',
    this.defaultSymbol,
    this.fieldsNames = const [],
    this.uniqueValues = const [],
  });

  final String defaultLabel;
  final GraphicSymbol? defaultSymbol;

  final List<String> fieldsNames;

  final List<UniqueValue> uniqueValues;

  @override
  String get type => 'unique-value';

  @override
  Map<String, Object?> toJson() {
    final Map<String, Object?> json = super.toJson();
    json['defaultLabel'] = defaultLabel;
    json['defaultSymbol'] = defaultSymbol?.toJson();
    json['fieldsNames'] = fieldsNames;
    json['uniqueValues'] = uniqueValues.map((e) => e.toJson()).toList();
    return json;
  }

  @override
  List<Object?> get props => [
        defaultLabel,
        defaultSymbol,
        fieldsNames,
        uniqueValues,
      ];
}
