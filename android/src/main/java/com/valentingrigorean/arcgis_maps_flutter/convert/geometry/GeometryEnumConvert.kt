package com.valentingrigorean.arcgis_maps_flutter.convert.geometry

import com.arcgismaps.geometry.AngularUnitId
import com.arcgismaps.geometry.AreaUnitId
import com.arcgismaps.geometry.GeodeticCurveType
import com.arcgismaps.geometry.GeometryType
import com.arcgismaps.geometry.LatitudeLongitudeFormat
import com.arcgismaps.geometry.LinearUnitId


fun GeometryType.toFlutterValue(): Int {
    return when (this) {
        GeometryType.Unknown -> -1
        GeometryType.Point -> 1
        GeometryType.Envelope -> 2
        GeometryType.Polyline -> 3
        GeometryType.Polygon -> 4
        GeometryType.Multipoint -> 5
    }
}

fun Int.toGeometryType(): GeometryType {
    return when (this) {
        -1 -> GeometryType.Unknown
        1 -> GeometryType.Point
        2 -> GeometryType.Envelope
        3 -> GeometryType.Polyline
        4 -> GeometryType.Polygon
        5 -> GeometryType.Multipoint
        else -> throw IllegalArgumentException("Unknown GeometryType value $this")
    }
}

fun LatitudeLongitudeFormat.toFlutterValue(): Int {
    return when (this) {
        LatitudeLongitudeFormat.DecimalDegrees -> 0
        LatitudeLongitudeFormat.DegreesDecimalMinutes -> 1
        LatitudeLongitudeFormat.DegreesMinutesSeconds -> 2
    }
}

fun Int.toLatitudeLongitudeFormat(): LatitudeLongitudeFormat {
    return when (this) {
        0 -> LatitudeLongitudeFormat.DecimalDegrees
        1 -> LatitudeLongitudeFormat.DegreesDecimalMinutes
        2 -> LatitudeLongitudeFormat.DegreesMinutesSeconds
        else -> throw IllegalArgumentException("Unknown LatitudeLongitudeFormat value $this")
    }
}


fun LinearUnitId.toFlutterValue(): Int {
    return when (this) {
        LinearUnitId.Centimeters -> 0
        LinearUnitId.Feet -> 1
        LinearUnitId.Inches -> 2
        LinearUnitId.Kilometers -> 3
        LinearUnitId.Meters -> 4
        LinearUnitId.Miles -> 5
        LinearUnitId.Millimeters -> 6
        LinearUnitId.NauticalMiles -> 7
        LinearUnitId.Yards -> 8
        LinearUnitId.Other -> 9
    }
}

fun Int.toLinearUnitId(): LinearUnitId {
    return when (this) {
        0 -> LinearUnitId.Centimeters
        1 -> LinearUnitId.Feet
        2 -> LinearUnitId.Inches
        3 -> LinearUnitId.Kilometers
        4 -> LinearUnitId.Meters
        5 -> LinearUnitId.Miles
        6 -> LinearUnitId.Millimeters
        7 -> LinearUnitId.NauticalMiles
        8 -> LinearUnitId.Yards
        9 -> LinearUnitId.Other
        else -> throw IllegalArgumentException("Unknown LinearUnitId value $this")
    }
}

fun AngularUnitId.toFlutterValue(): Int {
    return when (this) {
        AngularUnitId.Degrees -> 0
        AngularUnitId.Minutes -> 1
        AngularUnitId.Seconds -> 2
        AngularUnitId.Grads -> 3
        AngularUnitId.Radians -> 4
        AngularUnitId.Other -> 5
    }
}

fun Int.toAngularUnitId(): AngularUnitId {
    return when (this) {
        0 -> AngularUnitId.Degrees
        1 -> AngularUnitId.Minutes
        2 -> AngularUnitId.Seconds
        3 -> AngularUnitId.Grads
        4 -> AngularUnitId.Radians
        5 -> AngularUnitId.Other
        else -> throw IllegalArgumentException("Unknown AngularUnitId value $this")
    }
}

fun GeodeticCurveType.toFlutterValue(): Int {
    return when (this) {
        GeodeticCurveType.Geodesic -> 0
        GeodeticCurveType.Loxodrome -> 1
        GeodeticCurveType.GreatElliptic -> 2
        GeodeticCurveType.NormalSection -> 3
        GeodeticCurveType.ShapePreserving -> 4
    }
}

fun Int.toGeodeticCurveType(): GeodeticCurveType {
    return when (this) {
        0 -> GeodeticCurveType.Geodesic
        1 -> GeodeticCurveType.Loxodrome
        2 -> GeodeticCurveType.GreatElliptic
        3 -> GeodeticCurveType.NormalSection
        4 -> GeodeticCurveType.ShapePreserving
        else -> throw IllegalArgumentException("Unknown GeodeticCurveType value $this")
    }
}

fun AreaUnitId.toFlutterValue(): Int {
    return when (this) {
        AreaUnitId.Acres -> 0
        AreaUnitId.Hectares -> 1
        AreaUnitId.SquareCentimeters -> 2
        AreaUnitId.SquareDecimeters -> 3
        AreaUnitId.SquareFeet -> 4
        AreaUnitId.SquareMeters -> 5
        AreaUnitId.SquareKilometers -> 6
        AreaUnitId.SquareMiles -> 7
        AreaUnitId.SquareMillimeters -> 8
        AreaUnitId.SquareYards -> 9
        AreaUnitId.Other -> 10
    }
}

fun Int.toAreaUnitId(): AreaUnitId {
    return when (this) {
        0 -> AreaUnitId.Acres
        1 -> AreaUnitId.Hectares
        2 -> AreaUnitId.SquareCentimeters
        3 -> AreaUnitId.SquareDecimeters
        4 -> AreaUnitId.SquareFeet
        5 -> AreaUnitId.SquareMeters
        6 -> AreaUnitId.SquareKilometers
        7 -> AreaUnitId.SquareMiles
        8 -> AreaUnitId.SquareMillimeters
        9 -> AreaUnitId.SquareYards
        10 -> AreaUnitId.Other
        else -> throw IllegalArgumentException("Unknown AreaUnitId value $this")
    }
}