part of arcgis_maps_flutter;

@immutable
class WmsService {
  const WmsService();

  Future<WmsServiceInfo?> getServiceInfo(
    String url, {
    WmsVersion? version,
  }) async {
    var uri = Uri.tryParse(url);
    if (uri == null) {
      return null;
    }
    final Map<String, String> query = Map.of(uri.queryParameters);

    if (!query.containsKey('service')) {
      query['service'] = 'WMS';
    }
    if (!query.containsKey('request')) {
      query['request'] = 'GetCapabilities';
    }
    if (version != null && !query.containsKey('version')) {
      query['version'] = version.stringValue;
    }

    uri = uri.replace(queryParameters: query);

    var response = await http.get(uri);
    dynamic json = await _parseJson(response.body);

    return _parseServiceInfo(json);
  }

  WmsServiceInfo? _parseServiceInfo(dynamic json) {
    var capabilitiesJson = json['WMS_Capabilities'];
    if (capabilitiesJson == null) {
      return null;
    }

    var serviceJson = capabilitiesJson['Service'];
    var capabilityJson = capabilitiesJson['Capability'];
    if (serviceJson == null || capabilityJson == null) {
      return null;
    }
    final name = _getValue<String>(serviceJson['Name']);
    final title = _getValue<String>(serviceJson['Title']);
    final serviceDescription =
        _getValue<String?>(serviceJson['Abstract']) ?? '';
    final version = _getVersion(capabilitiesJson);

    final layersInfo = _getLayersInfo(capabilityJson);

    final keywords = _getServiceKeywords(serviceJson);
    final imageFormats = _getImageFormats(capabilityJson);

    return WmsServiceInfo(
      name: name,
      title: title,
      serviceDescription: serviceDescription,
      version: version,
      layersInfo: layersInfo,
      keywords: keywords,
      imageFormats: imageFormats,
    );
  }

  static T _getValue<T>(dynamic json, {String key = '\$t'}) {
    return json[key] as T;
  }

  static WmsVersion _getVersion(dynamic json) {
    var versionStr = json["version"]?.toString();
    if (versionStr == null) {
      return WmsVersion.v1_1_0;
    }
    switch (versionStr) {
      case "1.1.1":
        return WmsVersion.v1_1_1;
      case "1.3.0":
        return WmsVersion.v1_3_0;
      default:
        return WmsVersion.v1_1_0;
    }
  }

  static List<String> _getServiceKeywords(dynamic json) {
    final keywords = json['KeywordList'];
    if (keywords != null) {
      return keywords as List<String>;
    }
    return const [];
  }

  static List<ImageFormat> _getImageFormats(dynamic json) {
    var formatsJson = json['Request']?['GetMap']?['Format'];

    if (formatsJson is List<dynamic>) {
      final formats = <ImageFormat>[];
      for (final format in formatsJson) {
        switch (format) {
          case 'image/png':
            formats.add(ImageFormat.png);
            break;
          case 'image/png; mode=8bit':
            formats.add(ImageFormat.png8);
            break;
          case 'image/png; mode=24bit':
            formats.add(ImageFormat.png24);
            break;
          case 'image/png; mode=32bit':
            formats.add(ImageFormat.png32);
            break;
          case 'image/jpeg':
            formats.add(ImageFormat.jpg);
            break;
          case 'image/bmp':
            formats.add(ImageFormat.bmp);
            break;
          case 'image/gif':
            formats.add(ImageFormat.gif);
            break;
          case 'image/tiff':
            formats.add(ImageFormat.tiff);
            break;
          default:
            formats.add(ImageFormat.unknown);
            break;
        }
      }
      return formats;
    }

    return const [];
  }

  static List<WmsLayerInfo> _getLayersInfo(dynamic json) {
    final jsonLayers = json['Layer'];
    if (jsonLayers != null) {}
    return const [];
  }

// static WmsLayerInfo _getLayerInfo(dynamic json){
//
// }

  // static List<SpatialReference> _getSpatialReferences(dynamic json) {
  //
  // }
  //
  // static SpatialReference _getSpatialReference(dynamic json){
  //   final strValue =
  // }
}

Object _parseAndDecode(String response) {
  final Xml2Json xml2Json = Xml2Json();
  xml2Json.parse(response);
  var jsonString = xml2Json.toGData();
  return jsonDecode(jsonString);
}

Future<Object> _parseJson(String text) {
  return compute(_parseAndDecode, text);
}
