part of arcgis_maps_flutter;

enum KeychainAccess {
  afterFirstUnlock,
  afterFirstUnlockThisDeviceOnly,
  whenUnlocked,
  whenUnlockedThisDeviceOnly,
  whenPasscodeSetThisDeviceOnly,
}

class CredentialStorePersistentOptioniOS {
  final bool synchronizesWithiCloud;
  final KeychainAccess access;

  const CredentialStorePersistentOptioniOS({
    required this.access,
    this.synchronizesWithiCloud = false,
  });

  Map<String, dynamic> toJson() {
    return {
      "synchronizesWithiCloud": synchronizesWithiCloud,
      "access": access.index,
    };
  }
}

class ArcGISCredentialStore {
  final _channel = const ArcgisMethodChannel(
      'plugins.flutter.io/arcgis_channel/credential_store');

  const ArcGISCredentialStore._();

  static const ArcGISCredentialStore _instance = ArcGISCredentialStore._();

  factory ArcGISCredentialStore() => _instance;

  Future<void> makePersistent({
    CredentialStorePersistentOptioniOS iosOptions =
        const CredentialStorePersistentOptioniOS(
            access: KeychainAccess.afterFirstUnlockThisDeviceOnly),
  }) async {
    return await _channel.invokeMethod(
      'arcGISCredentialStore#makePersistent',
      defaultTargetPlatform == TargetPlatform.iOS ? iosOptions.toJson() : null,
    );
  }

  Future<String> addCredential({
    required String url,
    required String username,
    required String password,
    int? tokenExpirationMinutes,
  }) async {
    return await _channel.invokeMethod('arcGISCredentialStore#addCredential', {
      "url": url,
      "username": username,
      "password": password,
      "tokenExpirationMinutes": tokenExpirationMinutes,
    });
  }

  Future<String> addPregeneratedTokenCredential({
    required String url,
    required TokenInfo tokenInfo,
    String referer = '',
  }) async {
    return await _channel
        .invokeMethod('arcGISCredentialStore#addPregeneratedTokenCredential', {
      "url": url,
      "tokenInfo": tokenInfo.toJson(),
      "referer": referer,
    });
  }

  Future<String> addOAuthCredential({
    required String portalUrl,
    required String clientId,
    required String redirectUri,
}) async{
    return await _channel.invokeMethod('arcGISCredentialStore#addOAuthCredential', {
      "portalUrl": portalUrl,
      "clientId": clientId,
      "redirectUri": redirectUri,
    });
  }

  Future<void> removeCredential(String handlerId) {
    return _channel.invokeMethod(
        'arcGISCredentialStore#removeCredential', handlerId);
  }
}
