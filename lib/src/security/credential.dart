part of arcgis_maps_flutter;

@immutable
abstract class Credential {
  const Credential();

  @Deprecated('Use UserCredential.createUserCredential instead')
  factory Credential.creteUserCredential({
    required String username,
    required String password,
    String? referer,
  }) =>
      UserCredential.createUserCredential(
        username: username,
        password: password,
        referer: referer,
      );

  @Deprecated('Use UserCredential instead')
  factory Credential.createFromToken({
    required String token,
    String? referer,
  }) =>
      UserCredential.createFromToken(
        token: token,
        referer: referer,
      );

  factory Credential.fromJson(Map<dynamic, dynamic> json) {
    if (json['type'] == 'UserCredential') {
      return UserCredential.fromJson(json);
    } else {
      throw Exception('Unknown credential type: ${json['type']}');
    }
  }

  Object toJson();
}