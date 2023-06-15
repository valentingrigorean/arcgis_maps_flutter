package com.valentingrigorean.arcgis_maps_flutter.utils

object StringUtils {
    fun areEqual(s1: String?, s2: String?): Boolean {
        if (s1 == null && s2 == null) return true
        return if (s1 == null || s2 == null) false else s1 == s2
    }
}