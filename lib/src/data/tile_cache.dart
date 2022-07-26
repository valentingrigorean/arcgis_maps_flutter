part of arcgis_maps_flutter;

enum CacheStorageFormat {
  unknown(-1),
  compact(0),
  compactV2(1),
  exploded(2);

  const CacheStorageFormat(this.value);

  factory CacheStorageFormat.fromValue(int value) {
    return CacheStorageFormat.values.firstWhere(
      (e) => e.value == value,
      orElse: () => CacheStorageFormat.unknown,
    );
  }

  final int value;
}

class TileCache extends ArcgisNativeObject with Loadable {
  TileCache({
    required this.path,
  });

  final String path;

  @override
  String get type => "TileCache";

  Future<bool> get antialiasing async {
    final result = await invokeMethod('tileCache#getAntialiasing');
    return result;
  }

  Future<CacheStorageFormat> get cacheStorageFormat async {
    final result = await invokeMethod('tileCache#getCacheStorageFormat');
    return CacheStorageFormat.fromValue(
        result ?? CacheStorageFormat.unknown.value);
  }

  Future<TileInfo?> get tileInfo async {
    final result = await invokeMethod('tileCache#getTileInfo');
    if (result == null) {
      return null;
    }
    return TileInfo.fromJson(result);
  }

  Future<AGSEnvelope?> get fullExtent async {
    final result = await invokeMethod('tileCache#getFullExtent');
    if (result == null) {
      return null;
    }
    return AGSEnvelope.fromJson(result);
  }

  @override
  dynamic getCreateArguments() => path;

  Object toJson() {
    final json = <String, dynamic>{};

    if (isCreated) {
      json['nativeObjectId'] = nativeObjectId;
    } else {
      json['path'] = path;
    }

    return json;
  }
}
