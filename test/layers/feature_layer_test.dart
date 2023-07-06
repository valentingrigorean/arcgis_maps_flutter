import 'package:arcgis_maps_flutter/arcgis_maps_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Clone with url', () {
    final featureLayer = FeatureLayer.fromUrl(
      'url',
      isVisible: false,
      opacity: 0.5,
    );

    expect(featureLayer, featureLayer.clone());
    assert(
      featureLayer !=
          featureLayer.copyWith(
            isVisibleParam: true,
            opacityParam: 1,
          ),
    );
  });

  test('Clone with PortalItem', () {
    final featureLayer = FeatureLayer.fromPortalItem(
      layerId: const LayerId('layerId'),
      portalItemLayerId: 0,
      portalItem: PortalItem(
        portal: Portal.arcGISOnline(
          connection: PortalConnection.anonymous,
        ),
        itemId: 'itemId',
      ),
      isVisible: false,
      opacity: 0.5,
    );

    expect(featureLayer, featureLayer.clone());
    assert(
      featureLayer !=
          featureLayer.copyWith(
            isVisibleParam: true,
            opacityParam: 1,
          ),
    );
  });
}
