library arcgis_maps_flutter;

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:arcgis_maps_flutter/src/data/field_type.dart';
import 'package:arcgis_maps_flutter/src/layers/base_tile_layer.dart';
import 'package:arcgis_maps_flutter/src/layers/layer_updates.dart';
import 'package:arcgis_maps_flutter/src/mapping/basemap_type_options.dart';
import 'package:arcgis_maps_flutter/src/mapping/view/location_display_impl.dart';
import 'package:arcgis_maps_flutter/src/maps_object.dart';
import 'package:arcgis_maps_flutter/src/symbology/marker_updates.dart';
import 'package:arcgis_maps_flutter/src/symbology/polygon_updates.dart';
import 'package:arcgis_maps_flutter/src/symbology/polyline_updates.dart';
import 'package:arcgis_maps_flutter/src/toolkit/time_slider/flutter_xlider.dart';
import 'package:arcgis_maps_flutter/src/utils/elevation_source.dart';
import 'package:arcgis_maps_flutter/src/utils/geometry_type.dart';
import 'package:arcgis_maps_flutter/src/utils/json.dart';
import 'package:arcgis_maps_flutter/src/utils/layers.dart';
import 'package:arcgis_maps_flutter/src/utils/markers.dart';
import 'package:arcgis_maps_flutter/src/utils/polygons.dart';
import 'package:arcgis_maps_flutter/src/utils/polyline.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:arcgis_maps_flutter/src/method_channel/arcgis_flutter_platform.dart';
import 'package:arcgis_maps_flutter/src/method_channel/authentication/authentication_manager_flutter_platform.dart';
import 'package:arcgis_maps_flutter/src/method_channel/map/arcgis_maps_flutter_platform.dart';
import 'package:arcgis_maps_flutter/src/method_channel/scene/arcgis_scene_flutter_platform.dart';
import 'package:arcgis_maps_flutter/src/method_channel/geometry/geometry_engine_flutter_platform.dart';
import 'package:arcgis_maps_flutter/src/method_channel/geometry/coordinate_formatter_flutter_platform.dart';
import 'package:arcgis_maps_flutter/src/method_channel/map/map_event.dart';
import 'package:arcgis_maps_flutter/src/method_channel/tasks/geocode/locator_task_flutter_platform.dart';
import 'package:arcgis_maps_flutter/src/method_channel/tasks/network_analysis/route_task_flutter_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'package:jiffy/jiffy.dart';


part 'src/unit_system.dart';

part 'src/arcgis_error.dart';
part 'src/arcgis_runtime_environment.dart';
part 'src/arcgis_authentication_manager.dart';

part 'src/arcgisservices/level_of_detail.dart';
part 'src/arcgisservices/tile_info.dart';

part 'src/data/tile_key.dart';

part 'src/geometry/ags_polygon.dart';
part 'src/geometry/ags_polyline.dart';
part 'src/geometry/ags_envelope.dart';
part 'src/geometry/ags_point.dart';
part 'src/geometry/coordinate_formatter.dart';
part 'src/geometry/spatial_references.dart';
part 'src/geometry/geometry.dart';
part 'src/geometry/geometry_type.dart';
part 'src/geometry/geometry_engine.dart';
part 'src/geometry/geodetic_distance_result.dart';

part 'src/layers/layer.dart';
part 'src/layers/service_image_tiled_layer.dart';
part 'src/layers/feature_layer.dart';
part 'src/layers/group_layer.dart';

part 'src/layers/legend_info.dart';
part 'src/layers/legend_info_result.dart';
part 'src/layers/map_image_layer.dart';
part 'src/layers/tiled_layer.dart';
part 'src/layers/vector_tile_layer.dart';
part 'src/layers/wms_layer.dart';
part 'src/layers/time_aware_layer_info.dart';

part 'src/location/location.dart';

part 'src/mapping/viewpoint.dart';
part 'src/mapping/camera.dart';
part 'src/mapping/elevation_source.dart';
part 'src/mapping/geo_element.dart';
part 'src/mapping/surface.dart';
part 'src/mapping/arcgis_tiled_elevation_source.dart';
part 'src/mapping/time_extent.dart';
part 'src/mapping/time_value.dart';
part 'src/mapping/viewpoint_type.dart';
part 'src/mapping/arcgis_map.dart';
part 'src/mapping/view/auto_pan_mode.dart';
part 'src/mapping/view/identify_layer_result.dart';
part 'src/mapping/view/layers_changed_listener.dart';
part 'src/mapping/view/location_display.dart';
part 'src/mapping/view/time_extent_changed_listener.dart';
part 'src/mapping/view/viewpoint_changed_listener.dart';

part 'src/ogc/wms/wms_layer_dimension.dart';
part 'src/ogc/wms/wms_layer_info.dart';
part 'src/ogc/wms/wms_layer_style.dart';
part 'src/ogc/wms/wms_layer_time_dimension.dart';
part 'src/ogc/wms/wms_service_info.dart';
part 'src/ogc/wms/wms_service.dart';
part 'src/ogc/wms/wms_version.dart';

part 'src/portal/portal.dart';
part 'src/portal/portal_item.dart';

part 'src/loadable/loadable.dart';

part 'src/mapping/view/map/arcgis_map_view.dart';
part 'src/mapping/view/map/arcgis_map_controller.dart';
part 'src/mapping/view/interaction_options.dart';
part 'src/mapping/view/scalebar_configuration.dart';
part 'src/mapping/view/zoom_level.dart';

part 'src/mapping/arcgis_scene.dart';
part 'src/mapping/view/scene/arcgis_scene_controller.dart';
part 'src/mapping/view/scene/arcgis_scene_view.dart';

part 'src/security/credential.dart';

part 'src/symbology/bitmap_descriptor.dart';
part 'src/symbology/marker.dart';
part 'src/symbology/polygon.dart';
part 'src/symbology/polyline.dart';
part 'src/symbology/symbol.dart';
part 'src/symbology/symbol_visibility_filter.dart';

part 'src/tasks/geocode/geocode_result.dart';
part 'src/tasks/geocode/locator_attribute.dart';
part 'src/tasks/geocode/locator_info.dart';
part 'src/tasks/geocode/locator_task.dart';

part 'src/tasks/network_analysis/attribute_parameter_value.dart';
part 'src/tasks/network_analysis/cost_attribute.dart';
part 'src/tasks/network_analysis/direction_event.dart';
part 'src/tasks/network_analysis/direction_maneuver.dart';
part 'src/tasks/network_analysis/direction_message.dart';
part 'src/tasks/network_analysis/restriction_attribute.dart';
part 'src/tasks/network_analysis/route.dart';
part 'src/tasks/network_analysis/route_parameters.dart';
part 'src/tasks/network_analysis/route_result.dart';
part 'src/tasks/network_analysis/route_task.dart';
part 'src/tasks/network_analysis/route_task_info.dart';
part 'src/tasks/network_analysis/route_types.dart';
part 'src/tasks/network_analysis/stop.dart';
part 'src/tasks/network_analysis/travel_mode.dart';

part 'src/toolkit/compass.dart';
part 'src/toolkit/time_slider/time_slider.dart';
part 'src/toolkit/time_slider/time_slider_data_provider.dart';

part 'src/data/query/query_parmeters.dart';
part 'src/data/layer/layer_content.dart';
part 'src/data/measure/measure_actions.dart';
part 'src/feature/feature.dart';
part 'src/service_table/service_table.dart';