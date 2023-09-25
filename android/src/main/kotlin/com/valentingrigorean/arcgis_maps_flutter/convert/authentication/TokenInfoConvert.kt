package com.valentingrigorean.arcgis_maps_flutter.convert.authentication

import com.arcgismaps.httpcore.authentication.TokenInfo
import com.valentingrigorean.arcgis_maps_flutter.convert.fromFlutterInstant

fun Any.toTokenInfoOrNull() : TokenInfo?{
    val data = this as? Map<*, *> ?: return null
    val accessToken = data["accessToken"] as String
    val expirationDate = data["expirationDate"] as String
    val isSSLRequired = data["isSSLRequired"] as Boolean
    return TokenInfo(accessToken, expirationDate.fromFlutterInstant(), isSSLRequired)
}