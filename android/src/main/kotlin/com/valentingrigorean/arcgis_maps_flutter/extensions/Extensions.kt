package com.valentingrigorean.arcgis_maps_flutter.extensions

import android.content.res.Resources

val Int.dp: Int
    get() = (this * Resources.getSystem().displayMetrics.density).toInt()

val Float.dp: Float
    get() = this * Resources.getSystem().displayMetrics.density

val Int.sp: Float
    get() = this * Resources.getSystem().displayMetrics.scaledDensity

val Float.sp: Float
    get() = this * Resources.getSystem().displayMetrics.scaledDensity
