part of '../../arcgis_maps_flutter.dart';

class CompositeSymbol extends Symbol {
  const CompositeSymbol({
    required this.symbols,
  });

  final List<Symbol> symbols;

  @override
  String get type => 'composite';

  @override
  List<Object?> get props => [symbols];

  @override
  Map<String, Object?> toJson() {
    final Map<String, Object?> json = super.toJson();
    json['symbols'] = symbols.map((Symbol symbol) => symbol.toJson()).toList();
    return json;
  }
}
