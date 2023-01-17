package com.valentingrigorean.arcgis_maps_flutter.map;

import android.content.Context;
import android.view.ViewGroup;
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
    private final FlutterMapViewDelegate flutterMapViewDelegate;
    private final FrameLayout container;
    private final Scalebar scalebar;
    private ScaleBarState scaleBarState = ScaleBarState.NONE;
    private FrameLayout.LayoutParams layoutParams;
    private boolean isAutoHide = false;
    private int hideAfterMS = 2000;
    private ViewPropertyAnimator viewPropertyAnimator;
    private double mapScale;
    private boolean didGotScale = false;

    public ScaleBarController(Context context,FlutterMapViewDelegate flutterMapViewDelegate, FrameLayout container) {
        this.context = context;
        this.flutterMapViewDelegate = flutterMapViewDelegate;
        this.container = container;
        scalebar = new Scalebar(context);
        scalebar.setAlpha(0f);
        flutterMapViewDelegate.addMapScaleChangedListener(this);
    }

    public void dispose() {
        removeScaleBar();
        flutterMapViewDelegate.removeMapScaleChangedListener(this);
    }

    public void removeScaleBar() {
        switch (scaleBarState) {
            case NONE:
                break;
            case IN_MAP:
                scalebar.removeFromMapView();
                break;
            case IN_CONTAINER:
                scalebar.bindTo(null);
                container.removeView(scalebar);
                break;
        }
        scaleBarState = ScaleBarState.NONE;
    }


    @Override
    public void mapScaleChanged(MapScaleChangedEvent mapScaleChangedEvent) {
        if (viewPropertyAnimator != null) {
            viewPropertyAnimator.cancel();
            viewPropertyAnimator = null;
        }
        final double currentScale = mapScaleChangedEvent.getSource().getMapScale();
        if (mapScale == currentScale) {
            return;
        }

        mapScale = currentScale;

        if (!didGotScale) {
            didGotScale = true;
            return;
        }

        if (scaleBarState == ScaleBarState.NONE) {
            return;
        }
        if (!isAutoHide)
            return;
        scalebar.setAlpha(1f);
        viewPropertyAnimator = scalebar.animate()
                .setDuration(hideAfterMS)
                .alpha(0)
                .withEndAction(() -> viewPropertyAnimator = null);
    }

    public void interpretConfiguration(Object o) {
        final Map<?, ?> data = Convert.toMap(o);
        if (data == null) {
            removeScaleBar();
            return;
        }

        final boolean showInMap = Convert.toBoolean(data.get("showInMap"));

        validateScaleBarState(showInMap);

        if (showInMap) {
            final Object inMapAlignment = data.get("inMapAlignment");
            if (inMapAlignment != null) {
                scalebar.setAlignment(Convert.toScaleBarAlignment(Convert.toInt(inMapAlignment)));
            }
        } else {

            final int width = Convert.toInt(data.get("width"));
            final List<?> offsetPoints = Convert.toList(data.get("offset"));


            if (width < 0) {
                layoutParams.width = ViewGroup.LayoutParams.WRAP_CONTENT;
            } else {
                layoutParams.width = Convert.dpToPixelsI(context, width);
            }


            layoutParams.leftMargin = Convert.dpToPixelsI(context, Convert.toInt(offsetPoints.get(0)));
            layoutParams.topMargin = Convert.dpToPixelsI(context, Convert.toInt(offsetPoints.get(1)));
        }

        isAutoHide = Convert.toBoolean(data.get("autoHide"));
        hideAfterMS = Convert.toInt(data.get("hideAfter"));

        if (isAutoHide) {
            scalebar.setAlpha(0);
            mapScale = flutterMapViewDelegate.getMapScale();
        } else {
            scalebar.setAlpha(1f);
        }

        scalebar.setUnitSystem(Convert.toUnitSystem(Convert.toInt(data.get("units"))));
        scalebar.setStyle(Convert.toScaleBarStyle(Convert.toInt(data.get("style"))));

        scalebar.setFillColor(Convert.toInt(data.get("fillColor")));
        scalebar.setAlternateFillColor(Convert.toInt(data.get("alternateFillColor")));
        scalebar.setLineColor(Convert.toInt(data.get("lineColor")));
        scalebar.setShadowColor(Convert.toInt(data.get("shadowColor")));
        scalebar.setTextColor(Convert.toInt(data.get("textColor")));
        scalebar.setTextShadowColor(Convert.toInt(data.get("textShadowColor")));
        scalebar.setTextSize(Convert.spToPixels(context, Convert.toInt(data.get("textSize"))));
    }


    private void validateScaleBarState(boolean isInMap) {
        if (isInMap && scaleBarState != ScaleBarState.IN_MAP) {
            removeScaleBar();
            scalebar.addToMapView(flutterMapViewDelegate.getMapView());
            scaleBarState = ScaleBarState.IN_MAP;
        } else if (scaleBarState != ScaleBarState.IN_CONTAINER) {
            removeScaleBar();
            scalebar.bindTo(flutterMapViewDelegate.getMapView());
            layoutParams = new FrameLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT,
                    Convert.dpToPixelsI(context, 50));
            container.addView(scalebar, layoutParams);
            scaleBarState = ScaleBarState.IN_CONTAINER;
        }
    }

    private enum ScaleBarState {
        NONE,
        IN_MAP,
        IN_CONTAINER,
    }
}
