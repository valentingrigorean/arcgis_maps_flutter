package com.valentingrigorean.arcgis_maps_flutter.tasks.networkanalysis;

import com.esri.arcgisruntime.UnitSystem;
import com.esri.arcgisruntime.tasks.networkanalysis.AttributeParameterValue;
import com.esri.arcgisruntime.tasks.networkanalysis.CostAttribute;
import com.esri.arcgisruntime.tasks.networkanalysis.CurbApproach;
import com.esri.arcgisruntime.tasks.networkanalysis.DirectionEvent;
import com.esri.arcgisruntime.tasks.networkanalysis.DirectionManeuver;
import com.esri.arcgisruntime.tasks.networkanalysis.DirectionMessage;
import com.esri.arcgisruntime.tasks.networkanalysis.DirectionsStyle;
import com.esri.arcgisruntime.tasks.networkanalysis.RestrictionAttribute;
import com.esri.arcgisruntime.tasks.networkanalysis.Route;
import com.esri.arcgisruntime.tasks.networkanalysis.RouteParameters;
import com.esri.arcgisruntime.tasks.networkanalysis.RouteResult;
import com.esri.arcgisruntime.tasks.networkanalysis.RouteTaskInfo;
import com.esri.arcgisruntime.tasks.networkanalysis.Stop;
import com.esri.arcgisruntime.tasks.networkanalysis.TravelMode;
import com.esri.arcgisruntime.tasks.networkanalysis.UTurnPolicy;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ConvertRouteTask extends com.valentingrigorean.arcgis_maps_flutter.Convert {

    public static Object routeTaskInfoToJson(RouteTaskInfo routeTaskInfo) {
        final Map<String, Object> json = new HashMap<>();
        json.put("accumulateAttributeNames", routeTaskInfo.getAccumulateAttributeNames());
        if (routeTaskInfo.getCostAttributes() != null) {
            final Map<String, Object> costAttributes = new HashMap<>(routeTaskInfo.getCostAttributes().size());
            routeTaskInfo.getCostAttributes().forEach((key, value) -> costAttributes.put(key, costAttributeToJson(value)));
            json.put("costAttributes", costAttributes);
        }
        json.put("defaultTravelModeName", routeTaskInfo.getDefaultTravelModeName());
        json.put("directionsDistanceUnits", routeTaskInfo.getDirectionsDistanceUnits().ordinal());
        json.put("directionsLanguage", routeTaskInfo.getDirectionsLanguage());
        json.put("directionsStyle", routeTaskInfo.getDirectionsStyle().ordinal());
        json.put("findBestSequence", routeTaskInfo.isFindBestSequence());
        json.put("maxLocatingDistance", routeTaskInfo.getMaxLocatingDistance());
        if (routeTaskInfo.getStartTime() != null) {
            json.put("startTime", toCalendarFromISO8601(routeTaskInfo.getStartTime()));
        }
        json.put("networkName", routeTaskInfo.getNetworkName());
        if (routeTaskInfo.getOutputSpatialReference() != null) {
            json.put("outputSpatialReference", spatialReferenceToJson(routeTaskInfo.getOutputSpatialReference()));
        }
        json.put("preserveFirstStop", routeTaskInfo.isPreserveFirstStop());
        json.put("preserveLastStop", routeTaskInfo.isPreserveLastStop());
        if (routeTaskInfo.getRestrictionAttributes() != null) {
            final Map<String, Object> restrictionAttributes = new HashMap<>(routeTaskInfo.getRestrictionAttributes().size());
            routeTaskInfo.getRestrictionAttributes().forEach((key, value) -> restrictionAttributes.put(key, restrictionAttributeToJson(value)));
            json.put("restrictionAttributes", restrictionAttributes);
        }
        json.put("routeShapeType", routeTaskInfo.getRouteShapeType().ordinal());
        json.put("supportedLanguages", routeTaskInfo.getSupportedLanguages());
        json.put("supportedRestrictionUsageParameterValues", routeTaskInfo.getSupportedRestrictionUsageParameterValues());
        json.put("directionsSupport", routeTaskInfo.getDirectionsSupport().ordinal());
        final List<Object> travelModes = new ArrayList<>(routeTaskInfo.getTravelModes().size());
        routeTaskInfo.getTravelModes().forEach(travelMode -> travelModes.add(travelModeToJson(travelMode)));
        json.put("travelModes", travelModes);
        json.put("supportsRerouting", routeTaskInfo.isSupportsRerouting());
        return json;
    }

    public static RouteParameters toRouteParameters(Object o) {
        final Map<?, ?> data = toMap(o);
        final RouteParameters routeParameters = new RouteParameters();
        routeParameters.getAccumulateAttributeNames().addAll((Collection<? extends String>) toList(data.get("accumulateAttributeNames")));
        routeParameters.setDirectionsDistanceUnits(UnitSystem.values()[toInt(data.get("directionsDistanceUnits"))]);
        routeParameters.setDirectionsLanguage((String) data.get("directionsLanguage"));
        routeParameters.setDirectionsStyle(DirectionsStyle.values()[toInt(data.get("directionsStyle"))]);
        routeParameters.setFindBestSequence(toBoolean(data.get("findBestSequence")));
        final Object startTime = data.get("startTime");
        if (startTime != null) {
            routeParameters.setStartTime(toCalendarFromISO8601(startTime.toString()));
        }
        final Object outputSpatialReference = data.get("outputSpatialReference");
        if (outputSpatialReference != null) {
            routeParameters.setOutputSpatialReference(toSpatialReference(outputSpatialReference));
        }
        routeParameters.setPreserveFirstStop(toBoolean(data.get("preserveFirstStop")));
        routeParameters.setPreserveLastStop(toBoolean(data.get("preserveLastStop")));
        routeParameters.setReturnDirections(toBoolean(data.get("returnDirections")));
        routeParameters.setReturnPointBarriers(toBoolean(data.get("returnPointBarriers")));
        routeParameters.setReturnPolygonBarriers(toBoolean(data.get("returnPolygonBarriers")));
        routeParameters.setReturnPolylineBarriers(toBoolean(data.get("returnPolylineBarriers")));
        routeParameters.setReturnRoutes(toBoolean(data.get("returnRoutes")));
        routeParameters.setReturnStops(toBoolean(data.get("returnStops")));
        routeParameters.setReturnRoutes(toBoolean(data.get("returnRoutes")));
        final Object travelMode = data.get("travelMode");
        if (travelMode != null) {
            routeParameters.setTravelMode(toTravelMode(travelMode));
        }
        final Object stopsRaw = data.get("stops");
        if (stopsRaw != null) {
            final List<?> stops = toList(stopsRaw);
            final List<Stop> routeStops = new ArrayList<>(stops.size());
            stops.forEach(stop -> routeStops.add(toStop(stop)));
            routeParameters.setStops(routeStops);
        }
        return routeParameters;
    }

    public static Object routeParametersToJson(RouteParameters routeParameters) {
        final Map<String, Object> json = new HashMap<>(17);
        json.put("accumulateAttributeNames", routeParameters.getAccumulateAttributeNames());
        json.put("directionsDistanceUnits", routeParameters.getDirectionsDistanceUnits().ordinal());
        json.put("directionsLanguage", routeParameters.getDirectionsLanguage());
        json.put("directionsStyle", routeParameters.getDirectionsStyle().ordinal());
        json.put("findBestSequence", routeParameters.isFindBestSequence());
        if (routeParameters.getStartTime() != null) {
            json.put("startTime", toCalendarFromISO8601(routeParameters.getStartTime()));
        }
        if (routeParameters.getOutputSpatialReference() != null) {
            json.put("outputSpatialReference", spatialReferenceToJson(routeParameters.getOutputSpatialReference()));
        }
        json.put("preserveFirstStop", routeParameters.isPreserveFirstStop());
        json.put("preserveLastStop", routeParameters.isPreserveLastStop());
        json.put("returnDirections", routeParameters.isReturnDirections());
        json.put("returnPointBarriers", routeParameters.isReturnPointBarriers());
        json.put("returnPolygonBarriers", routeParameters.isReturnPolygonBarriers());
        json.put("returnPolylineBarriers", routeParameters.isReturnPolylineBarriers());
        json.put("returnRoutes", routeParameters.isReturnRoutes());
        json.put("returnStops", routeParameters.isReturnStops());
        json.put("routeShapeType", routeParameters.getRouteShapeType().ordinal());
        if (routeParameters.getTravelMode() != null) {
            json.put("travelMode", travelModeToJson(routeParameters.getTravelMode()));
        }
        return json;
    }

    public static Object routeResultToJson(RouteResult routeResult) {
        final Map<String, Object> json = new HashMap<>(3);
        json.put("directionsLanguage", routeResult.getDirectionsLanguage());
        json.put("messages", routeResult.getMessages());
        final List<Object> routes = new ArrayList<>(routeResult.getRoutes().size());
        routeResult.getRoutes().forEach(route -> routes.add(routeToJson(route)));
        json.put("routes", routes);
        return json;
    }

    private static Object routeToJson(Route route) {
        final Map<String, Object> json = new HashMap<>(13);
        final List<Object> directionManeuvers = new ArrayList<>(route.getDirectionManeuvers().size());
        route.getDirectionManeuvers().forEach(directionManeuver -> directionManeuvers.add(directionManeuverToJson(directionManeuver)));
        json.put("directionManeuvers", directionManeuvers);
        if (route.getStartTime() != null) {
            json.put("startTime", toCalendarFromISO8601(route.getStartTime()));
        }
        json.put("startTimeShift", route.getStartTimeShift());
        if (route.getEndTime() != null) {
            json.put("endTime", toCalendarFromISO8601(route.getEndTime()));
        }
        json.put("endTimeShift", route.getEndTimeShift());
        json.put("totalLength", route.getTotalLength());
        if (route.getRouteGeometry() != null) {
            json.put("routeGeometry", geometryToJson(route.getRouteGeometry()));
        }
        final List<Object> stops = new ArrayList<>(route.getStops().size());
        route.getStops().forEach(stop -> stops.add(stopToJson(stop)));
        json.put("stops", stops);
        json.put("routeName", route.getRouteName());
        json.put("totalTime", route.getTotalTime());
        json.put("travelTime", route.getTravelTime());
        json.put("violationTime", route.getViolationTime());
        json.put("waitTime", route.getWaitTime());
        return json;
    }


    private static Object directionManeuverToJson(DirectionManeuver directionManeuver) {
        final Map<String, Object> json = new HashMap<>(11);
        final List<Object> directionEvents = new ArrayList<>(directionManeuver.getDirectionEvents().size());
        directionManeuver.getDirectionEvents().forEach(directionEvent -> directionEvents.add(directionEventToJson(directionEvent)));
        json.put("directionEvents", directionEvents);
        json.put("directionText", directionManeuver.getDirectionText());
        if (directionManeuver.getEstimatedArrivalTime() != null) {
            json.put("estimatedArrivalTime", toCalendarFromISO8601(directionManeuver.getEstimatedArrivalTime()));
        }
        json.put("estimatedArrivalTimeShift", directionManeuver.getEstimatedArrivalTimeShift());
        final List<Object> maneuverMessages = new ArrayList<>(directionManeuver.getManeuverMessages().size());
        directionManeuver.getManeuverMessages().forEach(maneuverMessage -> maneuverMessages.add(maneuverMessageToJson(maneuverMessage)));
        json.put("maneuverMessages", maneuverMessages);
        json.put("fromLevel", directionManeuver.getFromLevel());
        if (directionManeuver.getGeometry() != null) {
            json.put("geometry", geometryToJson(directionManeuver.getGeometry()));
        }
        json.put("maneuverType", directionManeuver.getManeuverType().ordinal());
        json.put("toLevel", directionManeuver.getToLevel());
        json.put("length", directionManeuver.getLength());
        json.put("duration", directionManeuver.getDuration());
        return json;
    }

    private static Object maneuverMessageToJson(DirectionMessage maneuverMessage) {
        final Map<String, Object> json = new HashMap<>(2);
        json.put("type", maneuverMessage.getType().ordinal());
        json.put("text", maneuverMessage.getText());
        return json;
    }

    private static Object directionEventToJson(DirectionEvent directionEvent) {
        final Map<String, Object> json = new HashMap<>(5);
        if (directionEvent.getEstimatedArrivalTime() != null) {
            json.put("estimatedArrivalTime", toCalendarFromISO8601(directionEvent.getEstimatedArrivalTime()));
        }
        json.put("estimatedArrivalTimeShift", directionEvent.getEstimatedArrivalTimeShift());
        final List<String> eventMessages = new ArrayList<>(directionEvent.getEventMessages().size());
        directionEvent.getEventMessages().forEach(eventMessage -> eventMessages.add(eventMessage.getText()));
        json.put("eventMessages", eventMessages);
        json.put("eventText", directionEvent.getEventText());
        if (directionEvent.getGeometry() != null) {
            json.put("geometry", geometryToJson(directionEvent.getGeometry()));
        }
        return json;
    }


    private static Stop toStop(Object o) {
        final Map<?, ?> data = toMap(o);
        final Stop stop = new Stop(toPoint(data.get("geometry")));
        final Object name = data.get("name");
        if (name != null) {
            stop.setName((String) name);
        }
        stop.setType(Stop.Type.values()[toInt(data.get("stopType"))]);
        final Object routeName = data.get("routeName");
        if (routeName != null) {
            stop.setRouteName((String) routeName);
        }
        stop.setCurbApproach(toCurbApproach(data.get("curbApproach")));
        stop.setCurrentBearingTolerance(toDouble(data.get("currentBearingTolerance")));
        stop.setNavigationLatency(toDouble(data.get("navigationLatency")));
        stop.setNavigationSpeed(toDouble(data.get("navigationSpeed")));
        return stop;
    }

    private static Object stopToJson(Stop stop) {
        final Map<String, Object> json = new HashMap<>();
        json.put("arrivalCurbApproach", curbApproachToJson(stop.getArrivalCurbApproach()));
        json.put("departureCurbApproach", curbApproachToJson(stop.getDepartureCurbApproach()));
        json.put("curbApproach", curbApproachToJson(stop.getCurbApproach()));
        json.put("currentBearing", stop.getCurrentBearing());
        json.put("currentBearingTolerance", stop.getCurrentBearingTolerance());
        json.put("distanceToNetworkLocation", stop.getDistanceToNetworkLocation());
        if (stop.getGeometry() != null) {
            json.put("geometry", geometryToJson(stop.getGeometry()));
        }
        if (stop.getArrivalTime() != null) {
            json.put("arrivalTime", toCalendarFromISO8601(stop.getArrivalTime()));
        }
        json.put("arrivalTimeShift", stop.getArrivalTimeShift());
        if (stop.getDepartureTime() != null) {
            json.put("departureTime", toCalendarFromISO8601(stop.getDepartureTime()));
        }
        json.put("departureTimeShift", stop.getDepartureTimeShift());
        if (stop.getTimeWindowStart() != null) {
            json.put("timeWindowStart", toCalendarFromISO8601(stop.getTimeWindowStart()));
        }
        if (stop.getTimeWindowEnd() != null) {
            json.put("timeWindowEnd", toCalendarFromISO8601(stop.getTimeWindowEnd()));
        }
        json.put("locationStatus", stop.getLocationStatus().ordinal());
        json.put("name", stop.getName());
        json.put("stopType", stop.getType().ordinal());
        json.put("stopID", stop.getStopId());
        json.put("navigationLatency", stop.getNavigationLatency());
        json.put("navigationSpeed", stop.getNavigationSpeed());
        json.put("routeName", stop.getRouteName());
        json.put("sequence", stop.getSequence());
        json.put("violationTime", stop.getViolationTime());
        json.put("waitTime", stop.getWaitTime());
        return json;
    }

    private static TravelMode toTravelMode(Object o) {
        final Map<?, ?> data = toMap(o);
        final TravelMode travelMode = new TravelMode();
        final List<?> attributeParameterValuesRaw = toList(data.get("attributeParameterValues"));
        final List<AttributeParameterValue> attributeParameterValues = new ArrayList<>(attributeParameterValuesRaw.size());
        attributeParameterValuesRaw.forEach(attributeParameterValueRaw -> attributeParameterValues.add(toAttributeParameterValue(attributeParameterValueRaw)));
        travelMode.getAttributeParameterValues().addAll(attributeParameterValues);
        travelMode.setDescription((String) data.get("travelModeDescription"));
        travelMode.setDistanceAttributeName((String) data.get("distanceAttributeName"));
        travelMode.setImpedanceAttributeName((String) data.get("impedanceAttributeName"));
        travelMode.setName((String) data.get("name"));
        travelMode.setOutputGeometryPrecision(toDouble(data.get("outputGeometryPrecision")));
        travelMode.getRestrictionAttributeNames().addAll((Collection<? extends String>) toList(data.get("restrictionAttributeNames")));
        travelMode.setTimeAttributeName((String) data.get("timeAttributeName"));
        travelMode.setType((String) data.get("type"));
        travelMode.setUseHierarchy(toBoolean(data.get("useHierarchy")));
        travelMode.setUTurnPolicy(UTurnPolicy.values()[toInt(data.get("uTurnPolicy"))]);
        return travelMode;
    }

    private static Object travelModeToJson(TravelMode travelMode) {
        final Map<String, Object> json = new HashMap<>(11);

        final List<Object> attributeParameterValues = new ArrayList<>(travelMode.getAttributeParameterValues().size());
        travelMode.getAttributeParameterValues().forEach(attributeParameterValue -> attributeParameterValues.add(attributeParameterValueToJson(attributeParameterValue)));

        json.put("attributeParameterValues", attributeParameterValues);
        json.put("travelModeDescription", travelMode.getDescription());
        json.put("distanceAttributeName", travelMode.getDistanceAttributeName());
        json.put("impedanceAttributeName", travelMode.getImpedanceAttributeName());
        json.put("name", travelMode.getName());
        json.put("outputGeometryPrecision", travelMode.getOutputGeometryPrecision());
        json.put("restrictionAttributeNames", travelMode.getRestrictionAttributeNames());
        json.put("timeAttributeName", travelMode.getTimeAttributeName());
        json.put("type", travelMode.getType());
        json.put("useHierarchy", travelMode.isUseHierarchy());
        json.put("uTurnPolicy", travelMode.getUTurnPolicy().ordinal());
        return json;
    }

    private static Object costAttributeToJson(CostAttribute costAttribute) {
        final Map<String, Object> json = new HashMap<>(2);
        if (costAttribute.getParameterValues() != null) {
            final Map<String, Object> parameterValues = new HashMap<>(costAttribute.getParameterValues().size());
            costAttribute.getParameterValues().forEach((key, value) -> parameterValues.put(key, toFlutterFieldType(value)));
            json.put("parameterValues", parameterValues);
        }
        json.put("units", costAttribute.getUnit().ordinal());
        return json;
    }

    private static Object restrictionAttributeToJson(RestrictionAttribute restrictionAttribute) {
        final Map<String, Object> json = new HashMap<>(2);
        if (restrictionAttribute.getParameterValues() != null) {
            final Map<String, Object> parameterValues = new HashMap<>(restrictionAttribute.getParameterValues().size());
            restrictionAttribute.getParameterValues().forEach((key, value) -> parameterValues.put(key, toFlutterFieldType(value)));
            json.put("parameterValues", parameterValues);
        }
        json.put("restrictionUsageParameterName", restrictionAttribute.getRestrictionUsageParameterName());
        return json;
    }

    private static AttributeParameterValue toAttributeParameterValue(Object o) {
        final Map<?, ?> data = toMap(o);
        final AttributeParameterValue attributeParameterValue = new AttributeParameterValue();
        attributeParameterValue.setAttributeName((String) data.get("attributeName"));
        attributeParameterValue.setParameterName((String) data.get("parameterName"));
        attributeParameterValue.setParameterValue(fromFlutterField(data.get("parameterValue")));
        return attributeParameterValue;
    }

    private static Object attributeParameterValueToJson(AttributeParameterValue attributeParameterValue) {
        final Map<String, Object> json = new HashMap<>(3);
        json.put("attributeName", attributeParameterValue.getAttributeName());
        json.put("parameterName", attributeParameterValue.getParameterName());
        json.put("parameterValue", toFlutterFieldType(attributeParameterValue.getParameterValue()));
        return json;
    }

    private static CurbApproach toCurbApproach(Object o) {
        final int ordinal = toInt(o);
        switch (ordinal) {
            case 4:
                return CurbApproach.UNKNOWN;
            default:
                return CurbApproach.values()[ordinal + 1];
        }
    }

    private static int curbApproachToJson(CurbApproach curbApproach) {
        if (curbApproach == CurbApproach.UNKNOWN) {
            return 4;
        }
        return curbApproach.ordinal() + 1;
    }
}
