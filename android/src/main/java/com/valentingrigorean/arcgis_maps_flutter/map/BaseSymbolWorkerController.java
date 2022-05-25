package com.valentingrigorean.arcgis_maps_flutter.map;

import android.util.Log;

import java.util.concurrent.Executor;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public abstract class BaseSymbolWorkerController {
    private static ExecutorService executor = Executors.newSingleThreadExecutor();
    private boolean isActive = true;

    public void setWorkerIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    protected void execute(final Runnable runnable) {
        if (isActive) {
            executor.execute(new Runnable() {
                @Override
                public void run() {
                    try {
                        runnable.run();
                    } catch (Exception ex) {
                        Log.w(this.getClass().getName(), "Failed to execute", ex);
                    }
                }
            });
        }
    }

    public static void clear(Runnable runnable){
        executor.execute(runnable);
    }
}
