package com.valentingrigorean.arcgis_maps_flutter.tasks.tilecache;

import androidx.annotation.NonNull;

import com.esri.arcgisruntime.tasks.tilecache.ExportTileCacheParameters;
import com.valentingrigorean.arcgis_maps_flutter.Convert;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class ConvertTileCache extends Convert {

    @NonNull
    public static ExportTileCacheParameters toExportTileCacheParameters(Object o) {
        final Map<?, ?> data = toMap(o);
        final ExportTileCacheParameters parameters = new ExportTileCacheParameters();
        final Object areaOfInterest = data.get("areaOfInterest");
        if (areaOfInterest != null) {
            parameters.setAreaOfInterest(Convert.toGeometry(areaOfInterest));
        }
        parameters.setCompressionQuality(toFloat(data.get("compressionQuality")));
        parameters.getLevelIDs().addAll(toList(data.get("levelIds")).stream().map(i -> toInt(i)).collect(java.util.stream.Collectors.toList()));
        return parameters;
    }

    public static Object exportTileCacheParametersToJson(@NonNull ExportTileCacheParameters parameters) {
        final Map<String, Object> data = new HashMap<>(3);
        if (parameters.getAreaOfInterest() != null) {
            data.put("areaOfInterest", Convert.geometryToJson(parameters.getAreaOfInterest()));
        }
        data.put("compressionQuality", parameters.getCompressionQuality());
        data.put("levelIds", parameters.getLevelIDs());

        return data;
    }
}
