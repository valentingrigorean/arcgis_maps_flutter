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

package com.valentingrigorean.arcgis_maps_flutter.toolkit.extension

import com.arcgismaps.UnitSystem
import com.arcgismaps.geometry.LinearUnit
import com.arcgismaps.geometry.LinearUnitId
import com.valentingrigorean.arcgis_maps_flutter.toolkit.scalebar.Multiplier
import com.valentingrigorean.arcgis_maps_flutter.toolkit.scalebar.style.renderer.ScalebarRenderer
import kotlin.math.floor
import kotlin.math.log10
import kotlin.math.pow

internal const val HALF_MILE_FEET = 2640
internal const val KILOMETER_METERS = 1000

internal val LINEAR_UNIT_METERS = LinearUnit(LinearUnitId.Meters)
internal val LINEAR_UNIT_FEET = LinearUnit(LinearUnitId.Feet)
internal val LINEAR_UNIT_KILOMETERS = LinearUnit(LinearUnitId.Kilometers)
internal val LINEAR_UNIT_MILES = LinearUnit(LinearUnitId.Miles)

/**
 * Array containing the multipliers that may be used for a scalebar and arrays of segment options appropriate for each multiplier.
 *
 * @since 100.5.0
 */
private val MULTIPLIER_DATA_ARRAY = arrayOf(
    Multiplier(1.0, intArrayOf(1, 2, 4, 5)),
    Multiplier(1.2, intArrayOf(1, 2, 3, 4)),
    Multiplier(1.5, intArrayOf(1, 2, 3, 5)),
    Multiplier(1.6, intArrayOf(1, 2, 4)),
    Multiplier(2.0, intArrayOf(1, 2, 4, 5)),
    Multiplier(2.4, intArrayOf(1, 2, 3, 4)),
    Multiplier(3.0, intArrayOf(1, 2, 3)),
    Multiplier(3.6, intArrayOf(1, 2, 3)),
    Multiplier(4.0, intArrayOf(1, 2, 4)),
    Multiplier(5.0, intArrayOf(1, 2, 5)),
    Multiplier(6.0, intArrayOf(1, 2, 3)),
    Multiplier(8.0, intArrayOf(1, 2, 4)),
    Multiplier(9.0, intArrayOf(1, 2, 3)),
    Multiplier(10.0, intArrayOf(1, 2, 5))
)

/**
 * Returns the highest "nice" number less than or equal to [maxLength] for the scalebar to fit within the provided
 * [maxLength] using the provided [unit] indicating the unit of length being used: meters or feet.
 *
 * @since 100.5.0
 */
internal fun ScalebarRenderer.calculateBestLength(maxLength: Double, unit: LinearUnit): Double {
    val magnitude = calculateMagnitude(maxLength)
    var multiplier = selectMultiplierData(maxLength, magnitude).multiplier

    // If the scalebar isn't segmented, force the multiplier to be an integer if it's > 2.0
    if (!isSegmented && multiplier > 2.0) {
        multiplier = Math.floor(multiplier)
    }
    var bestLength = multiplier * magnitude

    // If using imperial units, check if the number of feet is greater than the threshold for using feet; note this
    // isn't necessary for metric units because bestLength calculated using meters will also be a nice number of km
    if (unit.linearUnitId == LinearUnitId.Feet) {
        val displayUnits = selectLinearUnit(bestLength, UnitSystem.Imperial)
        if (unit.linearUnitId != displayUnits.linearUnitId) {
            // 'unit' is feet but we're going to display in miles, so recalculate bestLength to give a nice number of miles
            bestLength = calculateBestLength(unit.convertTo(displayUnits, maxLength), displayUnits)
            // but convert that back to feet because the caller is using feet
            return displayUnits.convertTo(unit, bestLength)
        }
    }
    return bestLength
}

/**
 * Returns the optimal number of segments for the scalebar when the [distance] represented by the whole scalebar has
 * a particular value. The return value is less than or equal to [maxNumSegments] to avoid the labels of the segments
 * overwriting each other (this is passed in by the caller to allow this method to be platform independent).
 * This is optimized so that the labels on the segments are all "nice" numbers.
 *
 * @since 100.5.0
 */
internal fun calculateOptimalNumberOfSegments(distance: Double, maxNumSegments: Int): Int {
    // Select the largest option that's <= maxNumSegments
    return selectMultiplierData(distance, calculateMagnitude(distance)).segmentOptions
        .sortedArrayDescending().first {
            it <= maxNumSegments
        }
}

/**
 * Returns the appropriate [LinearUnit] to use when the [distance] (in feet if [unitSystem] is [UnitSystem.IMPERIAL] or meters if
 * [unitSystem] is [UnitSystem.METRIC]) represented by the whole scalebar has a particular value.
 *
 * @since 100.5.0
 */
internal fun selectLinearUnit(distance: Double, unitSystem: UnitSystem): LinearUnit {
    return when (unitSystem) {
        UnitSystem.Imperial -> {
            // use MILES if at least half a mile
            if (distance >= HALF_MILE_FEET) {
                LINEAR_UNIT_MILES
            } else {
                LINEAR_UNIT_FEET
            }
        }
        UnitSystem.Metric -> {
            // use KILOMETERS if at least one kilometer
            if (distance >= KILOMETER_METERS) {
                LINEAR_UNIT_KILOMETERS
            } else {
                LINEAR_UNIT_METERS
            }
        }
    }
}

/**
 * Returns the "magnitude" (a power of 10) used when calculating the length of a scalebar or the number of segments.
 * This is the largest power of 10 that's less than or equal to the provided [distance].
 *
 * @since 100.5.0
 */
fun calculateMagnitude(distance: Double): Double {
    return 10.0.pow(floor(log10(distance)))
}

/**
 * Returns the [Multiplier] used when calculating the length of a scalebar or the number of segments in the
 * scalebar, using the provided [distance] and [magnitude]. This is chosen to give "nice" numbers for all the labels
 * on the scalebar.
 *
 * @since 100.5.0
 */
private fun selectMultiplierData(distance: Double, magnitude: Double): Multiplier {
    // Select the largest multiplier that's <= the residual value (distance / magnitude)
    return MULTIPLIER_DATA_ARRAY.sortedArrayWith(compareByDescending { it.multiplier }).first {
        it.multiplier <= (distance / magnitude)
    }
}
