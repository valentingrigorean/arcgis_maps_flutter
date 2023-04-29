package com.valentingrigorean.arcgis_maps_flutter.map

import android.content.Context
import android.view.ViewGroup
import android.view.ViewPropertyAnimator
import android.widget.FrameLayout
import com.esri.arcgisruntime.mapping.view.MapScaleChangedEvent
import com.esri.arcgisruntime.mapping.view.MapScaleChangedListener
import com.valentingrigorean.arcgis_maps_flutter.Convert
import com.valentingrigorean.arcgis_maps_flutter.toolkit.scalebar.Scalebar
import com.valentingrigorean.arcgis_maps_flutter.utils.toMap

class ScaleBarController(
    private val context: Context,
    private val flutterMapViewDelegate: FlutterMapViewDelegate,
    private val container: FrameLayout
) : MapScaleChangedListener {
    private val scalebar: Scalebar
    private var scaleBarState = ScaleBarState.NONE
    private var layoutParams: FrameLayout.LayoutParams? = null
    private var isAutoHide = false
    private var hideAfterMS = 2000
    private var viewPropertyAnimator: ViewPropertyAnimator? = null
    private var mapScale = 0.0
    private var didGotScale = false

    init {
        scalebar = Scalebar(context)
        scalebar.alpha = 0f
        flutterMapViewDelegate.addMapScaleChangedListener(this)
    }

    fun dispose() {
        removeScaleBar()
        flutterMapViewDelegate.removeMapScaleChangedListener(this)
    }

    fun removeScaleBar() {
        when (scaleBarState) {
            ScaleBarState.NONE -> {}
            ScaleBarState.IN_MAP -> scalebar.removeFromMapView()
            ScaleBarState.IN_CONTAINER -> {
                scalebar.bindTo(null)
                container.removeView(scalebar)
            }
        }
        scaleBarState = ScaleBarState.NONE
    }

    override fun mapScaleChanged(mapScaleChangedEvent: MapScaleChangedEvent) {
        if (viewPropertyAnimator != null) {
            viewPropertyAnimator!!.cancel()
            viewPropertyAnimator = null
        }
        val currentScale = flutterMapViewDelegate.mapScale
        if (mapScale == currentScale) {
            return
        }
        mapScale = currentScale
        if (!didGotScale) {
            didGotScale = true
            return
        }
        if (scaleBarState == ScaleBarState.NONE) {
            return
        }
        if (!isAutoHide) return
        scalebar.alpha = 1f
        viewPropertyAnimator = scalebar.animate()
            .setDuration(hideAfterMS.toLong())
            .alpha(0f)
            .withEndAction { viewPropertyAnimator = null }
    }

    fun interpretConfiguration(o: Any) {
        val data: Map<*, *> = Convert.Companion.toMap(o)
        if (data == null) {
            removeScaleBar()
            return
        }
        val showInMap: Boolean = Convert.Companion.toBoolean(
            data["showInMap"]!!
        )
        validateScaleBarState(showInMap)
        if (showInMap) {
            val inMapAlignment = data["inMapAlignment"]
            if (inMapAlignment != null) {
                scalebar.alignment =
                    Convert.Companion.toScaleBarAlignment(Convert.Companion.toInt(inMapAlignment))
            }
        } else {
            val width: Int = Convert.Companion.toInt(
                data["width"]
            )
            val offsetPoints: List<*> = Convert.Companion.toList(
                data["offset"]!!
            )
            if (width < 0) {
                layoutParams!!.width = ViewGroup.LayoutParams.WRAP_CONTENT
            } else {
                layoutParams!!.width = Convert.Companion.dpToPixelsI(
                    context, width
                )
            }
            layoutParams!!.leftMargin = Convert.Companion.dpToPixelsI(
                context, Convert.Companion.toInt(
                    offsetPoints[0]
                )
            )
            layoutParams!!.topMargin = Convert.Companion.dpToPixelsI(
                context, Convert.Companion.toInt(
                    offsetPoints[1]
                )
            )
        }
        isAutoHide = Convert.Companion.toBoolean(data["autoHide"]!!)
        hideAfterMS = Convert.Companion.toInt(data["hideAfter"])
        if (isAutoHide) {
            scalebar.alpha = 0f
            mapScale = flutterMapViewDelegate.mapScale
        } else {
            scalebar.alpha = 1f
        }
        scalebar.unitSystem = Convert.Companion.toUnitSystem(
            Convert.Companion.toInt(
                data["units"]
            )
        )
        scalebar.style = Convert.Companion.toScaleBarStyle(
            Convert.Companion.toInt(
                data["style"]
            )
        )
        scalebar.fillColor = Convert.Companion.toInt(data["fillColor"])
        scalebar.alternateFillColor = Convert.Companion.toInt(
            data["alternateFillColor"]
        )
        scalebar.lineColor = Convert.Companion.toInt(data["lineColor"])
        scalebar.shadowColor = Convert.Companion.toInt(
            data["shadowColor"]
        )
        scalebar.textColor = Convert.Companion.toInt(data["textColor"])
        scalebar.textShadowColor = Convert.Companion.toInt(
            data["textShadowColor"]
        )
        scalebar.textSize = Convert.Companion.spToPixels(
            context, Convert.Companion.toInt(data["textSize"])
        )
    }

    private fun validateScaleBarState(isInMap: Boolean) {
        if (isInMap && scaleBarState != ScaleBarState.IN_MAP) {
            removeScaleBar()
            scalebar.addToMapView(flutterMapViewDelegate.mapView)
            scaleBarState = ScaleBarState.IN_MAP
        } else if (scaleBarState != ScaleBarState.IN_CONTAINER) {
            removeScaleBar()
            scalebar.bindTo(flutterMapViewDelegate.mapView)
            layoutParams = FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                Convert.Companion.dpToPixelsI(context, 50)
            )
            container.addView(scalebar, layoutParams)
            scaleBarState = ScaleBarState.IN_CONTAINER
        }
    }

    private enum class ScaleBarState {
        NONE, IN_MAP, IN_CONTAINER
    }
}