part of arcgis_maps_flutter;

class UserCredential extends Credential with EquatableMixin {
  const UserCredential._({
    required this.username,
    required this.password,
    required this.referer,
    required this.token,
  });

  factory UserCredential.createUserCredential({
    required String username,
    required String password,
    String? referer,
  }) =>
      UserCredential._(
        username: username,
        password: password,
        referer: referer,
        token: null,
      );

  factory UserCredential.createFromToken({
    required String token,
    String? referer,
  }) =>
      UserCredential._(
        username: null,
        password: null,
        referer: referer,
        token: token,
      );

  factory UserCredential.fromJson(Map<dynamic, dynamic> json) {
    return UserCredential._(
      username: json['username'] as String?,
      password: json['password'] as String?,
      referer: json['referer'] as String?,
      token: json['token'] as String?,
    );
  }

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
  List<Object?> get props => [
        username,
        password,
        referer,
        token,
      ];
}
