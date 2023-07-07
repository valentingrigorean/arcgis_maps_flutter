import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

var _didSetGeodataCredentials = false;
var _didSetArcgisCredentials = false;

Future<void> setArcgisCredentials() async {
  if (_didSetArcgisCredentials) {
    return;
  }
  await ArcGISCredentialStore().addCredential(
    url: 'https://www.arcgis.com/',
    username: dotenv.env['username'] ?? '',
    password: dotenv.env['password'] ?? '',
  );
  _didSetArcgisCredentials = true;
}

Future<void> setGeodataCredentials() async {
  if (_didSetGeodataCredentials) {
    return;
  }
  await ArcGISCredentialStore().addCredential(
    url: 'https://services.geodataonline.no/arcgis/rest/info?f=json',
    username: dotenv.env['geodataCredentialsUsername'] ?? '',
    password: dotenv.env['geodataCredentialsPassword'] ?? '',
  );
  _didSetGeodataCredentials = true;
}
