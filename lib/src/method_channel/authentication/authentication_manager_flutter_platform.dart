import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel_authentication_manager_flutter.dart';

abstract class AuthenticationManagerFlutterPlatform extends PlatformInterface {
  static final Object _token = Object();

  static AuthenticationManagerFlutterPlatform _instance = MethodChannelAuthenticationManagerFlutter();

  AuthenticationManagerFlutterPlatform() : super(token: _token);

  static AuthenticationManagerFlutterPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [UrlLauncherPlatform] when they register themselves.
  static set instance(AuthenticationManagerFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> setPersistence(String serviceContext,String username, String password) {
    throw UnimplementedError('setPersistence() has not been implemented.');
  }

}
