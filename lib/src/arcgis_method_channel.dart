import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/services.dart';

class ArcgisMethodChannel extends MethodChannel {
  const ArcgisMethodChannel(super.name);

  @override
  Future<T?> invokeMethod<T>(String method, [arguments]) async {
    final result = await super.invokeMethod(method, arguments);
    _checkNativeError(result);
    return result as T?;
  }

  @override
  Future<List<T>?> invokeListMethod<T>(String method, [arguments]) async {
    final result = await super.invokeMethod(method, arguments);
    _checkNativeError(result);
    return result?.cast<T>();
  }

  @override
  Future<Map<K, V>?> invokeMapMethod<K, V>(String method, [arguments]) async {
    final result = await super.invokeMethod(method, arguments);
    _checkNativeError(result);
    return result?.cast<K, V>();
  }

  void _checkNativeError(dynamic result) {
    if (result is Map) {
      final flutterError = result['flutterError'] ?? false;
      if (flutterError) {
        throw ArcgisError.fromJson(result) ?? 'Unknown error';
      }
    }
  }
}
