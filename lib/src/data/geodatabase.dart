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

  Future<void> close() async {
    await invokeMethod('geodatabase#close');
  }

  @override
  @protected
  dynamic getCreateArguments() => path;

  Object toJson() {
    if(!isCreated){
      throw Exception('Object is not created');
    }
    return nativeObjectId;
  }
}
