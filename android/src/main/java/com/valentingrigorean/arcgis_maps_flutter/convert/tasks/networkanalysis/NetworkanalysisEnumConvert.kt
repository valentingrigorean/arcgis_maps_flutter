package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.networkanalysis

import com.arcgismaps.tasks.networkanalysis.DirectionsStyle
import com.arcgismaps.tasks.networkanalysis.RouteShapeType
import com.arcgismaps.tasks.networkanalysis.UTurnPolicy

fun DirectionsStyle.toFlutterValue(): Int {
    return when (this) {
        DirectionsStyle.Desktop -> 0
        DirectionsStyle.Navigation -> 1
        DirectionsStyle.Campus -> 2
    }
}

fun RouteShapeType.toFlutterValue(): Int {
    return when (this) {
        RouteShapeType.None -> 0
        RouteShapeType.StraightLine -> 1
        RouteShapeType.TrueShapeWithMeasures -> 2
    }
}

fun UTurnPolicy.toFlutterValue(): Int {
    return when (this) {
        UTurnPolicy.NotAllowed -> 0
        UTurnPolicy.AllowedAtDeadEnds -> 1
        UTurnPolicy.AllowedAtIntersections -> 2
        UTurnPolicy.AllowedAtDeadEndsAndIntersections -> 3
    }
}

fun Int.toUTurnPolicy() : UTurnPolicy{
    return when (this) {
        0 -> UTurnPolicy.NotAllowed
        1 -> UTurnPolicy.AllowedAtDeadEnds
        2 -> UTurnPolicy.AllowedAtIntersections
        3 -> UTurnPolicy.AllowedAtDeadEndsAndIntersections
        else -> throw IllegalStateException("Unexpected value: $this")
    }
}