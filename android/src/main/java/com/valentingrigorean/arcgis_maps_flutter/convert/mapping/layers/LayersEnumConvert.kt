package com.valentingrigorean.arcgis_maps_flutter.convert.mapping.layers

import com.arcgismaps.mapping.layers.GroupVisibilityMode
import com.arcgismaps.mapping.layers.TileImageFormat

fun Int.toGroupVisibilityMode(): GroupVisibilityMode {
    return when (this) {
        0 -> GroupVisibilityMode.Independent
        1 -> GroupVisibilityMode.Inherited
        2 -> GroupVisibilityMode.Exclusive
        else -> throw IllegalArgumentException("Invalid GroupVisibilityMode value $this")
    }
}

fun Int.toTileImageFormat() : TileImageFormat {
    return when (this) {
        0 -> TileImageFormat.Png
        1 -> TileImageFormat.Png8
        2 -> TileImageFormat.Png24
        3 -> TileImageFormat.Png32
        4 -> TileImageFormat.Jpg
        5 -> TileImageFormat.Mixed
        6 -> TileImageFormat.Lerc
        7 -> TileImageFormat.Unknown
        else -> throw IllegalArgumentException("Invalid TileImageFormat value $this")
    }
}