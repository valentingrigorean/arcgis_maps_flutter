#import "ArcgisMapsFlutterPlugin.h"
#if __has_include(<arcgis_maps_flutter/arcgis_maps_flutter-Swift.h>)
#import <arcgis_maps_flutter/arcgis_maps_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "arcgis_maps_flutter-Swift.h"
#endif

@implementation ArcgisMapsFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftArcgisMapsFlutterPlugin registerWithRegistrar:registrar];
}
@end
