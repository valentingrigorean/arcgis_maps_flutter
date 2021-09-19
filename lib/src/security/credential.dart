part of arcgis_maps_flutter;

@immutable
class Credential{
  final _BaseCredentials _baseCredentials;

  const Credential._(this._baseCredentials);

  factory Credential.creteUserCredential({
    required String username,
    required String password,
    String? referer,
  }) =>
      Credential._(
        _UserCredential(
          username: username,
          password: password,
          referer: referer,
        ),
      );

  factory Credential.createFromToken({required String token,String? referer})
    => Credential._(
      _UserCredential(
        token: token,
        referer: referer,
      ),
    );

  Object toJson() => _baseCredentials.toJson();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Credential &&
          runtimeType == other.runtimeType &&
          _baseCredentials == other._baseCredentials;

  @override
  int get hashCode => _baseCredentials.hashCode;
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
