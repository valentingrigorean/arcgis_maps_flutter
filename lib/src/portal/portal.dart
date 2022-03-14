part of arcgis_maps_flutter;

@immutable
class Portal extends Equatable {
  const Portal({
    required this.postalUrl,
    required this.loginRequired,
    this.credential,
  });

  factory Portal.arcGISOnline({
    required bool withLoginRequired,
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
  List<Object?> get props => [postalUrl, loginRequired, credential];
}
