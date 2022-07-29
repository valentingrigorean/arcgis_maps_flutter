package com.valentingrigorean.arcgis_maps_flutter.tasks.geodatabase;

import com.esri.arcgisruntime.data.SyncModel;
import com.esri.arcgisruntime.tasks.geodatabase.GenerateGeodatabaseParameters;
import com.esri.arcgisruntime.tasks.geodatabase.GenerateLayerOption;
import com.esri.arcgisruntime.tasks.geodatabase.UtilityNetworkSyncMode;
import com.valentingrigorean.arcgis_maps_flutter.Convert;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ConvertGeodatabase extends Convert {
    public static Object generateGeodatabaseParametersToJson(GenerateGeodatabaseParameters parameters) {
        final HashMap<String, Object> json = new HashMap<>();
        json.put("attachmentSyncDirection", attachmentSyncDirectionToJson(parameters.getAttachmentSyncDirection()));
        if (parameters.getExtent() != null) {
            json.put("extent", geometryToJson(parameters.getExtent()));
        }
        final ArrayList<Object> layersOptions = new ArrayList<>();
        for (GenerateLayerOption option : parameters.getLayerOptions()) {
            layersOptions.add(generateLayerOptionToJson(option));
        }
        json.put("layerOptions", layersOptions);
        if (parameters.getOutSpatialReference() != null) {
            json.put("outSpatialReference", spatialReferenceToJson(parameters.getOutSpatialReference()));
        }
        json.put("returnAttachments", parameters.isReturnAttachments());
        json.put("shouldSyncContingentValues", parameters.getSyncContingentValues());
        json.put("syncModel", parameters.getSyncModel().ordinal());
        json.put("utilityNetworkSyncMode", parameters.getUtilityNetworkSyncMode().ordinal());
        return json;
    }

    public static GenerateGeodatabaseParameters toGenerateGeodatabaseParameters(Object json) {
        final Map<?, ?> data = toMap(json);
        final Object attachmentSyncDirection = data.get("attachmentSyncDirection");
        final Object extent = data.get("extent");
        final List<?> layerOptions = toList(data.get("layerOptions"));
        final Object outSpatialReference = data.get("outSpatialReference");
        final Object returnAttachments = data.get("returnAttachments");
        final Object shouldSyncContingentValues = data.get("shouldSyncContingentValues");
        final Object syncModel = data.get("syncModel");
        final Object utilityNetworkSyncMode = data.get("utilityNetworkSyncMode");

        final GenerateGeodatabaseParameters parameters = new GenerateGeodatabaseParameters();

        parameters.setAttachmentSyncDirection(toAttachmentSyncDirection(attachmentSyncDirection));
        if (extent != null) {
            parameters.setExtent(toGeometry(extent));
        }
        for (final Object layerOption : layerOptions) {
            parameters.getLayerOptions().add(toGenerateLayerOption(layerOption));
        }
        if (outSpatialReference != null) {
            parameters.setOutSpatialReference(toSpatialReference(outSpatialReference));
        }
        parameters.setReturnAttachments(toBoolean(returnAttachments));
        parameters.setSyncContingentValues(toBoolean(shouldSyncContingentValues));
        parameters.setSyncModel(SyncModel.values()[toInt(syncModel)]);
        parameters.setUtilityNetworkSyncMode(UtilityNetworkSyncMode.values()[toInt(utilityNetworkSyncMode)]);
        
        return parameters;
    }


    private static Object generateLayerOptionToJson(GenerateLayerOption layerOption) {
        final HashMap<String, Object> json = new HashMap<>(5);
        json.put("layerId", layerOption.getLayerId());
        json.put("includeRelated", layerOption.isIncludeRelated());
        json.put("queryOption", layerOption.getQueryOption().ordinal());
        json.put("useGeometry", layerOption.isUseGeometry());
        json.put("whereClause", layerOption.getWhereClause());
        return json;
    }

    private static GenerateLayerOption toGenerateLayerOption(Object json) {
        final Map<?, ?> data = toMap(json);
        final GenerateLayerOption layerOption = new GenerateLayerOption();
        layerOption.setLayerId(Convert.toLong(data.get("layerId")));
        layerOption.setIncludeRelated(toBoolean(data.get("includeRelated")));
        layerOption.setQueryOption(GenerateLayerOption.QueryOption.values()[Convert.toInt(data.get("queryOption"))]);
        layerOption.setUseGeometry(toBoolean(data.get("useGeometry")));
        layerOption.setWhereClause((String) data.get("whereClause"));
        return layerOption;
    }

    private static int attachmentSyncDirectionToJson(GenerateGeodatabaseParameters.AttachmentSyncDirection direction) {
        switch (direction) {
            case UPLOAD:
                return 1;
            case BIDIRECTIONAL:
                return 2;
            default:
                return 0;
        }
    }

    private static GenerateGeodatabaseParameters.AttachmentSyncDirection toAttachmentSyncDirection(Object direction) {
        switch (toInt(direction)) {
            case 1:
                return GenerateGeodatabaseParameters.AttachmentSyncDirection.UPLOAD;
            case 2:
                return GenerateGeodatabaseParameters.AttachmentSyncDirection.BIDIRECTIONAL;
            default:
                return GenerateGeodatabaseParameters.AttachmentSyncDirection.NONE;
        }
    }
}
