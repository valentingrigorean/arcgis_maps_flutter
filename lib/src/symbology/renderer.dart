part of '../../arcgis_maps_flutter.dart';

abstract class Renderer {
  const Renderer();

  String get type;

  Map<String, Object?> toJson(){
    final Map<String, Object?> json = <String, Object?>{};
    json['type'] = type;
    return json;
  }
}