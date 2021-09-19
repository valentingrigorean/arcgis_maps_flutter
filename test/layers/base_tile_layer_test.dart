import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:arcgis_maps_flutter/src/layers/base_tile_layer.dart';
import 'package:flutter_test/flutter_test.dart';

class BaseTileLayerMock extends BaseTileLayer {
  BaseTileLayerMock.fromUrl({
    LayerId? layerId,
    required String url,
    Credential? credential,
    bool isVisible = true,
    double opacity = 1,
  }) : super.fromUrl(
          layerId: layerId ?? LayerId(url),
          url: url,
          type: 'mock',
          credential: credential,
          isVisible: isVisible,
          opacity: opacity,
        );

  BaseTileLayerMock.fromPortalItem({
    required LayerId layerId,
    required PortalItem portalItem,
    bool isVisible = true,
    double opacity = 1,
  }) : super.fromPortalItem(
          layerId: layerId,
          type: 'mock',
          portalItem: portalItem,
          isVisible: isVisible,
          opacity: opacity,
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
      credential: Credential.creteUserCredential(
        username: 'username',
        password: 'password',
      ),
    );

    final json = baseTileLayer.toJson();

    expect(json['url'], 'url');
    expect(json['layerId'], 'layerId');
    assert(json['credential'] != null);
    assert(json['portalItem'] == null);
  });

  test('validate toJson with portalItem', () {
    var baseTileLayer = BaseTileLayerMock.fromPortalItem(
        layerId: const LayerId('layerId'),
        portalItem: PortalItem(
          portal: Portal.arcGISOnline(withLoginRequired: false),
          itemId: 'itemId',
        ));

    final json = baseTileLayer.toJson();

    assert(json['url'] == null);
    expect(json['layerId'], 'layerId');
    assert(json['credential'] == null);
    assert(json['portalItem'] != null);
  });
}
