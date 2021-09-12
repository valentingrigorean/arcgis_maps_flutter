package com.valentingrigorean.arcgis_maps_flutter.utils;

import com.esri.arcgisruntime.loadable.LoadStatus;
import com.esri.arcgisruntime.loadable.Loadable;
import com.esri.arcgisruntime.mapping.LayerList;

import java.util.Collection;
import java.util.HashSet;

public class AGSLoadObjects {
    private AGSLoadObjects() {

    }

    public interface LoadObjectsResult {
        void completed(boolean loaded);
    }

    public static void load(LayerList array, LoadObjectsResult callback) {
        final HashSet<Loadable> loadedItems = new HashSet<>(array.size());

        final LoadingStatus loadingStatus = new LoadingStatus();

        for (final Loadable loadable : array) {

            switch (loadable.getLoadStatus()) {
                case LOADED:
                    loadedItems.add(loadable);
                    if (didFinishLoading(loadedItems, array.size())) {
                        if (callback != null) {
                            callback.completed(didFinishWithNoErrors(loadedItems));
                            loadingStatus.setFinish();
                        }
                    }
                    break;
                case FAILED_TO_LOAD:
                    if (callback != null) {
                        callback.completed(false);
                        loadingStatus.setFinish();
                    }
                    return;
                case LOADING:
                case NOT_LOADED:
                    loadable.addDoneLoadingListener(() -> {
                        if (loadingStatus.isFinish()) {
                            return;
                        }
                        if (loadable.getLoadStatus() != LoadStatus.LOADED) {
                            if (callback != null) {
                                callback.completed(false);
                                loadingStatus.setFinish();
                            }
                        } else {
                            loadedItems.add(loadable);
                            if (didFinishLoading(loadedItems, array.size())) {
                                if (callback != null) {
                                    callback.completed(didFinishWithNoErrors(loadedItems));
                                    loadingStatus.setFinish();
                                }
                            }
                        }
                    });
                    loadable.loadAsync();
                    break;
            }

        }
    }

    private static boolean didFinishLoading(Collection<Loadable> array, int count) {
        return array.size() == count;
    }

    private static boolean didFinishWithNoErrors(Collection<Loadable> array) {
        for (final Loadable loadable :
                array) {
            if (loadable.getLoadStatus() != LoadStatus.LOADED) {
                return false;
            }
        }
        return true;
    }

    private static class LoadingStatus {
        private boolean didFinish;


        public boolean isFinish() {
            return didFinish;
        }

        public void setFinish() {
            this.didFinish = true;
        }
    }
}
