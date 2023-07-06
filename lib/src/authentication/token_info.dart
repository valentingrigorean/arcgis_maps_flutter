part of arcgis_maps_flutter;

@immutable
class TokenInfo {
  /// The access token string.
  ///
  /// This is the token that represents the authenticated user.
  final String accessToken;

  /// The token expiration date.
  ///
  /// This is the date when the access token will expire.
  final DateTime expirationDate;

  /// A Boolean value that indicates whether the token must be passed over HTTPS.
  ///
  /// If `true`, the token must be passed over HTTPS. If `false`, it can be passed over HTTP.
  final bool isSSLRequired;

  const TokenInfo({
    required this.accessToken,
    required this.expirationDate,
    required this.isSSLRequired,
  });

  factory TokenInfo.fromJson(Map<dynamic, dynamic> json) {
    return TokenInfo(
      accessToken: json['accessToken'] as String,
      expirationDate: DateTime.parse(json['expirationDate'] as String),
      isSSLRequired: json['isSSLRequired'] as bool,
    );
  }

  Object toJson() {
    return {
      "accessToken": accessToken,
      "expirationDate": expirationDate.toIso8601String(),
      "isSSLRequired": isSSLRequired,
    };
  }
}
