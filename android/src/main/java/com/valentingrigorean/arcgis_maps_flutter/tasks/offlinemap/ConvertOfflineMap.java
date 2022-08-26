package com.valentingrigorean.arcgis_maps_flutter.tasks.offlinemap;

import com.esri.arcgisruntime.geometry.Geometry;
import com.esri.arcgisruntime.tasks.geodatabase.GenerateGeodatabaseParameters;
import com.esri.arcgisruntime.tasks.geodatabase.GeodatabaseDeltaInfo;
import com.esri.arcgisruntime.tasks.offlinemap.GenerateOfflineMapParameters;
import com.esri.arcgisruntime.tasks.offlinemap.GenerateOfflineMapUpdateMode;
import com.esri.arcgisruntime.tasks.offlinemap.OfflineMapItemInfo;
import com.esri.arcgisruntime.tasks.offlinemap.OfflineMapSyncParameters;
import com.esri.arcgisruntime.tasks.offlinemap.OfflineMapSyncResult;
import com.esri.arcgisruntime.tasks.offlinemap.OfflineMapUpdateCapabilities;
import com.esri.arcgisruntime.tasks.offlinemap.OfflineMapUpdatesInfo;
import com.esri.arcgisruntime.tasks.offlinemap.OfflineUpdateAvailability;
import com.esri.arcgisruntime.tasks.offlinemap.PreplannedScheduledUpdatesOption;
import com.esri.arcgisruntime.tasks.vectortilecache.EsriVectorTilesDownloadOption;
import com.valentingrigorean.arcgis_maps_flutter.Convert;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

public class ConvertOfflineMap extends Convert {
    public static Object generateOfflineMapParametersToJson(GenerateOfflineMapParameters parameters) {
        final HashMap<String, Object> data = new HashMap<>(16);
        data.put("areaOfInterest", Convert.geometryToJson(parameters.getAreaOfInterest()));
        data.put("minScale", parameters.getMinScale());
        data.put("maxScale", parameters.getMaxScale());
        data.put("onlineOnlyServicesOption", parameters.getOnlineOnlyServicesOption().ordinal());
        if (parameters.getItemInfo() != null) {
            data.put("itemInfo", offlineMapItemInfoToJson(parameters.getItemInfo()));
        }
        data.put("attachmentSyncDirection", attachmentSyncDirectionToJson(parameters.getAttachmentSyncDirection()));
        data.put("continueOnErrors", parameters.isContinueOnErrors());
        data.put("includeBasemap", parameters.isIncludeBasemap());
        data.put("isDefinitionExpressionFilterEnabled", parameters.isDefinitionExpressionFilterEnabled());
        data.put("returnLayerAttachmentOption", returnLayerAttachmentOptionToJson(parameters.getReturnLayerAttachmentOption()));
        data.put("returnSchemaOnlyForEditableLayers", parameters.isReturnSchemaOnlyForEditableLayers());
        data.put("updateMode", parameters.getUpdateMode().ordinal());
        data.put("destinationTableRowFilter", parameters.getDestinationTableRowFilter().ordinal());
        data.put("esriVectorTilesDownloadOption", parameters.getEsriVectorTilesDownloadOption().ordinal());
        data.put("referenceBasemapDirectory", parameters.getReferenceBasemapDirectory());
        data.put("referenceBasemapFilename", parameters.getReferenceBasemapFilename());
        return data;
    }

