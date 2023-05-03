part of arcgis_maps_flutter;

enum UnitSystem {
  ///  Used for imperial units, e.g. miles
  imperial(0),

  ///  Used for metric units, e.g. kilometers
  metric(1),
  ;

  const UnitSystem(this.value);

  factory UnitSystem.fromValue(int value) {
    return UnitSystem.values.firstWhere(
      (e) => e.value == value,
      orElse: () => UnitSystem.imperial,
    );
  }

  final int value;
}
