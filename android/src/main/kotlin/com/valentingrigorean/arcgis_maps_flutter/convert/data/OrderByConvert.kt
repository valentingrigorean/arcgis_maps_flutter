package com.valentingrigorean.arcgis_maps_flutter.convert.data

import com.arcgismaps.data.OrderBy

fun Any.toOrderByOrNull(): OrderBy? {
    val data = this as? Map<*, *> ?: return null
    val fieldName = data["fieldName"] as String
    val sortOrder = (data["sortOrder"] as Int).toSortOrder()
    return OrderBy(fieldName, sortOrder)
}