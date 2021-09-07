package com.valentingrigorean.arcgis_maps_flutter;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.icu.text.SimpleDateFormat;
import android.util.DisplayMetrics;
import android.util.TypedValue;

import com.esri.arcgisruntime.UnitSystem;
import com.esri.arcgisruntime.geometry.Point;
import com.esri.arcgisruntime.geometry.PointCollection;
import com.esri.arcgisruntime.geometry.Polygon;
import com.esri.arcgisruntime.geometry.Polyline;
import com.esri.arcgisruntime.geometry.SpatialReference;
import com.esri.arcgisruntime.mapping.ArcGISMap;
import com.esri.arcgisruntime.mapping.ArcGISScene;
import com.esri.arcgisruntime.mapping.ArcGISTiledElevationSource;
import com.esri.arcgisruntime.mapping.Basemap;
import com.esri.arcgisruntime.mapping.ElevationSource;
import com.esri.arcgisruntime.mapping.GeoElement;
import com.esri.arcgisruntime.mapping.Surface;
import com.esri.arcgisruntime.mapping.Viewpoint;
import com.esri.arcgisruntime.mapping.view.Camera;
import com.esri.arcgisruntime.mapping.view.IdentifyLayerResult;
import com.esri.arcgisruntime.mapping.view.LocationDisplay;
import com.esri.arcgisruntime.mapping.view.MapView;
import com.esri.arcgisruntime.portal.Portal;
import com.esri.arcgisruntime.portal.PortalItem;
import com.esri.arcgisruntime.security.Credential;
import com.esri.arcgisruntime.security.UserCredential;
import com.esri.arcgisruntime.symbology.SimpleLineSymbol;
import com.esri.arcgisruntime.symbology.SimpleMarkerSymbol;
import com.valentingrigorean.arcgis_maps_flutter.data.FieldTypeFlutter;
import com.valentingrigorean.arcgis_maps_flutter.map.BaseGraphicController;
import com.valentingrigorean.arcgis_maps_flutter.map.BitmapDescriptorFactory;
import com.valentingrigorean.arcgis_maps_flutter.map.FlutterLayer;
import com.valentingrigorean.arcgis_maps_flutter.map.MarkerController;
import com.valentingrigorean.arcgis_maps_flutter.map.PolygonController;
import com.valentingrigorean.arcgis_maps_flutter.map.PolylineController;
import com.valentingrigorean.arcgis_maps_flutter.map.ScreenLocationData;
import com.valentingrigorean.arcgis_maps_flutter.toolkit.scalebar.Scalebar;
import com.valentingrigorean.arcgis_maps_flutter.toolkit.scalebar.style.Style;

