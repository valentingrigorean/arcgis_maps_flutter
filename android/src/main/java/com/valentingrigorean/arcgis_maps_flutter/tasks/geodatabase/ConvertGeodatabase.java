package com.valentingrigorean.arcgis_maps_flutter.tasks.geodatabase;

import com.esri.arcgisruntime.data.FeatureEditResult;
import com.esri.arcgisruntime.data.SyncModel;
import com.esri.arcgisruntime.tasks.geodatabase.GenerateGeodatabaseParameters;
import com.esri.arcgisruntime.tasks.geodatabase.GenerateLayerOption;
import com.esri.arcgisruntime.tasks.geodatabase.GeodatabaseDeltaInfo;
import com.esri.arcgisruntime.tasks.geodatabase.SyncGeodatabaseParameters;
import com.esri.arcgisruntime.tasks.geodatabase.SyncLayerOption;
import com.esri.arcgisruntime.tasks.geodatabase.SyncLayerResult;
import com.esri.arcgisruntime.tasks.geodatabase.UtilityNetworkSyncMode;
import com.valentingrigorean.arcgis_maps_flutter.Convert;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ConvertGeodatabase extends Convert {

    public static Object geodatabaseDeltaInfoToJson(GeodatabaseDeltaInfo geodatabaseDeltaInfo) {
        final HashMap<String, Object> data = new HashMap<>(4);
        if (geodatabaseDeltaInfo.getDownloadDeltaPath() != null) {
            data.put("downloadDeltaFileUrl", geodatabaseDeltaInfo.getDownloadDeltaPath());
        }
        data.put("featureServiceUrl", geodatabaseDeltaInfo.getFeatureServiceUrl());
        data.put("geodatabaseFileUrl", geodatabaseDeltaInfo.getGeodatabasePath());
        if (geodatabaseDeltaInfo.getUploadDeltaPath() != null) {
            data.put("uploadDeltaFileUrl", geodatabaseDeltaInfo.getUploadDeltaPath());
        }
        return data;
    }


    public static Object syncGeodatabaseParametersToJson(SyncGeodatabaseParameters syncGeodatabaseParameters) {
        final HashMap<String, Object> data = new HashMap<>(4);
        data.put("keepGeodatabaseDeltas", syncGeodatabaseParameters.isKeepGeodatabaseDeltas());
        data.put("geodatabaseSyncDirection", syncDirectionToJson(syncGeodatabaseParameters.getSyncDirection()));
        data.put("layerOptions", syncLayerOptionsToJson(syncGeodatabaseParameters.getLayerOptions()));
        data.put("rollbackOnFailure", syncGeodatabaseParameters.isRollbackOnFailure());
        return data;
    }

    public static SyncGeodatabaseParameters toSyncGeodatabaseParameters(Object o) {
        final Map<?, ?> data = toMap(o);
        final SyncGeodatabaseParameters syncGeodatabaseParameters = new SyncGeodatabaseParameters();
        syncGeodatabaseParameters.setKeepGeodatabaseDeltas(toBoolean(data.get("keepGeodatabaseDeltas")));
        syncGeodatabaseParameters.setSyncDirection(toSyncDirection(data.get("geodatabaseSyncDirection")));
        syncGeodatabaseParameters.getLayerOptions().addAll(toSyncLayerOptions(data.get("layerOptions")));
        syncGeodatabaseParameters.setRollbackOnFailure(toBoolean(data.get("rollbackOnFailure")));
        return syncGeodatabaseParameters;
    }

    private static Collection<SyncLayerOption> toSyncLayerOptions(Object layerOptions) {
        final List<?> data = toList(layerOptions);
        final ArrayList<SyncLayerOption> syncLayerOptions = new ArrayList<>(data.size());
        for (final Object layerOption : data) {
            syncLayerOptions.add(toSyncLayerOption(layerOption));
        }
        return syncLayerOptions;
    }

    public static Object syncLayerResultsToJson(List<SyncLayerResult> syncResults) {
        final ArrayList<Object> data = new ArrayList<>(syncResults.size());
        for (final SyncLayerResult layerResult : syncResults) {
            data.add(syncLayerResultToJson(layerResult));
        }
        return data;
    }

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

    private static Object syncLayerOptionsToJson(List<SyncLayerOption> syncLayerOptions) {
        final ArrayList<Object> data = new ArrayList<>(syncLayerOptions.size());
        for (final SyncLayerOption layerOption : syncLayerOptions) {
            data.add(syncLayerOptionToJson(layerOption));
        }
        return data;
    }

    private static Object syncLayerOptionToJson(SyncLayerOption syncLayerOption) {
        final HashMap<String, Object> data = new HashMap<>(2);
        data.put("layerId", syncLayerOption.getLayerId());
        data.put("syncDirection", syncDirectionToJson(syncLayerOption.getSyncDirection()));
        return data;
    }

    private static SyncLayerOption toSyncLayerOption(Object json) {
        final Map<?, ?> data = toMap(json);
        final Object layerId = data.get("layerId");
        final Object syncDirection = data.get("syncDirection");
        return new SyncLayerOption(toInt(layerId), toSyncDirection(syncDirection));
    }

    private static Object syncLayerResultToJson(SyncLayerResult syncResult) {
        final HashMap<String, Object> json = new HashMap<>(3);

        final ArrayList<Object> editsResults = new ArrayList<>(syncResult.getEditResults().size());
        for (final FeatureEditResult editResult : syncResult.getEditResults()) {
            editsResults.add(featureEditResultToJson(editResult));
        }
        json.put("editResults", editsResults);
        json.put("layerId", syncResult.getLayerId());
        json.put("tableName", syncResult.getTableName());
        return json;
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
