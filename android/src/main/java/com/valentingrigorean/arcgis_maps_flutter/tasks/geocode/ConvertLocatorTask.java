package com.valentingrigorean.arcgis_maps_flutter.tasks.geocode;

import com.esri.arcgisruntime.tasks.geocode.GeocodeParameters;
import com.esri.arcgisruntime.tasks.geocode.GeocodeResult;
import com.esri.arcgisruntime.tasks.geocode.LocatorAttribute;
import com.esri.arcgisruntime.tasks.geocode.LocatorInfo;
import com.esri.arcgisruntime.tasks.geocode.ReverseGeocodeParameters;
import com.esri.arcgisruntime.tasks.geocode.SuggestParameters;
import com.esri.arcgisruntime.tasks.geocode.SuggestResult;
import com.valentingrigorean.arcgis_maps_flutter.Convert;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ConvertLocatorTask extends Convert {
    public static GeocodeParameters toGeocodeParameters(Object json) {
        final Map<?, ?> data = toMap(json);
        if (data == null || data.size() == 0) {
            return null;
        }
        GeocodeParameters geocodeParameters = new GeocodeParameters();
        final Object resultAttributeNames = data.get("resultAttributeNames");
        if (resultAttributeNames != null) {
            for (final Object attr : toList(resultAttributeNames)) {
                geocodeParameters.getResultAttributeNames().add(attr.toString());
            }
        }
        final Object categories = data.get("categories");
        if (categories != null) {
            for (final Object attr : toList(categories)) {
                geocodeParameters.getCategories().add(attr.toString());
            }
        }
        final Object countryCode = data.get("countryCode");
        if (countryCode != null) {
            geocodeParameters.setCountryCode(countryCode.toString());
        }
        geocodeParameters.setForStorage(toBoolean(data.get("forStorage")));
        geocodeParameters.setMaxResults(toInt(data.get("maxResults")));
        geocodeParameters.setMinScore(toDouble(data.get("minScore")));
        final Object outputLanguageCode = data.get("outputLanguageCode");
        if (outputLanguageCode != null) {
            geocodeParameters.setOutputLanguageCode(outputLanguageCode.toString());
        }
        geocodeParameters.setOutputSpatialReference(toSpatialReference(data.get("outputSpatialReference")));
        final Object preferredSearchLocation = data.get("preferredSearchLocation");
        if (preferredSearchLocation != null) {
            geocodeParameters.setPreferredSearchLocation(toPoint(preferredSearchLocation));
        }
        final Object searchArea = data.get("searchArea");
        if (searchArea != null) {
            geocodeParameters.setSearchArea(toGeometry(searchArea));
        }
        return geocodeParameters;
    }

    public static Object geocodeResultsToJson(List<GeocodeResult> results) {
        final List<Object> jsonResults = new ArrayList<>(results.size());
        for (final GeocodeResult result : results) {
            jsonResults.add(geocodeResultToJson(result));
        }
        return jsonResults;
    }

    public static ReverseGeocodeParameters toReverseGeocodeParameters(Object json) {
        final Map<?, ?> data = toMap(json);
        final ReverseGeocodeParameters reverseGeocodeParameters = new ReverseGeocodeParameters();

        final Object resultAttributeNames = data.get("resultAttributeNames");
        if (resultAttributeNames != null) {
            for (final Object attr : toList(resultAttributeNames)) {
                reverseGeocodeParameters.getResultAttributeNames().add(attr.toString());
            }
        }

        final Object categories = data.get("featureTypes");
        if (categories != null) {
            for (final Object attr : toList(categories)) {
                reverseGeocodeParameters.getFeatureTypes().add(attr.toString());
            }
        }

        reverseGeocodeParameters.setForStorage(toBoolean(data.get("forStorage")));
        reverseGeocodeParameters.setMaxDistance(toDouble(data.get("maxDistance")));
        reverseGeocodeParameters.setOutputSpatialReference(toSpatialReference(data.get("outputSpatialReference")));
        reverseGeocodeParameters.setOutputLanguageCode(data.get("outputLanguageCode").toString());
        return reverseGeocodeParameters;
    }


    public static SuggestParameters toSuggestParameters(Object parameters) {
        final Map<?, ?> data = toMap(parameters);
        final SuggestParameters suggestParameters = new SuggestParameters();
        final Object categories = data.get("categories");
        if (categories != null) {
            for (final Object attr : toList(categories)) {
                suggestParameters.getCategories().add(attr.toString());
            }
        }
        suggestParameters.setCountryCode(data.get("countryCode").toString());
        suggestParameters.setCountryCode(data.get("countryCode").toString());
        suggestParameters.setMaxResults(toInt(data.get("maxResults")));

        final Object preferredSearchLocation = data.get("preferredSearchLocation");
        if (preferredSearchLocation != null) {
            suggestParameters.setPreferredSearchLocation(toPoint(preferredSearchLocation));
        }
        final Object searchArea = data.get("searchArea");
        if (searchArea != null) {
            suggestParameters.setSearchArea(toGeometry(searchArea));
        }

        return suggestParameters;
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

    public interface ISuggestResultTagProvider {
        String getTag(SuggestResult suggestResult);
    }

    public static Object suggestResultsToJson(List<SuggestResult> results, ISuggestResultTagProvider tagProvider) {
        final List<Object> jsonResults = new ArrayList<>(results.size());
        for (final SuggestResult result : results) {
            jsonResults.add(suggestResultToJson(result,tagProvider));
        }
        return jsonResults;
    }

    private static Object suggestResultToJson(SuggestResult result, ISuggestResultTagProvider tagProvider) {
        final Map<String, Object> data = new HashMap<>(3);
        data.put("label", result.getLabel());
        data.put("isCollection", result.isCollection());
        data.put("suggestResultId", tagProvider.getTag(result));
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
