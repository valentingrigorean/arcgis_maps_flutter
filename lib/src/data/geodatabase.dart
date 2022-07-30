part of arcgis_maps_flutter;

class Geodatabase extends ArcgisNativeObject with Loadable {

  /// Initialize this object with the name of an
  /// existing geodatabase (.geodatabase file), excluding
  /// the “.geodatabase” extension,
  Geodatabase({
    required this.path,
  });

  final String path;

  @override
  String get type => 'Geodatabase';

  @override
  @protected
  dynamic getCreateArguments() => path;
}
