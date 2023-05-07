package com.valentingrigorean.arcgis_maps_flutter.convert.arcgisservices

import com.arcgismaps.arcgisservices.TimeUnit
import com.arcgismaps.geometry.LinearUnitId

fun TimeUnit.toFlutterValue() : Int{
    return when(this){
        TimeUnit.Unknown -> 0
        TimeUnit.Centuries -> 1
        TimeUnit.Days -> 2
        TimeUnit.Decades -> 3
        TimeUnit.Hours -> 4
        TimeUnit.Milliseconds -> 5
        TimeUnit.Minutes -> 6
        TimeUnit.Months -> 7
        TimeUnit.Seconds -> 8
        TimeUnit.Weeks -> 9
        TimeUnit.Years -> 10
    }
}

fun Int.toTimeUnit() : TimeUnit{
    return when(this){
        0 -> TimeUnit.Unknown
        1 -> TimeUnit.Centuries
        2 -> TimeUnit.Days
        3 -> TimeUnit.Decades
        4 -> TimeUnit.Hours
        5 -> TimeUnit.Milliseconds
        6 -> TimeUnit.Minutes
        7 -> TimeUnit.Months
        8 -> TimeUnit.Seconds
        9 -> TimeUnit.Weeks
        10 -> TimeUnit.Years
        else -> TimeUnit.Unknown
    }
}
