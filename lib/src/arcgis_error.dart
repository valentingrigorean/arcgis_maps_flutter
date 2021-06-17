part of arcgis_maps_flutter;

const int unknownError = -23123;

@immutable
class ArcgisError implements Exception {
  const ArcgisError({
    required this.code,
    required this.errorMessage,
  });

  final int code;

  final String errorMessage;

  static ArcgisError? fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return ArcgisError(
        code: json['code'] ?? unknownError,
        errorMessage: json['errorMessage'] ?? 'Unknown error',
      );
    }
    return null;
  }
}
