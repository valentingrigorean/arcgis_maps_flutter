import 'package:arcgis_maps_flutter/src/arcgis_native_object.dart';

mixin ApiKeyResource on ArcgisNativeObject {
  Future<String> get apiKey async {
    return await invokeMethod<String>('apiKeyResource#getApiKey') ?? '';
  }

  Future<void> setApiKey(String apiKey) async {
    await invokeMethod('apiKeyResource#setApiKey', arguments: apiKey);
  }
}
