import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/method_channel/authentication/method_channel_token_credential_flutter.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class TokenCredentialFlutterPlatform extends PlatformInterface {
  static final Object _token = Object();

  static TokenCredentialFlutterPlatform _instance =
      MethodChannelTokenCredentialFlutter();

  TokenCredentialFlutterPlatform() : super(token: _token);

  static TokenCredentialFlutterPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [UrlLauncherPlatform] when they register themselves.
  static set instance(TokenCredentialFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<TokenCredential> create({
    required String url,
    required String username,
    required String password,
    int? tokenExpirationMinutes,
  }) {
    throw UnimplementedError('create() has not been implemented.');
  }
}
