package com.valentingrigorean.arcgis_maps_flutter.map;

import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

public abstract class BaseSymbolWorkerController {
    protected static Executor executor = Executors.newSingleThreadExecutor();

}
