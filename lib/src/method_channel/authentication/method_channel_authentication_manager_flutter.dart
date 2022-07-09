import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter/services.dart';

import 'authentication_manager_flutter_platform.dart';

class MethodChannelAuthenticationManagerFlutter
    extends AuthenticationManagerFlutterPlatform {
  final MethodChannel _channel =
      const MethodChannel("plugins.flutter.io/authentication_manager");

  @override
  Future<void> setPersistence(
      String serviceContext, String username, String password) async {
    return await _channel.invokeMethod("setPersistence", {
      "serviceContext": serviceContext,
      "username": username,
      "password": password
    });
  }
}
