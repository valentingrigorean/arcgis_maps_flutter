import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/method_channel/arcgis_flutter_platform.dart';
import 'package:flutter/services.dart';

class MethodChannelArcgisFlutter extends ArcgisFlutterPlatform {
  final MethodChannel _channel =
      const MethodChannel("plugins.flutter.io/arcgis_channel");

  bool _didSetApiKey = false;

  @override
  Future<void> setApiKey(String apiKey) async {
    if (_didSetApiKey) {
      return;
    }
    await _channel.invokeMethod<void>('arcgis#setApiKey', apiKey);
    _didSetApiKey = true;
  }

  @override
  Future<String> getApiKey() async {
    return await _channel.invokeMethod<String>('arcgis#getApiKey') ?? '';
  }

  @override
  Future<LicenseStatus> setLicense(String licenseKey) async {
    final int? result =
        await _channel.invokeMethod<int>('arcgis#setLicense', licenseKey);
    if(result == null){
      return LicenseStatus.invalid;
    }
    return LicenseStatus.values[result];
  }

  @override
  Future<String> getApiVersion() async {
    return await _channel.invokeMethod<String>('arcgis#getApiVersion') ?? '';
  }
}
