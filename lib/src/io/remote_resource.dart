import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/arcgis_native_object.dart';

mixin RemoteResource on ArcgisNativeObject {

  Future<String?> get url async {
    return await invokeMethod<String>('remoteResource#getUrl');
  }

  Future<Credential?> get credential async {
    final result = await invokeMethod('remoteResource#getCredential');
    if (result == null) {
      return null;
    }
    return Credential.fromJson(result);
  }

  Future<void> setCredential(Credential? credential) async {
    await invokeMethod('remoteResource#setCredential', credential?.toJson());
  }
}
