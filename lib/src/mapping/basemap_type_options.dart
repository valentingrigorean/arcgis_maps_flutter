import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/cupertino.dart';

@immutable
class BasemapTypeOptions {
  final BasemapType basemapType;
  final double latitude;
  final double longitude;
  final int levelOfDetail;

  const BasemapTypeOptions({
    required this.basemapType,
    required this.latitude,
    required this.longitude,
    required this.levelOfDetail,
  });

  Object toJson() {
    final Map<String, Object> json = <String, Object>{};
    json['basemapType'] =
        basemapType.toString().replaceFirst('BasemapType.', '');
    json['latitude'] = latitude;
    json['longitude'] = longitude;
    json['levelOfDetail'] = levelOfDetail;
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BasemapTypeOptions &&
          runtimeType == other.runtimeType &&
          basemapType == other.basemapType &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          levelOfDetail == other.levelOfDetail;

  @override
  int get hashCode =>
      basemapType.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      levelOfDetail.hashCode;
}
