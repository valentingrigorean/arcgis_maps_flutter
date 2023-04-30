part of arcgis_maps_flutter;

enum LicenseStatus {
  invalid,
  expired,
  loginRequired,
  valid,
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
