part of arcgis_maps_flutter;

enum LicenseStatus {
  invalid(0),
  expired(1),
  loginRequired(2),
  valid(3);

  const LicenseStatus(this.value);

  factory LicenseStatus.fromValue(int value) {
    return LicenseStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => LicenseStatus.invalid,
    );
  }

  final int value;
}

class ArcGISEnvironment {
  ArcGISEnvironment._();

  static Future<void> setApiKey(String apiKey) =>
      ArcgisFlutterPlatform.instance.setApiKey(apiKey);

  static Future<String> getApiKey() =>
      ArcgisFlutterPlatform.instance.getApiKey();

  static Future<LicenseStatus> setLicense(String licenseKey) =>
      ArcgisFlutterPlatform.instance.setLicense(licenseKey);

  static Future<String> getAPIVersion() =>
      ArcgisFlutterPlatform.instance.getApiVersion();
}
