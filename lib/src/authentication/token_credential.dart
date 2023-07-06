part of arcgis_maps_flutter;

@immutable
class TokenCredential {
  const TokenCredential(this.tokenInfo);

  final TokenInfo tokenInfo;

  static Future<TokenCredential> create({
    required String url,
    required String username,
    required String password,
    int? tokenExpirationMinutes,
  }) =>
      TokenCredentialFlutterPlatform.instance.create(
        url: url,
        username: username,
        password: password,
        tokenExpirationMinutes: tokenExpirationMinutes,
      );

  Object toJson() {
    return tokenInfo.toJson();
  }
}
