part of arcgis_maps_flutter;

class ArcGISAuthenticationManager {
  ArcGISAuthenticationManager._();

  static  Future<void> setPersistence(String serviceContext,String username, String password) =>
      AuthenticationManagerFlutterPlatform.instance.setPersistence(serviceContext, username, password);
}

