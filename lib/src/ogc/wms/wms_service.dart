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
    final name = _getValue(serviceJson['Name']);
    final title = _getValue(serviceJson['Title']);
    final serviceDescription = _getValueOrNull(serviceJson['Abstract']) ?? '';
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

  static String _getValue(dynamic json, {String key = '\$t'}) {
    return _getValueOrNull(json, key: key)!;
  }

  static String? _getValueOrNull(dynamic json, {String key = '\$t'}) {
    if (json == null) {
      return null;
    }

    if (json is String) {
      return json;
    }

    return json[key] as String?;
  }

  static int _getIntValue(
    dynamic json, {
    String key = '\$t',
    int defaultValue = 0,
  }) {
    final str = _getValueOrNull(json, key: key);
    if (str == null) {
      return defaultValue;
    }
    return int.tryParse(str) ?? defaultValue;
  }

  static bool _getBoolValue(
    dynamic json, {
    String key = '\$t',
    bool defaultValue = false,
  }) {
    final value = _getValueOrNull(json, key: key);
    if (value == null) {
      return defaultValue;
    }
    var result = int.tryParse(value);
    return result == null ? defaultValue : result != 0;
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
    if (keywords is List<dynamic>) {
      return keywords.cast<String>();
    }
    return const [];
  }

  static List<ImageFormat> _getImageFormats(dynamic json) {
    var formatsJson = json['Request']?['GetMap']?['Format'];

    if (formatsJson is List<dynamic>) {
      final formats = <ImageFormat>{};
      for (final format in formatsJson) {
        formats.add(_getImageFormat(_getValue(format)));
      }
      return formats.toList();
    }

    return const [];
  }

  static ImageFormat _getImageFormat(String mineType) {
    switch (mineType) {
      case 'image/png':
        return ImageFormat.png;
      case 'image/png; mode=8bit':
        return ImageFormat.png8;
      case 'image/png; mode=24bit':
        return ImageFormat.png24;
      case 'image/png; mode=32bit':
        return ImageFormat.png32;
      case 'image/jpeg':
        return ImageFormat.jpg;
      case 'image/bmp':
        return ImageFormat.bmp;
      case 'image/gif':
        return ImageFormat.gif;
      case 'image/tiff':
        return ImageFormat.tiff;
      default:
        return ImageFormat.unknown;
    }
  }

  static List<WmsLayerInfo> _getLayersInfo(dynamic json) {
    final jsonLayers = json['Layer'];
    if (jsonLayers != null) {
      if (jsonLayers is List<dynamic>) {
        var arr = <WmsLayerInfo>[];
        for (final layer in jsonLayers) {
          arr.add(_getLayerInfo(layer));
        }
        return arr;
      }
      return [
        _getLayerInfo(jsonLayers),
      ];
    }
    return const [];
  }

  static WmsLayerInfo _getLayerInfo(dynamic json) {
    final title = _getValue(json['Title']);
    final description = _getValueOrNull(json['Abstract']) ?? '';
    final spatialReferences = _getSpatialReferences(json['CRS']);
    final extent = _getBoundingBox(json['BoundingBox']);
    final fixedImageHeight = _getValueOrNull(json['fixedHeight']);
    final fixedImageWidth = _getValueOrNull(json['fixedWidth']);
    final keywords = _getServiceKeywords(json);
    final name = _getValueOrNull(json['Name']) ?? '';
    final isOpaque = _getBoolValue(json['opaque']);
    final isQueryable = _getBoolValue(json['queryable']);
    final subLayerInfos = _getLayersInfo(json);
    final styles = _getStyles(json);
    final dimensions = _getDimensions(json);

    return WmsLayerInfo(
      title: title,
      layerDescription: description,
      extent: extent,
      fixedImageHeight:
          fixedImageHeight == null ? 0 : int.parse(fixedImageHeight),
      fixedImageWidth: fixedImageWidth == null ? 0 : int.parse(fixedImageWidth),
      keywords: keywords,
      name: name,
      isOpaque: isOpaque,
      isQueryable: isQueryable,
      spatialReferences: spatialReferences,
      sublayerInfos: subLayerInfos,
      styles: styles,
      dimensions: dimensions,
    );
  }

  static Envelope? _getBoundingBox(dynamic json) {
    if (json == null) {
      return null;
    }

    if (json is List<dynamic>) {
      if (json.isEmpty) {
        return null;
      }
      json = json.first;
    }

    final spatialReference = _getSpatialReferenceFromString(json['CRS']);
    final minx = _getValue(json['minx']);
    final miny = _getValue(json['miny']);
    final maxx = _getValue(json['maxx']);
    final maxy = _getValue(json['maxy']);
    return Envelope(
      xMin: double.parse(minx),
      yMin: double.parse(miny),
      xMax: double.parse(maxx),
      yMax: double.parse(maxy),
      spatialReference: spatialReference,
    );
  }

  static List<WmsLayerStyle> _getStyles(dynamic json) {
    final styles = json['Style'];
    if (styles is List<dynamic>) {
      var arr = <WmsLayerStyle>[];
      for (final style in styles) {
        arr.add(_getStyle(style));
      }
      return arr;
    } else if (styles != null) {
      return [
        _getStyle(styles),
      ];
    }

    return const [];
  }

  static WmsLayerStyle _getStyle(dynamic json) {
    final name = _getValue(json['Name']);
    final title = _getValue(json['Title']);
    final description = _getValueOrNull(json['Abstract']);
    final legendUrl = _getLegendUrl(json['LegendURL']);
    return WmsLayerStyle(
      name: name,
      title: title,
      description: description ?? '',
      legendUrl: legendUrl,
    );
  }

  static WmsLegendUrl? _getLegendUrl(dynamic json) {
    if (json == null) {
      return null;
    }
    final url = json['OnlineResource']?['xlink:href']?.toString();
    if(url == null){
      return null;
    }
    final imageFormat = _getImageFormat(_getValue(json['Format']));
    final width = _getIntValue(json['width']);
    final height = _getIntValue(json['height']);
    return WmsLegendUrl(
      url: url,
      imageFormat: imageFormat,
      width: width,
      height: height,
    );
  }

  static List<WmsLayerDimension> _getDimensions(dynamic json) {
    final dimensions = json['Dimension'];
    if (dimensions is List<dynamic>) {
      var arr = <WmsLayerDimension>[];
      for (final dimension in json) {
        arr.add(_getDimension(dimension));
      }
      return arr;
    } else if (dimensions != null) {
      return [
        _getDimension(dimensions),
      ];
    }
    return const [];
  }

  static WmsLayerDimension _getDimension(dynamic json) {
    final name = _getValue(json['name']);
    final units = _getValue(json['units']);
    final unitSymbol = _getValueOrNull(json['unitSymbol']);
    final defaultValue = _getValueOrNull(json['default']);
    final multipleValues = _getBoolValue(json['multipleValues']);
    final nearestValue = _getBoolValue(json['nearestValue']);
    final current = _getBoolValue(json['nearestValue']);
    final extent = _getValueOrNull(json) ?? '';

    return WmsLayerDimension(
      name: name,
      units: units,
      unitSymbol: unitSymbol,
      defaultValue: defaultValue,
      multipleValues: multipleValues,
      nearestValue: nearestValue,
      current: current,
      extent: extent,
    );
  }

  static List<SpatialReference> _getSpatialReferences(dynamic json) {
    if (json is List<dynamic>) {
      var spatialReferences = <SpatialReference>[];
      for (final spatialReference in json) {
        spatialReferences.add(_getSpatialReference(spatialReference));
      }
      return spatialReferences;
    }
    return const [];
  }

  static SpatialReference _getSpatialReference(dynamic json) {
    final strValue = _getValue(json).replaceFirst('EPSG:', '');
    return _getSpatialReferenceFromString(strValue);
  }

  static SpatialReference _getSpatialReferenceFromString(String value) {
    value = value.replaceFirst('EPSG:', '');
    if (value == 'CRS:84') {
      return SpatialReference.wgs84();
    }
    return SpatialReference.fromWkId(int.parse(value));
  }
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
