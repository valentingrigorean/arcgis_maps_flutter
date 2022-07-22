part of arcgis_maps_flutter;

const int unknownError = -23123;

enum ErrorDomain {
  arcgisRuntime(0),
  arcgisServer(1),
  unknown(2);

  const ErrorDomain(this.value);

  factory ErrorDomain.fromValue(int value) {
    return ErrorDomain.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ErrorDomain.unknown,
    );
  }

  final int value;
}

@immutable
class ArcgisError implements Exception {
  const ArcgisError({
    required this.code,
    required this.errorMessage,
    required this.errorDomain,
    this.additionalMessage,
    this.innerErrorMessage,
  });

  final int code;

  final String errorMessage;

  final String? additionalMessage;

  final String? innerErrorMessage;

  final ErrorDomain errorDomain;

  static ArcgisError? fromJson(dynamic json) {
    if (json is Map<dynamic, dynamic>) {
      return ArcgisError(
        code: json['code'] ?? unknownError,
        errorMessage: json['errorMessage'] ?? 'Unknown error',
        errorDomain: ErrorDomain.fromValue(
            json['errorDomain'] ?? ErrorDomain.unknown.value),
        additionalMessage: json['additionalMessage'],
        innerErrorMessage: json['innerErrorMessage'],
      );
    }
    return null;
  }

  @override
  String toString() {
    return 'ArcgisError{code: $code, errorMessage: $errorMessage, additionalMessage: $additionalMessage, innerErrorMessage: $innerErrorMessage, errorDomain: $errorDomain}';
  }
}
