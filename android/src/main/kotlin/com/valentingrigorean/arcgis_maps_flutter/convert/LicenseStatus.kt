package com.valentingrigorean.arcgis_maps_flutter.convert

import com.arcgismaps.LicenseStatus

fun LicenseStatus.toFlutterValue() {
    when (this) {
        LicenseStatus.Invalid -> 0
        LicenseStatus.Expired -> 1
        LicenseStatus.LoginRequired -> 2
        LicenseStatus.Valid -> 3
    }
}