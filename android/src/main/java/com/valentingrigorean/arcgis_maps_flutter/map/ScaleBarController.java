package com.valentingrigorean.arcgis_maps_flutter.map;

import android.content.Context;
import android.view.ViewPropertyAnimator;
import android.widget.FrameLayout;

import com.esri.arcgisruntime.mapping.view.MapScaleChangedEvent;
import com.esri.arcgisruntime.mapping.view.MapScaleChangedListener;
import com.esri.arcgisruntime.mapping.view.MapView;
import com.valentingrigorean.arcgis_maps_flutter.Convert;
import com.valentingrigorean.arcgis_maps_flutter.toolkit.scalebar.Scalebar;

import java.util.List;
import java.util.Map;

public class ScaleBarController implements MapScaleChangedListener {
    private final Context context;
    private final MapView mapView;
    private final FrameLayout container;
    private final Scalebar scalebar;

    private ScaleBarState scaleBarState;

    private FrameLayout.LayoutParams layoutParams;

    private boolean autoHide = false;
    private int hideAfterMS = 2000;
    private ViewPropertyAnimator viewPropertyAnimator;


    public ScaleBarController(Context context, MapView mapView, FrameLayout container) {
        this.context = context;
        this.mapView = mapView;
        this.container = container;
        scalebar = new Scalebar(context);
        mapView.addMapScaleChangedListener(this);
    }

    public void dispose() {
        removeScaleBar();
        mapView.removeMapScaleChangedListener(this);
    }

    public void removeScaleBar() {
        switch (scaleBarState) {
            case NONE:
                break;
            case IN_MAP:
                scalebar.removeFromMapView();
                break;
            case IN_CONTAINER:
                container.removeView(scalebar);
                break;
        }
        scaleBarState = ScaleBarState.NONE;
    }


    @Override
    public void mapScaleChanged(MapScaleChangedEvent mapScaleChangedEvent) {
        if (viewPropertyAnimator != null)
            viewPropertyAnimator.cancel();
        scalebar.setAlpha(1f);
        if (!autoHide)
            return;
        viewPropertyAnimator = scalebar.animate()
                .setDuration(hideAfterMS)
                .alpha(0)
                .withEndAction(() -> {
                    viewPropertyAnimator = null;
                });
    }

    public void interpretConfiguration(Object o) {
        final Map<?, ?> data = Convert.toMap(o);
        if (data == null) {
            removeScaleBar();
            return;
        }

        final boolean showInMap = Convert.toBoolean(data.get("showInMap"));

        if (showInMap && scaleBarState != ScaleBarState.IN_MAP) {
            scaleBarState = ScaleBarState.IN_MAP;
            scalebar.addToMapView(mapView);

            final Object inMapAlignment = data.get("inMapAlignment");
            if (inMapAlignment != null) {
                scalebar.setAlignment(Convert.toScaleBarAlignment(Convert.toInt(inMapAlignment)));
            }
        } else {

            final int width = Convert.dpToPixels(context, Convert.toInt(data.get("width")));
            final int height = Convert.dpToPixels(context, Convert.toInt(data.get("height")));
            final List<?> offsetPoints = Convert.toList(data.get("offset"));


            if (scaleBarState != ScaleBarState.IN_CONTAINER) {
                scaleBarState = ScaleBarState.IN_CONTAINER;
                layoutParams = new FrameLayout.LayoutParams(width, height);
                container.addView(scalebar, layoutParams);
            } else {
                layoutParams.width = width;
                layoutParams.height = height;
            }

            layoutParams.topMargin = Convert.dpToPixels(context, Convert.toInt(offsetPoints.get(0)));
            layoutParams.leftMargin = Convert.dpToPixels(context, Convert.toInt(offsetPoints.get(1)));
        }

        this.autoHide = Convert.toBoolean(data.get("autoHide"));
        this.hideAfterMS = Convert.toInt(data.get("hideAfter"));

        scalebar.setUnitSystem(Convert.toUnitSystem(Convert.toInt(data.get("units"))));
        scalebar.setStyle(Convert.toScaleBarStyle(Convert.toInt(data.get("style"))));

        scalebar.setFillColor(Convert.toInt(data.get("fillColor")));
        scalebar.setAlternateFillColor(Convert.toInt(data.get("alternateFillColor")));
        scalebar.setLineColor(Convert.toInt(data.get("lineColor")));
        scalebar.setShadowColor(Convert.toInt(data.get("shadowColor")));
        scalebar.setTextColor(Convert.toInt(data.get("textColor")));
        scalebar.setTextShadowColor(Convert.toInt(data.get("textShadowColor")));
    }


    private enum ScaleBarState {
        NONE,
        IN_MAP,
        IN_CONTAINER,
    }
}
