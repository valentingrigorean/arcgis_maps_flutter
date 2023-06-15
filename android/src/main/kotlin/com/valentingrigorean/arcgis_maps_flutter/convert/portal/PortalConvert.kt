package com.valentingrigorean.arcgis_maps_flutter.convert.portal

import com.arcgismaps.portal.Portal

fun Any.toPortalOrNull(): Portal? {
    val data = this as Map<*, *>? ?: return null
    val url = data["url"] as String
    val connection =  toConnection(data["connection"])
    return Portal(url, connection)
}


private fun toConnection(value: Any?): Portal.Connection {
    return when (value) {
        0 -> Portal.Connection.Anonymous
        1 -> Portal.Connection.Authenticated
        else -> Portal.Connection.Anonymous
    }
}