import java.util.ArrayList;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Convert {
    private static final SimpleDateFormat ISO8601Format = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX");

    public static Scalebar.Alignment toScaleBarAlignment(int rawValue) {
        switch (rawValue) {
            case 0:
                return Scalebar.Alignment.LEFT;
            case 1:
                return Scalebar.Alignment.RIGHT;
            case 2:
                return Scalebar.Alignment.CENTER;
            default:
                throw new IllegalStateException("Unexpected value: " + rawValue);
        }
    }

    public static Style toScaleBarStyle(int rawValue) {
        switch (rawValue) {
            case 0:
                return Style.LINE;
            case 1:
                return Style.BAR;
            case 2:
                return Style.GRADUATED_LINE;
            case 3:
                return Style.ALTERNATING_BAR;
            case 4:
                return Style.DUAL_UNIT_LINE;
            case 5:
                return Style.DUAL_UNIT_LINE_NAUTICAL_MILE;
            default:
                throw new IllegalStateException("Unexpected value: " + rawValue);
        }
    }

    public static UnitSystem toUnitSystem(int rawValue) {
        switch (rawValue) {
            case 0:
                return UnitSystem.IMPERIAL;
            case 1:
                return UnitSystem.METRIC;
            default:
                throw new IllegalStateException("Unexpected value: " + rawValue);
        }
    }


    public static Point toPoint(Object o) {
        final Map<?, ?> data = toMap(o);
        final double x = toDouble(data.get("x"));
        final double y = toDouble(data.get("y"));

        Double z = null;
        Double m = null;

        if (data.containsKey("z"))
            z = toDouble(data.get("z"));


        if (data.containsKey("m"))
            m = toDouble(data.get("m"));

        SpatialReference spatialReference = toSpatialReference(data.get("spatialReference"));

        if (z != null && m != null && spatialReference != null) {
            return Point.createWithM(x, y, z, m, spatialReference);
        }

        if (m != null) {
            if (spatialReference != null) {
                return Point.createWithM(x, y, m, spatialReference);
            }
            if (z != null) {
                return Point.createWithM(x, y, z, m);
            }
            return Point.createWithM(x, y, m);
        }

        if (z == null && spatialReference == null && m == null)
            return new Point(x, y);
        if (spatialReference == null && z != null)
            return new Point(x, y, z);
        if (spatialReference != null && z == null)
            return new Point(x, y, spatialReference);
        return new Point(x, y, z, spatialReference);
    }

    public static Viewpoint toViewPoint(Object o) {
        final Map<?, ?> data = toMap(o);
        final double scale = toDouble(data.get("scale"));
        final Point targetGeometry = toPoint(data.get("targetGeometry"));
        return new Viewpoint(targetGeometry, scale);
    }

    public static Credential toCredentials(Object o) {
        final Map<?, ?> map = toMap(o);

        final String type = (String) map.get("type");
        switch (type) {
            case "UserCredential":
                final Object referer = map.get("referer");
                final Object token = map.get("token");
                if (token != null) {
                    return UserCredential.createFromToken((String) token, (String) referer);
                }
                final String username = (String) map.get("username");
                final String password = (String) map.get("password");
                return new UserCredential(username, password, (String) referer);
            default:
                throw new UnsupportedOperationException("Not implemented.");
        }
    }

    public static Camera toCamera(Object o) {
        final Map<?, ?> data = toMap(o);

        double heading = toDouble(data.get("heading"));
        double pitch = toDouble(data.get("pitch"));
        double roll = toDouble(data.get("roll"));
        if (data.containsKey("cameraLocation")) {
            Point point = toPoint(data.get("cameraLocation"));

            return new Camera(point, heading, pitch, roll);
        }


        double latitude = toDouble(data.get("latitude"));
        double longitude = toDouble(data.get("longitude"));
        double altitude = toDouble(data.get("altitude"));

        return new Camera(latitude, longitude, altitude, heading, pitch, roll);
    }

    public static ArcGISScene toScene(Object o) {
        final Map<?, ?> data = toMap(o);

        if (data.containsKey("json")) {
            return ArcGISScene.fromJson((String) data.get("json"));
        }

        final Basemap basemap = createBasemapFromType((String) data.get("basemap"));

        return new ArcGISScene(basemap);
    }

    public static Surface toSurface(Object o) {
        final Map<?, ?> data = toMap(o);

        float alpha = toFloat(data.get("alpha"));
        boolean isEnabled = toBoolean(data.get("isEnabled"));

        List<ElevationSource> elevationSources = null;
        if (data.containsKey("elevationSources")) {
            elevationSources = toElevationSourceList((List<Object>) data.get("elevationSources"));
        }

        Surface surface;
        if (elevationSources != null) {
            surface = new Surface(elevationSources);
        } else {
            surface = new Surface();
        }
        surface.setEnabled(isEnabled);
        surface.setOpacity(alpha);

        if (data.containsKey("elevationExaggeration")) {
            surface.setElevationExaggeration(toFloat(data.get("elevationExaggeration")));
        }

        return surface;
    }

    public static ArcGISMap toArcGISMap(Object o) {
        final Map<?, ?> data = toMap(o);
        final Object baseMap = data.get("baseMap");
        if (baseMap != null) {
            return new ArcGISMap(createBasemapFromType((String) baseMap));
        }
        final Object baseLayer = data.get("baseLayer");
        if (baseLayer != null) {
            final FlutterLayer layer = new FlutterLayer(toMap(baseLayer));
            return new ArcGISMap(new Basemap(layer.createLayer()));
        }

        final Object portalItem = data.get("portalItem");
        if (portalItem != null) {
            return new ArcGISMap(toPortalItem(portalItem));
        }

        final Map<?, ?> basemapTypeOptions = toMap(data.get("basemapTypeOptions"));
        if (basemapTypeOptions != null) {
            final Basemap.Type type = getBasemapType((String) basemapTypeOptions.get("basemapType"));
            final Double latitude = toDouble(basemapTypeOptions.get("latitude"));
            final Double longitude = toDouble(basemapTypeOptions.get("longitude"));
            final int levelOfDetail = toInt(basemapTypeOptions.get("levelOfDetail"));
            return new ArcGISMap(type, latitude, longitude, levelOfDetail);
        }


        return new ArcGISMap();
    }

    public static void interpretMapViewOptions(Object o, MapView mapView) {
        final Map<?, ?> data = toMap(o);
        final Object interactionOptions = data.get("interactionOptions");
        if (interactionOptions != null) {
            interpretInteractionOptions(interactionOptions, mapView);
        }
        final Object myLocationEnabled = data.get("myLocationEnabled");
        if (myLocationEnabled != null) {
            final Boolean enabled = toBoolean(myLocationEnabled);
            mapView.getLocationDisplay().setShowLocation(enabled);
            if (enabled) {
                mapView.getLocationDisplay().startAsync();
            } else {
                mapView.getLocationDisplay().stop();
            }
        }

        final Object autoPanMode = data.get("autoPanMode");
        if (autoPanMode != null) {
            mapView.getLocationDisplay().setAutoPanMode(Convert.toAutoPanMode(autoPanMode));
        }

        final Object wanderExtentFactor = data.get("wanderExtentFactor");
        if (wanderExtentFactor != null) {
            mapView.getLocationDisplay().setWanderExtentFactor(toFloat(wanderExtentFactor));
        }
    }


    public static Viewpoint.Type toViewpointType(Object o) {
        switch (toInt(o)) {
            case 0:
                return Viewpoint.Type.CENTER_AND_SCALE;
            case 1:
                return Viewpoint.Type.BOUNDING_GEOMETRY;
            default:
                return Viewpoint.Type.UNKNOWN;
        }
    }

    public static void interpretMarkerController(Object o, MarkerController controller) {
        final Map<?, ?> data = toMap(o);
        if (data == null) {
            return;
        }
        interpretBaseGraphicController(data, controller);

        final Object position = data.get("position");
        if (position != null) {
            controller.setGeometry(toPoint(position));
        }

        final Object icon = data.get("icon");
        if (icon != null) {
            controller.setIcon(BitmapDescriptorFactory.fromRawData(controller.getContext(), icon));
        }

        final Object backgroundImage = data.get("backgroundImage");
        if (backgroundImage != null) {
            controller.setBackground(BitmapDescriptorFactory.fromRawData(controller.getContext(), backgroundImage));
        }

        controller.setIconOffset(toFloat(data.get("iconOffsetX")), toFloat(data.get("iconOffsetY")));

        final Object opacity = data.get("opacity");
        if (opacity != null) {
            controller.setOpacity(toFloat(opacity));
        }

        final Object angle = data.get("angle");
        if(angle != null){
            controller.setAngle(toFloat(angle));
        }

        final Object selectedScale = data.get("selectedScale");
        if (selectedScale != null) {
            controller.setSelectedScale(toFloat(selectedScale));
        }
    }

    public static void interpretPolygonController(Object o, PolygonController controller) {
        final Map<?, ?> data = toMap(o);
        if (data == null) {
            return;
        }
        interpretBaseGraphicController(data, controller);
        final Object fillColor = data.get("fillColor");
        if (fillColor != null) {
            controller.setFillColor(toInt(fillColor));
        }
        final Object strokeColor = data.get("strokeColor");
        if (strokeColor != null) {
            controller.setStrokeColor(toInt(strokeColor));
        }
        final Object strokeWidth = data.get("strokeWidth");
        if (strokeWidth != null) {
            controller.setStrokeWidth(toInt(strokeWidth));
        }
        final List<?> points = toList(data.get("points"));
        if (points != null) {
            final ArrayList<Point> nativePoints = new ArrayList<>(points.size());
            for (final Object point : points) {
                nativePoints.add(toPoint(point));
            }
            controller.setGeometry(new Polygon(new PointCollection(nativePoints)));
        }
    }

    public static void interpretPolylineController(Object o, PolylineController controller) {
        final Map<?, ?> data = toMap(o);
        if (data == null) {
            return;
        }
        interpretBaseGraphicController(data, controller);
        final Object color = data.get("color");
        if (color != null) {
            controller.setColor(toInt(color));
        }
        final Object style = data.get("style");
        if (style != null) {
            controller.setStyle(toSimpleLineStyle(toInt(style)));
        }
        final Object width = data.get("width");
        if (width != null) {
            controller.setWidth(toInt(width));
        }
        final Object antialias = data.get("antialias");
        if (antialias != null) {
            controller.setAntialias(toBoolean(antialias));
        }
        final List<?> points = toList(data.get("points"));
        if (points != null) {
            final ArrayList<Point> nativePoints = new ArrayList<>(points.size());
            for (final Object point : points) {
                nativePoints.add(toPoint(point));
            }
            controller.setGeometry(new Polyline(new PointCollection(nativePoints)));
        }
    }

    public static Bitmap toBitmap(Object o) {
        byte[] bmpData = (byte[]) o;
        Bitmap bitmap = BitmapFactory.decodeByteArray(bmpData, 0, bmpData.length);
        if (bitmap == null) {
            throw new IllegalArgumentException("Unable to decode bytes as a valid bitmap.");
        } else {
            return bitmap;
        }
    }


    public static SimpleMarkerSymbol.Style toSimpleMarkerSymbolStyle(int rawValue) {
        switch (rawValue) {
            case 0:
                return SimpleMarkerSymbol.Style.CIRCLE;
            case 1:
                return SimpleMarkerSymbol.Style.CROSS;
            case 2:
                return SimpleMarkerSymbol.Style.DIAMOND;
            case 3:
                return SimpleMarkerSymbol.Style.SQUARE;
            case 4:
                return SimpleMarkerSymbol.Style.TRIANGLE;
            case 5:
                return SimpleMarkerSymbol.Style.X;
            default:
                throw new IllegalStateException("Unexpected value: " + rawValue);
        }
    }


    public static Object markerIdToJson(String markerId) {
        if (markerId == null) {
            return null;
        }
        final Map<String, Object> data = new HashMap<>(1);
        data.put("markerId", markerId);
        return data;
    }

    public static Object polygonIdToJson(String polygonId) {
        if (polygonId == null) {
            return null;
        }
        final Map<String, Object> data = new HashMap<>(1);
        data.put("polygonId", polygonId);
        return data;
    }

    public static Object polylineIdToJson(String polylineId) {
        if (polylineId == null) {
            return null;
        }
        final Map<String, Object> data = new HashMap<>(1);
        data.put("polylineId", polylineId);
        return data;
    }

    public static ScreenLocationData toScreenLocationData(Context context, Object o) {
        final Map<?, ?> data = toMap(o);
        final List<?> points = toList(data.get("position"));
        final SpatialReference spatialReferences = toSpatialReference(data.get("spatialReference"));
        final int x = toInt(points.get(0));
        final int y =  toInt(points.get(1));
        return new ScreenLocationData(new android.graphics.Point(dpToPixelsI(context,x),dpToPixelsI(context,y)), spatialReferences);
    }

    public static Object identifyLayerResultToJson(IdentifyLayerResult layerResult) {
        if (layerResult == null) {
            return null;
        }
        final Map<String, Object> data = new HashMap<>(2);
        data.put("layerName", layerResult.getLayerContent().getName());
        final List<Object> elements = new ArrayList<>(layerResult.getElements().size());
        for (final GeoElement element : layerResult.getElements()) {
            if (element.getAttributes().size() == 0)
                continue;

            final Map<String, Object> attributes = new HashMap<>(element.getAttributes().size());
            element.getAttributes().forEach((k, v) -> {
                attributes.put(k, toFieldFlutter(v));
            });

            final Map<String, Object> elementData = new HashMap<>(2);

            elementData.put("attributes", attributes);
            if (element.getGeometry() != null)
                elementData.put("geometry", element.getGeometry().toJson());
            elements.add(elementData);
        }
        data.put("elements", elements);
        return data;
    }

    public static Object identifyLayerResultsToJson(List<IdentifyLayerResult> layerResults) {
        final List<Object> results = new ArrayList<>(layerResults.size());
        for (final IdentifyLayerResult result : layerResults) {
            results.add(identifyLayerResultToJson(result));
        }
        return results;
    }


    private static void interpretBaseGraphicController(Map<?, ?> data, BaseGraphicController controller) {

        final Object consumeTapEvents = data.get("consumeTapEvents");
        if (consumeTapEvents != null) {
            controller.setConsumeTapEvents(toBoolean(consumeTapEvents));
        }
        final Object visible = data.get("visible");
        if (visible != null) {
            controller.setVisible(toBoolean(visible));
        }
        final Object zIndex = data.get("zIndex");
        if (zIndex != null) {
            controller.setZIndex(toInt(zIndex));
        }

        final Object selectedColor = data.get("selectedColor");
        if (selectedColor != null) {
            controller.setSelectedColor(Color.valueOf(toInt(selectedColor)));
        }
    }

    private static void interpretInteractionOptions(Object o, MapView mapView) {
        final Map<?, ?> data = toMap(o);
        final MapView.InteractionOptions interactionOptions = mapView.getInteractionOptions();

        final Object isEnabled = data.get("isEnabled");
        if (isEnabled != null) {
            interactionOptions.setEnabled(toBoolean(isEnabled));
        }
        final Object isRotateEnabled = data.get("isRotateEnabled");
        if (isRotateEnabled != null) {
            interactionOptions.setRotateEnabled(toBoolean(isRotateEnabled));
        }
        final Object isPanEnabled = data.get("isPanEnabled");
        if (isPanEnabled != null) {
            interactionOptions.setPanEnabled(toBoolean(isPanEnabled));
        }
        final Object isZoomEnabled = data.get("isZoomEnabled");
        if (isZoomEnabled != null) {
            interactionOptions.setZoomEnabled(toBoolean(isZoomEnabled));
        }
        final Object isMagnifierEnabled = data.get("isMagnifierEnabled");
        if (isMagnifierEnabled != null) {
            interactionOptions.setMagnifierEnabled(toBoolean(isMagnifierEnabled));
        }
        final Object allowMagnifierToPan = data.get("allowMagnifierToPan");
        if (allowMagnifierToPan != null) {
            interactionOptions.setCanMagnifierPanMap(toBoolean(allowMagnifierToPan));
        }
    }

    private static SpatialReference toSpatialReference(Object o) {
        final Map<?, ?> data = toMap(o);
        if (data == null)
            return null;
        final Object wkId = data.get("wkId");
        if (wkId != null) {
            return SpatialReference.create(toInt(wkId));
        }
        final Object wkText = data.get("wkText");
        if (wkText != null) {
            return SpatialReference.create((String) wkText);
        }
        return null;
    }

    private static SimpleLineSymbol.Style toSimpleLineStyle(int rawValue) {
        switch (rawValue) {
            case 0:
                return SimpleLineSymbol.Style.DASH;
            case 1:
                return SimpleLineSymbol.Style.DASH_DOT;
            case 2:
                return SimpleLineSymbol.Style.DASH_DOT_DOT;
            case 3:
                return SimpleLineSymbol.Style.DOT;
            case 4:
                return SimpleLineSymbol.Style.NULL;
            case 5:
                return SimpleLineSymbol.Style.SOLID;
            default:
                throw new IllegalStateException("Unexpected value: " + rawValue);
        }
    }

    private static LocationDisplay.AutoPanMode toAutoPanMode(Object rawValue) {
        final int intValue = toInt(rawValue);
        switch (intValue) {
            case 0:
                return LocationDisplay.AutoPanMode.OFF;
            case 1:
                return LocationDisplay.AutoPanMode.RECENTER;
            case 2:
                return LocationDisplay.AutoPanMode.NAVIGATION;
            case 3:
                return LocationDisplay.AutoPanMode.COMPASS_NAVIGATION;
            default:
                throw new IllegalStateException("Unexpected value: " + intValue);
        }
    }

    private static Portal toPortal(Object o) {
        final Map<?, ?> data = toMap(o);
        final String postalUrl = (String) data.get("postalUrl");
        final boolean loginRequired = toBoolean(data.get("loginRequired"));
        final Portal portal = new Portal(postalUrl, loginRequired);
        final Object credentials = data.get("credential");
        if (credentials != null) {
            portal.setCredential(toCredentials(credentials));
        }
        return portal;
    }

    private static PortalItem toPortalItem(Object o) {
        final Map<?, ?> data = toMap(o);
        final Portal portal = toPortal(data.get("portal"));
        final String itemId = (String) data.get("itemId");
        return new PortalItem(portal, itemId);
    }

    private static Basemap createBasemapFromType(String type) {
        switch (type) {
            case "streets":
                return Basemap.createStreets();
            case "topographic":
                return Basemap.createTopographic();
            case "imagery":
                return Basemap.createImagery();
            case "darkGrayCanvasVector":
                return Basemap.createDarkGrayCanvasVector();
            case "imageryWithLabelsVector":
                return Basemap.createImageryWithLabelsVector();
            case "lightGrayCanvasVector":
                return Basemap.createLightGrayCanvasVector();
            case "navigationVector":
                return Basemap.createNavigationVector();
            case "openStreetMap":
                return Basemap.createOpenStreetMap();
            case "streetsNightVector":
                return Basemap.createStreetsNightVector();
            case "streetsVector":
                return Basemap.createStreetsVector();
            case "streetsWithReliefVector":
                return Basemap.createStreetsWithReliefVector();
            case "terrainWithLabelsVector":
                return Basemap.createTerrainWithLabelsVector();
            case "topographicVector":
                return Basemap.createTopographicVector();
            case "lightGrayCanvas":
                return Basemap.createLightGrayCanvas();
            case "oceans":
                return Basemap.createOceans();
            case "nationalGeographic":
                return Basemap.createNationalGeographic();
            case "imageryWithLabels":
                return Basemap.createImageryWithLabels();
            case "terrainWithLabels":
                return Basemap.createTerrainWithLabels();
            default:
                throw new IllegalStateException("Unexpected value: " + type);
        }
    }

    private static Basemap.Type getBasemapType(String basemapType) {
        switch (basemapType) {
            case "imagery":
                return Basemap.Type.IMAGERY;
            case "imageryWithLabels":
                return Basemap.Type.IMAGERY_WITH_LABELS;
            case "streets":
                return Basemap.Type.STREETS;
            case "topographic":
                return Basemap.Type.TOPOGRAPHIC;
            case "terrainWithLabels":
                return Basemap.Type.TERRAIN_WITH_LABELS;
            case "lightGrayCanvas":
                return Basemap.Type.LIGHT_GRAY_CANVAS;
            case "nationalGeographic":
                return Basemap.Type.NATIONAL_GEOGRAPHIC;
            case "oceans":
                return Basemap.Type.OCEANS;
            case "openStreetMap":
                return Basemap.Type.OPEN_STREET_MAP;
            case "imageryWithLabelsVector":
                return Basemap.Type.IMAGERY_WITH_LABELS_VECTOR;
            case "streetsVector":
                return Basemap.Type.STREETS_VECTOR;
            case "topographicVector":
                return Basemap.Type.TOPOGRAPHIC_VECTOR;
            case "terrainWithLabelsVector":
                return Basemap.Type.TERRAIN_WITH_LABELS_VECTOR;
            case "lightGrayCanvasVector":
                return Basemap.Type.LIGHT_GRAY_CANVAS_VECTOR;
            case "navigationVector":
                return Basemap.Type.NAVIGATION_VECTOR;
            case "streetsNightVector":
                return Basemap.Type.STREETS_NIGHT_VECTOR;
            case "streetsWithReliefVector":
                return Basemap.Type.STREETS_WITH_RELIEF_VECTOR;
            case "darkGrayCanvasVector":
                return Basemap.Type.DARK_GRAY_CANVAS_VECTOR;
            default:
                throw new IllegalStateException("Unexpected value: " + basemapType);
        }
    }


    private static List<ElevationSource> toElevationSourceList(List<Object> list) {

        ArrayList<ElevationSource> elevationSources = new ArrayList<>();
        for (Object o : list) {
            elevationSources.add(toElevationSource(o));
        }
        return elevationSources;
    }


    private static ElevationSource toElevationSource(Object o) {
        Map<?, ?> map = toMap(o);

        switch (map.get("elevationType").toString()) {
            case "ArcGISTiledElevationSource":
                return new ArcGISTiledElevationSource((String) map.get("url"));
            default:
                throw new IllegalStateException("Unexpected value: " + map.get("elevationType").toString());
        }
    }


    private static Object toFieldFlutter(Object o) {
        final Map<String, Object> data = new HashMap<>(2);
        FieldTypeFlutter fieldTypeFlutter = FieldTypeFlutter.UNKNOWN;
        if (o == null) {
            fieldTypeFlutter = FieldTypeFlutter.NULLABLE;
        } else if (o instanceof String) {
            fieldTypeFlutter = FieldTypeFlutter.TEXT;
        } else if (o instanceof Short || o instanceof Integer) {
            fieldTypeFlutter = FieldTypeFlutter.INTEGER;
        } else if (o instanceof Float || o instanceof Double) {
            fieldTypeFlutter = FieldTypeFlutter.DOUBLE;
        } else if (o instanceof GregorianCalendar) {
            fieldTypeFlutter = FieldTypeFlutter.DATE;
            o = ISO8601Format.format(((GregorianCalendar) o).getTime());
        }
        data.put("type", fieldTypeFlutter.getValue());
        data.put("value", o);
        return data;
    }

    public static boolean toBoolean(Object o) {
        return (Boolean) o;
    }

    public static Map<?, ?> toMap(Object o) {
        return (Map<?, ?>) o;
    }

    public static List<?> toList(Object o) {
        return (List<?>) o;
    }

    public static double toDouble(Object o) {
        return ((Number) o).doubleValue();
    }

    public static float toFloat(Object o) {
        return ((Number) o).floatValue();
    }

    public static int toInt(Object o) {
        return ((Number) o).intValue();
    }


    public static int dpToPixelsI(Context context, int dp) {
        return (int) (dp * ((float) context.getResources().getDisplayMetrics().densityDpi / DisplayMetrics.DENSITY_DEFAULT));
    }

    public static float dpToPixelsF(Context context, float dp) {
        return (dp * ((float) context.getResources().getDisplayMetrics().densityDpi / DisplayMetrics.DENSITY_DEFAULT));
    }

    public static int pixelsToDpI(Context context, float pixels) {
        return (int) (pixels / ((float) context.getResources().getDisplayMetrics().densityDpi / DisplayMetrics.DENSITY_DEFAULT));
    }

    public static float pixelsToDpF(Context context, float pixels) {
        return (pixels / ((float) context.getResources().getDisplayMetrics().densityDpi / DisplayMetrics.DENSITY_DEFAULT));
    }

    public static int spToPixels(Context context, int sp) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, sp, context.getResources().getDisplayMetrics());
    }

}
