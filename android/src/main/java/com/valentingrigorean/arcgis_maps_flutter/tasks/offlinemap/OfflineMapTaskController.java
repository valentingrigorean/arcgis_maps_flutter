package com.valentingrigorean.arcgis_maps_flutter.tasks.offlinemap;

import com.esri.arcgisruntime.mapping.MobileMapPackage;
import com.esri.arcgisruntime.tasks.offlinemap.GenerateOfflineMapJob;
import com.esri.arcgisruntime.tasks.offlinemap.GenerateOfflineMapResult;
import com.esri.arcgisruntime.tasks.offlinemap.OfflineMapTask;

import java.util.HashMap;
import java.util.Map;

public class OfflineMapTaskController {
    final Map<Integer, OfflineMapTask> offlineMapTasks = new HashMap<>();

    public OfflineMapTaskController(){
        GenerateOfflineMapResult result;
        MobileMapPackage mobileMapPackage;
        GenerateOfflineMapJob job;

        OfflineMapTask task;
    }
}
