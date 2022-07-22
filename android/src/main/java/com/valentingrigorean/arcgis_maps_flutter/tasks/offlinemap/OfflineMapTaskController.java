package com.valentingrigorean.arcgis_maps_flutter.tasks.offlinemap;

import androidx.annotation.NonNull;

import com.esri.arcgisruntime.concurrent.ListenableFuture;
import com.esri.arcgisruntime.geometry.Geometry;
import com.esri.arcgisruntime.mapping.ArcGISMap;
import com.esri.arcgisruntime.mapping.MobileMapPackage;
import com.esri.arcgisruntime.portal.PortalItem;
import com.esri.arcgisruntime.tasks.offlinemap.GenerateOfflineMapJob;
import com.esri.arcgisruntime.tasks.offlinemap.GenerateOfflineMapParameters;
import com.esri.arcgisruntime.tasks.offlinemap.GenerateOfflineMapResult;
import com.esri.arcgisruntime.tasks.offlinemap.OfflineMapTask;
import com.valentingrigorean.arcgis_maps_flutter.Convert;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class OfflineMapTaskController implements MethodChannel.MethodCallHandler {
    private final MethodChannel channel;
    private final BinaryMessenger messenger;
    private final Map<Integer, OfflineMapTask> offlineMapTasks = new HashMap<>();
    private final Map<Integer, ArrayList<GenerateOfflineMapJobController>> generateOfflineMapJobControllers = new HashMap<>();
    private final Map<Integer, GenerateOfflineMapJobController> generateOfflineMapJobControllersById = new HashMap<>();

    public OfflineMapTaskController(BinaryMessenger messenger) {
        this.messenger = messenger;
        channel = new MethodChannel(messenger, "plugins.flutter.io/arcgis_channel/offline_map_task");
        channel.setMethodCallHandler(this);
    }

    public void dispose() {
        channel.setMethodCallHandler(null);
    }

    @Override
    protected void finalize() throws Throwable {
        dispose();
        super.finalize();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "createOfflineMapTask":
                createOfflineMapTask(call.arguments());
                result.success(null);
                break;
            case "destroyOfflineMapTask":
                offlineMapTasks.remove(call.arguments());
                final ArrayList<GenerateOfflineMapJobController> controllers = generateOfflineMapJobControllers.remove(call.arguments());
                for (GenerateOfflineMapJobController controller : controllers) {
                    controller.dispose();
                }
                result.success(null);
                break;
            case "defaultGenerateOfflineMapParameters":
                defaultGenerateOfflineMapParameters(call.arguments(), result);
                break;
            case "destroyGenerateOfflineMapJob":
                final int id = call.arguments();
                final GenerateOfflineMapJobController controller = generateOfflineMapJobControllersById.remove(id);
                if (controller != null) {
                    controller.dispose();
                }
                generateOfflineMapJobControllers.forEach((key, value) -> value.remove(controller));
                result.success(null);
                break;
            case "generateOfflineMap":
                generateOfflineMap(call.arguments(), result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void generateOfflineMap(Map<?, ?> data, MethodChannel.Result result) {
        final int id = (int) data.get("id");
        final int jobId = (int) data.get("jobId");
        final GenerateOfflineMapParameters parameters = ConvertOfflineMap.toGenerateOfflineMapParameters(data.get("parameters"));
        final OfflineMapTask offlineMapTask = offlineMapTasks.get(id);
        final String downloadDirectory = (String) data.get("downloadDirectory");
        final GenerateOfflineMapJob offlineMapJob = offlineMapTask.generateOfflineMap(parameters, downloadDirectory);
        final GenerateOfflineMapJobController controller = new GenerateOfflineMapJobController(messenger, jobId, offlineMapJob);
        generateOfflineMapJobControllers.get(id).add(controller);
        generateOfflineMapJobControllersById.put(jobId, controller);
        result.success(null);
    }

    private void defaultGenerateOfflineMapParameters(Map<?, ?> data, MethodChannel.Result result) {
        final int id = (int) data.get("id");
        final OfflineMapTask offlineMapTask = offlineMapTasks.get(id);
        final Geometry areaOfInterest = Convert.toGeometry(data.get("areaOfInterest"));
        final Object minScale = data.get("minScale");
        final Object maxScale = data.get("maxScale");
        ListenableFuture<GenerateOfflineMapParameters> future;
        if (minScale == null) {
            future = offlineMapTask.createDefaultGenerateOfflineMapParametersAsync(areaOfInterest);
        } else {
            future = offlineMapTask.createDefaultGenerateOfflineMapParametersAsync(areaOfInterest, (double) minScale, (double) maxScale);
        }

        future.addDoneListener(() -> {
            try {
                final GenerateOfflineMapParameters parameters = future.get();
                result.success(ConvertOfflineMap.generateOfflineMapParametersToJson(parameters));
            } catch (Exception e) {
                result.error("defaultGenerateOfflineMapParameters", e.getMessage(), null);
            }
        });
    }

    private void createOfflineMapTask(Map<?, ?> data) {
        OfflineMapTask offlineMapTask;
        final Object map = data.get("map");
        final Object portalItem = data.get("portalItem");
        if (map != null) {
            ArcGISMap arcGISMap = Convert.toArcGISMap(map);
            offlineMapTask = new OfflineMapTask(arcGISMap);
        } else if (portalItem != null) {
            final PortalItem nativePortalItem = Convert.toPortalItem(portalItem);
            offlineMapTask = new OfflineMapTask(nativePortalItem);
        } else {
            throw new IllegalArgumentException("Map or PortalItem is required");
        }

        final int id = (int) data.get("id");
        offlineMapTasks.put(id, offlineMapTask);
        final Object credentials = data.get("credentials");
        if (credentials != null) {
            offlineMapTask.setCredential(Convert.toCredentials(credentials));
        }
        generateOfflineMapJobControllers.put(id, new ArrayList<>());
    }
}
