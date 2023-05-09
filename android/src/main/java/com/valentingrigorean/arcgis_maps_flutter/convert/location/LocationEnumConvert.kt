package com.valentingrigorean.arcgis_maps_flutter.convert.location

import com.arcgismaps.location.LocationDisplayAutoPanMode

fun LocationDisplayAutoPanMode.toFlutterValue() : Int{
    return when(this){
        LocationDisplayAutoPanMode.Off -> 0
        LocationDisplayAutoPanMode.Recenter -> 1
        LocationDisplayAutoPanMode.Navigation -> 2
        LocationDisplayAutoPanMode.CompassNavigation -> 3
    }
}

fun Int.toLocationDisplayAutoPanMode() : LocationDisplayAutoPanMode{
    return when(this){
        0 -> LocationDisplayAutoPanMode.Off
        1 -> LocationDisplayAutoPanMode.Recenter
        2 -> LocationDisplayAutoPanMode.Navigation
        3 -> LocationDisplayAutoPanMode.CompassNavigation
        else -> LocationDisplayAutoPanMode.Off
    }
}