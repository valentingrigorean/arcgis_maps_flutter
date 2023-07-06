import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/arcgis_method_channel.dart';
import 'package:arcgis_maps_flutter/src/method_channel/authentication/token_credential_flutter_platform.dart';
import 'package:flutter/services.dart';

class MethodChannelTokenCredentialFlutter
    extends TokenCredentialFlutterPlatform {
  final MethodChannel _channel = const ArcgisMethodChannel(
      "plugins.flutter.io/arcgis_channel/token_credential");

  @override
Future<TokenCredential> create({
    required String url,
    required String username,
    required String password,
    int? tokenExpirationMinutes,
  }) async {
    throw UnimplementedError('create() has not been implemented.');
  }
}
