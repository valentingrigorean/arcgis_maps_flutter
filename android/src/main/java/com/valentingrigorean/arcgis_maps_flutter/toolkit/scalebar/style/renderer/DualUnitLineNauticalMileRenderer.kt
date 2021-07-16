package com.valentingrigorean.arcgis_maps_flutter.toolkit.scalebar.style.renderer

import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.Path
import com.esri.arcgisruntime.UnitSystem
import com.esri.arcgisruntime.geometry.LinearUnit
import com.valentingrigorean.arcgis_maps_flutter.toolkit.extension.asDistanceString
import com.valentingrigorean.arcgis_maps_flutter.toolkit.extension.calculateBestLength
import com.valentingrigorean.arcgis_maps_flutter.toolkit.extension.selectLinearUnit
import com.valentingrigorean.arcgis_maps_flutter.toolkit.scalebar.LINEAR_UNIT_NAUTICAL_MILES

class DualUnitLineNauticalMileRenderer : ScalebarRenderer() {
    override val isSegmented: Boolean = false

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

        // Calculate scalebar length in the secondary units
        val secondaryBaseUnits = LINEAR_UNIT_NAUTICAL_MILES
        val fullLengthInSecondaryUnits = displayUnits.convertTo(secondaryBaseUnits, distance)

        // Reduce the secondary units length to make it a nice number
        var secondaryUnitsLength =
            calculateBestLength(fullLengthInSecondaryUnits, secondaryBaseUnits)
        val lineDisplayLength = right - left
        val xPosSecondaryTick =
            left + (lineDisplayLength * secondaryUnitsLength / fullLengthInSecondaryUnits).toFloat()

        // Change units if secondaryUnitsLength is too big a number in the base units
        val secondaryDisplayUnits = LINEAR_UNIT_NAUTICAL_MILES

        val verticalTextSpace = textSizePx + textPaint.fontMetrics.bottom

        // Create Paint for drawing the lines
        with(paint) {
            reset()
            style = android.graphics.Paint.Style.STROKE
            strokeWidth = lineWidthPx.toFloat()
            strokeCap = android.graphics.Paint.Cap.ROUND
            strokeJoin = android.graphics.Paint.Join.ROUND

            // Create a path to draw the line and the ticks
            linePath.let { linePath ->
                val yPosLine = ((top + verticalTextSpace) + (bottom)) / 2
                linePath.reset()
                linePath.moveTo(left, top + verticalTextSpace)
                linePath.lineTo(left, bottom) // draw big tick at left
                linePath.moveTo(xPosSecondaryTick, yPosLine) // move to top of secondary tick
                linePath.lineTo(xPosSecondaryTick, bottom) // draw secondary tick
                linePath.moveTo(left, yPosLine) // move to start of horizontal line
                linePath.lineTo(right, yPosLine) // draw the line
                linePath.lineTo(right, top + verticalTextSpace) // draw tick at right
                linePath.setLastPoint(right, top + verticalTextSpace)

                // Create a copy of the line path to be the path of its shadow, offset slightly from the line path
                val shadowPath = Path(linePath)
                shadowPath.offset(
                    com.valentingrigorean.arcgis_maps_flutter.toolkit.scalebar.SHADOW_OFFSET_PIXELS,
                    com.valentingrigorean.arcgis_maps_flutter.toolkit.scalebar.SHADOW_OFFSET_PIXELS
                )

                // Draw the shadow
                color = shadowColor
                canvas.drawPath(shadowPath, this)

                // Draw the line and the ticks
                color = lineColor
                canvas.drawPath(linePath, this)

                // Draw the primary units label above the tick at the right hand end
                var yPosText = top + textSizePx
                textPaint.textAlign = android.graphics.Paint.Align.RIGHT
                canvas.drawText(distance.asDistanceString(), right, yPosText, textPaint)
                textPaint.textAlign = android.graphics.Paint.Align.LEFT
                canvas.drawText(' ' + displayUnits.abbreviation, right, yPosText, textPaint)

                // Draw the secondary units label below its tick
                yPosText = bottom + textSizePx
                textPaint.textAlign = android.graphics.Paint.Align.RIGHT
                canvas.drawText(
                    secondaryUnitsLength.asDistanceString(),
                    xPosSecondaryTick,
                    yPosText,
                    textPaint
                )
                textPaint.textAlign = android.graphics.Paint.Align.LEFT
                canvas.drawText(
                    ' ' + secondaryDisplayUnits.abbreviation,
                    xPosSecondaryTick,
                    yPosText,
                    textPaint
                )
            }
        }
    }

    override fun calculateExtraSpaceForUnits(displayUnits: LinearUnit?, textPaint: Paint): Float {
        return calculateWidthOfUnitsString(displayUnits, textPaint)
    }
}