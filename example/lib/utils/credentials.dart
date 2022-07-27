import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Credential snlaCredentials = UserCredential.createUserCredential(
  username: dotenv.env['snla_maps_arcgis_username'] ?? '',
  password: dotenv.env['snla_maps_arcgis_password'] ?? '',
);

final geodataCredentials = UserCredential.createUserCredential(
  username: dotenv.env['username'] ?? '',
  password: dotenv.env['password'] ?? '',
);