    public static GenerateOfflineMapParameters toGenerateOfflineMapParameters(Object json) {
        final Map<?, ?> data = toMap(json);
        final Geometry areaOfInterest = toGeometry(data.get("areaOfInterest"));
        final double minScale = toDouble(data.get("minScale"));
        final double maxScale = toDouble(data.get("maxScale"));

        final GenerateOfflineMapParameters parameters = new GenerateOfflineMapParameters(areaOfInterest, minScale, maxScale);
        parameters.setOnlineOnlyServicesOption(GenerateOfflineMapParameters.OnlineOnlyServicesOption.values()[toInt(data.get("onlineOnlyServicesOption"))]);

        final Object itemInfo = data.get("itemInfo");
        if (itemInfo != null) {
            parameters.setItemInfo(toOfflineMapItemInfo(itemInfo));
        }

        parameters.setAttachmentSyncDirection(toAttachmentSyncDirection(data.get("attachmentSyncDirection")));
        parameters.setContinueOnErrors(toBoolean(data.get("continueOnErrors")));
        parameters.setIncludeBasemap(toBoolean(data.get("includeBasemap")));
        parameters.setDefinitionExpressionFilterEnabled(toBoolean(data.get("isDefinitionExpressionFilterEnabled")));
        parameters.setReturnLayerAttachmentOption(toReturnLayerAttachmentOption(data.get("returnLayerAttachmentOption")));
        parameters.setReturnSchemaOnlyForEditableLayers(toBoolean(data.get("returnSchemaOnlyForEditableLayers")));
        parameters.setUpdateMode(GenerateOfflineMapUpdateMode.values()[toInt(data.get("updateMode"))]);
        parameters.setDestinationTableRowFilter(GenerateOfflineMapParameters.DestinationTableRowFilter.values()[toInt(data.get("destinationTableRowFilter"))]);
        parameters.setEsriVectorTilesDownloadOption(EsriVectorTilesDownloadOption.values()[toInt(data.get("esriVectorTilesDownloadOption"))]);
        final Object referenceBasemapDirectory = data.get("referenceBasemapDirectory");
        if (referenceBasemapDirectory != null) {
            parameters.setReferenceBasemapDirectory((String) referenceBasemapDirectory);
        }
        parameters.setReferenceBasemapFilename((String) data.get("referenceBasemapFilename"));
        return parameters;
    }

    public static Object offlineMapUpdateCapabilitiesToJson(OfflineMapUpdateCapabilities capabilities) {
        final HashMap<String, Object> data = new HashMap<>(2);
        data.put("supportsScheduledUpdatesForFeatures", capabilities.isSupportsScheduledUpdatesForFeatures());
        data.put("supportsSyncWithFeatureServices", capabilities.isSupportsSyncWithFeatureServices());
        return data;
    }

    public static Object offlineMapUpdatesInfoToJson(OfflineMapUpdatesInfo offlineMapUpdatesInfo) {
        final HashMap<String, Object> data = new HashMap<>(4);
        data.put("downloadAvailability", offlineUpdateAvailabilityToJson(offlineMapUpdatesInfo.getDownloadAvailability()));
        data.put("isMobileMapPackageReopenRequired", offlineMapUpdatesInfo.isMobileMapPackageReopenRequired());
        data.put("scheduledUpdatesDownloadSize", offlineMapUpdatesInfo.getScheduledUpdatesDownloadSize());
        data.put("uploadAvailability", offlineUpdateAvailabilityToJson(offlineMapUpdatesInfo.getUploadAvailability()));
        return data;
    }

    public static Object offlineMapSyncParametersToJson(OfflineMapSyncParameters offlineMapSyncParameters) {
        final HashMap<String, Object> data = new HashMap<>(4);
        data.put("keepGeodatabaseDeltas", offlineMapSyncParameters.isKeepGeodatabaseDeltas());
        data.put("preplannedScheduledUpdatesOption", offlineMapSyncParameters.getPreplannedScheduledUpdatesOption().ordinal());
        data.put("rollbackOnFailure", offlineMapSyncParameters.isRollbackOnFailure());
        data.put("syncDirection", syncDirectionToJson(offlineMapSyncParameters.getSyncDirection()));
        return data;
    }

    public static OfflineMapSyncParameters toOfflineMapSyncParameters(Object json) {
        final Map<?, ?> data = toMap(json);
        final OfflineMapSyncParameters parameters = new OfflineMapSyncParameters();
        parameters.setKeepGeodatabaseDeltas(toBoolean(data.get("keepGeodatabaseDeltas")));
        parameters.setPreplannedScheduledUpdatesOption(PreplannedScheduledUpdatesOption.values()[toInt(data.get("preplannedScheduledUpdatesOption"))]);
        parameters.setRollbackOnFailure(toBoolean(data.get("rollbackOnFailure")));
        parameters.setSyncDirection(toSyncDirection(toInt(data.get("syncDirection"))));
        return parameters;
    }


