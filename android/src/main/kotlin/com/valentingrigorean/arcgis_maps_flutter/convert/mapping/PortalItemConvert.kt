package com.valentingrigorean.arcgis_maps_flutter.convert.mapping

import com.arcgismaps.mapping.PortalItem
import com.valentingrigorean.arcgis_maps_flutter.convert.portal.toPortalOrNull

fun Any.toPortalItemOrNull(): PortalItem? {
    val data = this as Map<*, *>? ?: return null
    val portal = data["portal"]?.toPortalOrNull()!!
    val itemId = data["itemId"] as String
    return PortalItem(portal, itemId)
}