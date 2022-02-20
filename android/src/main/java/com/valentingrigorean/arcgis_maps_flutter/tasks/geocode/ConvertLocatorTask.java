package com.valentingrigorean.arcgis_maps_flutter.tasks.geocode;

import com.esri.arcgisruntime.tasks.geocode.GeocodeResult;
import com.esri.arcgisruntime.tasks.geocode.LocatorAttribute;
import com.esri.arcgisruntime.tasks.geocode.LocatorInfo;
import com.valentingrigorean.arcgis_maps_flutter.Convert;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ConvertLocatorTask extends Convert {
    public static Object geocodeResultsToJson(List<GeocodeResult> results) {
        final List<Object> jsonResults = new ArrayList<>(results.size());
        for (final GeocodeResult result : results) {
            jsonResults.add(geocodeResultToJson(result));
        }
        return jsonResults;
    }

    public static Object locatorInfoToJson(LocatorInfo locatorInfo) {
        final Map<String, Object> data = new HashMap<>();
        data.put("name", locatorInfo.getName());
        data.put("description", locatorInfo.getDescription());
        data.put("intersectionResultAttributes", locatorAttributesToJson(locatorInfo.getIntersectionResultAttributes()));

        if (locatorInfo.getProperties() != null) {
            data.put("properties", locatorInfo.getProperties());
        }
        data.put("resultAttributes", locatorAttributesToJson(locatorInfo.getResultAttributes()));
        data.put("searchAttributes", locatorAttributesToJson(locatorInfo.getSearchAttributes()));
        if (locatorInfo.getSpatialReference() != null) {
            data.put("spatialReference", spatialReferenceToJson(locatorInfo.getSpatialReference()));
        }
        data.put("supportsPOI", locatorInfo.isSupportsPoi());
        data.put("supportsAddresses", locatorInfo.isSupportsAddresses());
        data.put("supportsIntersections", locatorInfo.isSupportsIntersections());
        data.put("supportsSuggestions", locatorInfo.isSupportsSuggestions());
        data.put("version", locatorInfo.getVersion());

        return data;
    }

    private static List<Object> locatorAttributesToJson(List<LocatorAttribute> attributes) {
        final ArrayList<Object> data = new ArrayList<>(attributes.size());
        for (final LocatorAttribute attribute : attributes) {
            data.add(locatorAttributeToJson(attribute));
        }
        return data;
    }

    private static Object locatorAttributeToJson(LocatorAttribute attribute) {
        final Map<String, Object> data = new HashMap<>(3);
        data.put("name", attribute.getName());
        data.put("displayName", attribute.getDisplayName());
        data.put("required", attribute.isRequired());
        data.put("type", attribute.getType().ordinal());
        return data;
    }
}
