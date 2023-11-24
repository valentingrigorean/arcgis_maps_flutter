import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/layers/base_tile_layer.dart';
import 'package:flutter_test/flutter_test.dart';

class BaseTileLayerMock extends BaseTileLayer {
  BaseTileLayerMock.fromUrl({
    LayerId? layerId,
    required super.url,
    super.isVisible,
    super.opacity,
  }) : super.fromUrl(
          layerId: layerId ?? LayerId(url),
          type: 'mock',
        );

  BaseTileLayerMock.fromPortalItem({
    required super.layerId,
    required super.portalItem,
    super.isVisible,
    super.opacity,
  }) : super.fromPortalItem(
          type: 'mock',
        );

  @override
  Layer clone() {
    throw 'Not impl';
  }
}

void main() {
  test('validate toJson with Url', () {
    var baseTileLayer = BaseTileLayerMock.fromUrl(
      layerId: const LayerId('layerId'),
      url: 'url',
    );

    final json = baseTileLayer.toJson();

    expect(json['url'], 'url');
    expect(json['layerId'], 'layerId');
    assert(json['portalItem'] == null);
  });

  test('validate toJson with portalItem', () {
    var baseTileLayer = BaseTileLayerMock.fromPortalItem(
        layerId: const LayerId('layerId'),
        portalItem: PortalItem(
          portal: Portal.arcGISOnline(connection: PortalConnection.anonymous),
          itemId: 'itemId',
        ));

    final json = baseTileLayer.toJson();

    assert(json['url'] == null);
    expect(json['layerId'], 'layerId');
    assert(json['credential'] == null);
    assert(json['portalItem'] != null);
  });
}
