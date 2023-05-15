package com.valentingrigorean.arcgis_maps_flutter.map

import android.content.Context
import android.view.ViewGroup
import android.view.ViewPropertyAnimator
import android.widget.FrameLayout
import com.arcgismaps.mapping.view.MapView
import com.valentingrigorean.arcgis_maps_flutter.ConvertUtils
import com.valentingrigorean.arcgis_maps_flutter.convert.toUnitSystem
import com.valentingrigorean.arcgis_maps_flutter.toolkit.scalebar.Scalebar
import com.valentingrigorean.arcgis_maps_flutter.toolkit.scalebar.style.Style
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach

class ScaleBarController(
    private val context: Context,
    private val mapView: MapView,
    private val container: FrameLayout,
    scope: CoroutineScope
) {
    private val scalebar: Scalebar = Scalebar(context)
    private var scaleBarState = ScaleBarState.NONE
    private var layoutParams: FrameLayout.LayoutParams? = null
    private var isAutoHide = false
    private var hideAfterMS = 2000
    private var viewPropertyAnimator: ViewPropertyAnimator? = null
    private var mapScale = 0.0
    private var didGotScale = false

    init {
        scalebar.alpha = 0f
        mapView.mapScale.onEach {
            viewPropertyAnimator?.cancel()
            viewPropertyAnimator = null
            val currentScale = it
            if (mapScale == currentScale) {
                return@onEach
            }
            mapScale = currentScale
            if (!didGotScale) {
                didGotScale = true
                return@onEach
            }
            if (scaleBarState == ScaleBarState.NONE) {
                return@onEach
            }
            if (!isAutoHide) return@onEach
            scalebar.alpha = 1f
            viewPropertyAnimator = scalebar.animate()
                .setDuration(hideAfterMS.toLong())
                .alpha(0f)
                .withEndAction { viewPropertyAnimator = null }
        }.launchIn(scope)
    }

    fun dispose() {
        removeScaleBar()
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

    fun interpretConfiguration(o: Any) {
        val data = o as Map<*, *>?
        if (data == null) {
            removeScaleBar()
            return
        }
        val showInMap = data["showInMap"] as Boolean
        validateScaleBarState(showInMap)
        if (showInMap) {
            val inMapAlignment = data["inMapAlignment"] as Int?
            if (inMapAlignment != null) {
                scalebar.alignment = toScaleBarAlignment(inMapAlignment)
            }
        } else {
            val width = data["width"] as Int
            val offsetPoints = data["offset"] as List<Int>
            if (width < 0) {
                layoutParams!!.width = ViewGroup.LayoutParams.WRAP_CONTENT
            } else {
                layoutParams!!.width = ConvertUtils.dpToPixelsI(
                    context, width
                )
            }
            layoutParams!!.leftMargin = ConvertUtils.dpToPixelsI(
                context, offsetPoints[0]
            )
            layoutParams!!.topMargin = ConvertUtils.dpToPixelsI(
                context, offsetPoints[1]
            )
        }
        isAutoHide = data["autoHide"] as Boolean
        hideAfterMS = data["hideAfter"] as Int
        if (isAutoHide) {
            scalebar.alpha = 0f
            mapScale = mapView.mapScale.value
        } else {
            scalebar.alpha = 1f
        }
        scalebar.unitSystem = (data["units"] as Int).toUnitSystem()
        scalebar.style = toScaleBarStyle(data["style"] as Int)
        scalebar.fillColor = data["fillColor"] as Int
        scalebar.alternateFillColor = data["alternateFillColor"] as Int
        scalebar.lineColor = data["lineColor"] as Int
        scalebar.shadowColor = data["shadowColor"] as Int
        scalebar.textColor = data["textColor"] as Int
        scalebar.textShadowColor = data["textShadowColor"] as Int
        scalebar.textSize = ConvertUtils.spToPixels(
            context, data["textSize"] as Int
        )
    }

    private fun validateScaleBarState(isInMap: Boolean) {
        if (isInMap && scaleBarState != ScaleBarState.IN_MAP) {
            removeScaleBar()
            scalebar.addToMapView(mapView)
            scaleBarState = ScaleBarState.IN_MAP
        } else if (scaleBarState != ScaleBarState.IN_CONTAINER) {
            removeScaleBar()
            scalebar.bindTo(mapView)
            layoutParams = FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ConvertUtils.dpToPixelsI(context, 50)
            )
            container.addView(scalebar, layoutParams)
            scaleBarState = ScaleBarState.IN_CONTAINER
        }
    }

    private fun toScaleBarAlignment(rawValue: Int): Scalebar.Alignment {
        return when (rawValue) {
            0 -> Scalebar.Alignment.LEFT
            1 -> Scalebar.Alignment.RIGHT
            2 -> Scalebar.Alignment.CENTER
            else -> throw IllegalStateException("Unexpected value: $rawValue")
        }
    }

    private fun toScaleBarStyle(rawValue: Int): Style {
        return when (rawValue) {
            0 -> Style.LINE
            1 -> Style.BAR
            2 -> Style.GRADUATED_LINE
            3 -> Style.ALTERNATING_BAR
            4 -> Style.DUAL_UNIT_LINE
            5 -> Style.DUAL_UNIT_LINE_NAUTICAL_MILE
            else -> throw IllegalStateException("Unexpected value: $rawValue")
        }
    }


    private enum class ScaleBarState {
        NONE, IN_MAP, IN_CONTAINER
    }
}