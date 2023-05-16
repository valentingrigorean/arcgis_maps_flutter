/*
 * Copyright 2019 Esri
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.valentingrigorean.arcgis_maps_flutter.toolkit.scalebar.style.renderer

import android.graphics.Canvas
import android.graphics.Paint
import com.arcgismaps.UnitSystem
import com.arcgismaps.geometry.LinearUnit
import com.valentingrigorean.arcgis_maps_flutter.toolkit.extension.asDistanceString
import com.valentingrigorean.arcgis_maps_flutter.toolkit.scalebar.style.Style
import com.valentingrigorean.arcgis_maps_flutter.toolkit.scalebar.style.Style.BAR

/**
 * Renders a [BAR] style scalebar.
 *
 * @see Style.BAR
 *
 * @since 100.5.0
 */
class BarRenderer : ScalebarRenderer() {

    override val isSegmented: Boolean = false

    override fun calculateExtraSpaceForUnits(displayUnits: LinearUnit?, textPaint: Paint): Float = 0f

    override fun drawScalebar(
        canvas: Canvas,
        left: Float,
        top: Float,
        right: Float,
        bottom: Float,
        distance: Double,
        displayUnits: LinearUnit,
        unitSystem: UnitSystem,
        lineWidthPx: Int,
        cornerRadiusPx: Int,
        textSizePx: Int,
        fillColor: Int,
        alternateFillColor: Int,
        shadowColor: Int,
        lineColor: Int,
        textPaint: Paint,
        displayDensity: Float
    ) {
        // Draw a solid bar and its shadow
        drawBarAndShadow(
            canvas,
            left,
            top,
            right,
            bottom,
            lineWidthPx,
            cornerRadiusPx,
            fillColor,
            shadowColor
        )

        // Draw a rectangle round the outside
        with(rectF) {
            set(left, top, right, bottom)
            paint.let { paint ->
                paint.reset()
                paint.color = lineColor
                paint.style = Paint.Style.STROKE
                paint.strokeWidth = lineWidthPx.toFloat()

                canvas.drawRoundRect(
                    this,
                    cornerRadiusPx.toFloat(),
                    cornerRadiusPx.toFloat(),
                    paint
                )
            }
        }

        // Draw the label, centered on the center of the bar
        textPaint.textAlign = Paint.Align.CENTER
        canvas.drawText(
            "${distance.asDistanceString()} ${displayUnits.abbreviation}",
            left + (right - left) / 2,
            bottom + textSizePx,
            textPaint
        )
    }
}
