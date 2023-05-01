part of arcgis_maps_flutter;


@immutable
class ArcgisError implements Exception {
  const ArcgisError({
    required this.errorMessage,
    this.nativeStackTrace,
    this.additionalMessage,
    this.innerErrorMessage,
  });

  final String errorMessage;

  final String? nativeStackTrace;

  final String? additionalMessage;

  final String? innerErrorMessage;

  static ArcgisError? fromJson(dynamic json) {
    if (json is Map<dynamic, dynamic>) {
      return ArcgisError(
        errorMessage: json['errorMessage'] ?? 'Unknown error',
        nativeStackTrace: json['nativeStackTrace'],
        additionalMessage: json['additionalMessage'],
        innerErrorMessage: json['innerErrorMessage'],
      );
    }
    return null;
  }

  @override
  String toString() {
    return 'ArcgisError{errorMessage: $errorMessage, additionalMessage: $additionalMessage, innerErrorMessage: $innerErrorMessage}';
  }
}