    public static Object offlineMapSyncResultToJson(OfflineMapSyncResult result) {
        final HashMap<String, Object> data = new HashMap<>(2);
        data.put("hasErrors", result.hasErrors());
        data.put("isMobileMapPackageReopenRequired", result.isMobileMapPackageReopenRequired());
        return data;
    }

    private static Object offlineMapItemInfoToJson(OfflineMapItemInfo itemInfo) {
        final HashMap<String, Object> data = new HashMap<>(7);
        data.put("accessInformation", itemInfo.getAccessInformation());
        data.put("itemDescription", itemInfo.getDescription());
        data.put("snippet", itemInfo.getSnippet());
        data.put("tags", itemInfo.getTags());
        data.put("termsOfUse", itemInfo.getTermsOfUse());
        data.put("title", itemInfo.getTitle());
        if (itemInfo.getThumbnailData() != null) {
            data.put("thumbnail", itemInfo.getThumbnailData());
        }
        return data;
    }

    private static OfflineMapItemInfo toOfflineMapItemInfo(Object json) {
        final Map<?, ?> data = toMap(json);
        final OfflineMapItemInfo mapItemInfo = new OfflineMapItemInfo();
        mapItemInfo.setAccessInformation((String) data.get("accessInformation"));
        mapItemInfo.setDescription((String) data.get("itemDescription"));
        mapItemInfo.setSnippet((String) data.get("snippet"));
        for (Object item : toList(data.get("tags"))) {
            mapItemInfo.getTags().add((String) item);
        }
        mapItemInfo.setTermsOfUse((String) data.get("termsOfUse"));
        mapItemInfo.setTitle((String) data.get("title"));

        final Object thumbnail = data.get("thumbnail");
        if (thumbnail != null) {
            mapItemInfo.setThumbnailData((byte[]) thumbnail);
        }
        return mapItemInfo;
    }

    private static GenerateOfflineMapParameters.ReturnLayerAttachmentOption toReturnLayerAttachmentOption(Object json) {
        switch (toInt(json)) {
            case 1:
                return GenerateOfflineMapParameters.ReturnLayerAttachmentOption.ALL_LAYERS;
            case 2:
                return GenerateOfflineMapParameters.ReturnLayerAttachmentOption.READ_ONLY_LAYERS;
            case 3:
                return GenerateOfflineMapParameters.ReturnLayerAttachmentOption.EDITABLE_LAYERS;
            default:
                return GenerateOfflineMapParameters.ReturnLayerAttachmentOption.NONE;
        }
    }

    private static int returnLayerAttachmentOptionToJson(GenerateOfflineMapParameters.ReturnLayerAttachmentOption option) {
        switch (option) {
            case ALL_LAYERS:
                return 1;
            case READ_ONLY_LAYERS:
                return 2;
            case EDITABLE_LAYERS:
                return 3;
            default:
                return 0;
        }
    }

    private static GenerateGeodatabaseParameters.AttachmentSyncDirection toAttachmentSyncDirection(Object json) {
        switch (toInt(json)) {
            case 1:
                return GenerateGeodatabaseParameters.AttachmentSyncDirection.UPLOAD;
            case 2:
                return GenerateGeodatabaseParameters.AttachmentSyncDirection.BIDIRECTIONAL;
            default:
                return GenerateGeodatabaseParameters.AttachmentSyncDirection.NONE;
        }
    }

    private static int attachmentSyncDirectionToJson(GenerateGeodatabaseParameters.AttachmentSyncDirection attachmentSyncDirection) {
        switch (attachmentSyncDirection) {
            case UPLOAD:
                return 1;
            case BIDIRECTIONAL:
                return 2;
            default:
                return 0;
        }
    }

    private static int offlineUpdateAvailabilityToJson(OfflineUpdateAvailability availability) {
        switch (availability) {
            case AVAILABLE:
                return 0;
            case NONE:
                return 1;
            default:
                return -1;
        }
    }


}
