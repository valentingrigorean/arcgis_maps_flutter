part of arcgis_maps_flutter;

enum AreaUnitId {
  acres(0),
  hectares(1),
  squareCentimeters(2),
  squareDecimeters(3),
  squareFeet(4),
  squareMeters(5),
  squareKilometers(6),
  squareMiles(7),
  squareMillimeters(8),
  squareYards(9),
  other(10),
  ;

  const AreaUnitId(this.value);

  factory AreaUnitId.fromValue(int value) {
    return AreaUnitId.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AreaUnitId.other,
    );
  }

  final int value;
}
