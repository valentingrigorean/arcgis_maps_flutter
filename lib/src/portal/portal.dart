part of arcgis_maps_flutter;

@immutable
class Portal {
  Portal({
    required this.postalUrl,
    required this.loginRequired,
    this.credential,
  });

  factory Portal.arcGISOnline({
    required withLoginRequired,
    Credential? credential,
  }) =>
      Portal(
        postalUrl: 'https://www.arcgis.com',
        loginRequired: withLoginRequired,
        credential: credential,
      );

  final String postalUrl;

  final bool loginRequired;

  final Credential? credential;

  Object toJson() {
    final Map<String, Object> json = <String, Object>{};
    json['postalUrl'] = postalUrl;
    json['loginRequired'] = loginRequired;
    if (credential != null) {
      json['credential'] = credential!.toJson();
    }
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Portal &&
          runtimeType == other.runtimeType &&
          postalUrl == other.postalUrl &&
          loginRequired == other.loginRequired &&
          credential == other.credential;

  @override
  int get hashCode =>
      postalUrl.hashCode ^ loginRequired.hashCode ^ credential.hashCode;
}
