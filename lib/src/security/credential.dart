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

abstract class _BaseCredentials {
  Object toJson();
}

class _UserCredential extends _BaseCredentials {
  _UserCredential({this.username, this.password, this.referer, this.token});

  final String? username;
  final String? password;

  final String? referer;

  final String? token;

  @override
  Object toJson() {
    final json = <String, Object>{};

    void addIfPresent(String fieldName, Object? value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    json['type'] = 'UserCredential';

    addIfPresent('username', username);
    addIfPresent('password', password);
    addIfPresent('referer', referer);
    addIfPresent('token', token);

    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _UserCredential &&
          runtimeType == other.runtimeType &&
          username == other.username &&
          password == other.password &&
          referer == other.referer &&
          token == other.token;

  @override
  int get hashCode =>
      username.hashCode ^ password.hashCode ^ referer.hashCode ^ token.hashCode;
}
