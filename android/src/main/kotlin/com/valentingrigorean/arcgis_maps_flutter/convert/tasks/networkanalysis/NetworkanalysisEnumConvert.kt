package com.valentingrigorean.arcgis_maps_flutter.convert.tasks.networkanalysis

import com.arcgismaps.tasks.networkanalysis.AttributeUnit
import com.arcgismaps.tasks.networkanalysis.CurbApproach
import com.arcgismaps.tasks.networkanalysis.DirectionManeuverType
import com.arcgismaps.tasks.networkanalysis.DirectionMessageType
import com.arcgismaps.tasks.networkanalysis.DirectionsStyle
import com.arcgismaps.tasks.networkanalysis.LocationStatus
import com.arcgismaps.tasks.networkanalysis.NetworkDirectionsSupport
import com.arcgismaps.tasks.networkanalysis.RouteShapeType
import com.arcgismaps.tasks.networkanalysis.StopType
import com.arcgismaps.tasks.networkanalysis.UTurnPolicy

fun DirectionsStyle.toFlutterValue(): Int {
    return when (this) {
        DirectionsStyle.Desktop -> 0
        DirectionsStyle.Navigation -> 1
        DirectionsStyle.Campus -> 2
    }
}

fun Int.toDirectionsStyle(): DirectionsStyle {
    return when (this) {
        0 -> DirectionsStyle.Desktop
        1 -> DirectionsStyle.Navigation
        2 -> DirectionsStyle.Campus
        else -> throw IllegalStateException("Unexpected value: $this")
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

fun Int.toUTurnPolicy(): UTurnPolicy {
    return when (this) {
        0 -> UTurnPolicy.NotAllowed
        1 -> UTurnPolicy.AllowedAtDeadEnds
        2 -> UTurnPolicy.AllowedAtIntersections
        3 -> UTurnPolicy.AllowedAtDeadEndsAndIntersections
        else -> throw IllegalStateException("Unexpected value: $this")
    }
}

fun AttributeUnit.toFlutterValue(): Int {
    return when (this) {
        AttributeUnit.Unknown -> 0
        AttributeUnit.Inches -> 1
        AttributeUnit.Feet -> 2
        AttributeUnit.Yards -> 3
        AttributeUnit.Miles -> 4
        AttributeUnit.Millimeters -> 5
        AttributeUnit.Centimeters -> 6
        AttributeUnit.Meters -> 7
        AttributeUnit.Kilometers -> 8
        AttributeUnit.NauticalMiles -> 9
        AttributeUnit.DecimalDegrees -> 10
        AttributeUnit.Seconds -> 11
        AttributeUnit.Minutes -> 12
        AttributeUnit.Hours -> 13
        AttributeUnit.Days -> 14
        AttributeUnit.Decimeters -> 15
    }
}

fun Int.toAttributeUnit(): AttributeUnit {
    return when (this) {
        0 -> AttributeUnit.Unknown
        1 -> AttributeUnit.Inches
        2 -> AttributeUnit.Feet
        3 -> AttributeUnit.Yards
        4 -> AttributeUnit.Miles
        5 -> AttributeUnit.Millimeters
        6 -> AttributeUnit.Centimeters
        7 -> AttributeUnit.Meters
        8 -> AttributeUnit.Kilometers
        9 -> AttributeUnit.NauticalMiles
        10 -> AttributeUnit.DecimalDegrees
        11 -> AttributeUnit.Seconds
        12 -> AttributeUnit.Minutes
        13 -> AttributeUnit.Hours
        14 -> AttributeUnit.Days
        15 -> AttributeUnit.Decimeters
        else -> throw IllegalStateException("Unexpected value: $this")
    }
}

fun NetworkDirectionsSupport.toFlutterValue(): Int {
    return when (this) {
        NetworkDirectionsSupport.Unknown -> 0
        NetworkDirectionsSupport.Unsupported -> 1
        NetworkDirectionsSupport.Supported -> 2
    }
}


fun StopType.toFlutterValue(): Int {
    return when (this) {
        StopType.Stop -> 0
        StopType.Waypoint -> 1
        StopType.RestBreak -> 2
    }
}

fun Int.toStopType(): StopType {
    return when (this) {
        0 -> StopType.Stop
        1 -> StopType.Waypoint
        2 -> StopType.RestBreak
        else -> throw IllegalStateException("Unexpected value: $this")
    }
}

fun CurbApproach.toFlutterValue(): Int{
    return when (this) {
        CurbApproach.Unknown -> -1
        CurbApproach.EitherSide -> 0
        CurbApproach.LeftSide -> 1
        CurbApproach.RightSide -> 2
        CurbApproach.NoUTurn -> 3
    }
}

fun Int.toCurbApproach(): CurbApproach {
    return when (this) {
        -1 -> CurbApproach.Unknown
        0 -> CurbApproach.EitherSide
        1 -> CurbApproach.LeftSide
        2 -> CurbApproach.RightSide
        3 -> CurbApproach.NoUTurn
        else -> throw IllegalStateException("Unexpected value: $this")
    }
}

fun DirectionMessageType.toFlutterValue() : Int{
    return when (this){
        DirectionMessageType.StreetName -> 0
        DirectionMessageType.AlternativeName -> 1
        DirectionMessageType.Branch -> 2
        DirectionMessageType.Toward -> 3
        DirectionMessageType.CrossStreet -> 4
        DirectionMessageType.Exit -> 5
    }
}

fun DirectionManeuverType.toFlutterValue(): Int {
    return when (this) {
        DirectionManeuverType.Unknown -> -1
        DirectionManeuverType.Stop -> 0
        DirectionManeuverType.Straight -> 1
        DirectionManeuverType.BearLeft -> 2
        DirectionManeuverType.BearRight -> 3
        DirectionManeuverType.TurnLeft -> 4
        DirectionManeuverType.TurnRight -> 5
        DirectionManeuverType.SharpLeft -> 6
        DirectionManeuverType.SharpRight -> 7
        DirectionManeuverType.UTurn -> 8
        DirectionManeuverType.Ferry -> 9
        DirectionManeuverType.Roundabout -> 10
        DirectionManeuverType.HighwayMerge -> 11
        DirectionManeuverType.HighwayExit -> 12
        DirectionManeuverType.HighwayChange -> 13
        DirectionManeuverType.ForkCenter -> 14
        DirectionManeuverType.ForkLeft -> 15
        DirectionManeuverType.ForkRight -> 16
        DirectionManeuverType.Depart -> 17
        DirectionManeuverType.TripItem -> 18
        DirectionManeuverType.EndOfFerry -> 19
        DirectionManeuverType.RampRight -> 20
        DirectionManeuverType.RampLeft -> 21
        DirectionManeuverType.TurnLeftRight -> 22
        DirectionManeuverType.TurnRightLeft -> 23
        DirectionManeuverType.TurnRightRight -> 24
        DirectionManeuverType.TurnLeftLeft -> 25
        DirectionManeuverType.PedestrianRamp -> 26
        DirectionManeuverType.Elevator -> 27
        DirectionManeuverType.Escalator -> 28
        DirectionManeuverType.Stairs -> 29
        DirectionManeuverType.DoorPassage -> 30
    }
}

fun LocationStatus.toFlutterValue():Int {
    return when (this){
        LocationStatus.NotLocated -> 0
        LocationStatus.OnClosest -> 1
        LocationStatus.OnClosestNotRestricted -> 2
        LocationStatus.NotReached -> 3
    }
}

