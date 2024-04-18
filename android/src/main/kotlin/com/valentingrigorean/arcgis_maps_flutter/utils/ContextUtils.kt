package com.valentingrigorean.arcgis_maps_flutter.utils

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import androidx.core.content.res.ResourcesCompat
import androidx.core.graphics.drawable.DrawableCompat

private val resourceIdCache = HashMap<String, Int>()

@SuppressLint("DiscouragedApi")
fun Context.getResourceIdByName(name: String): Int {
    if (resourceIdCache.containsKey(name)) {
        return resourceIdCache[name]!!
    }

    val resourceId = resources.getIdentifier(name, "drawable", packageName)
    resourceIdCache[name] = resourceId
    return resourceId
}

fun Context.createDrawableBitmap(name: String, tintColor: Int? = null): BitmapDrawable? {
    val resourceId = getResourceIdByName(name)
    if (resourceId == 0) {
        return null
    }

    val drawable = createDrawable(resourceId, tintColor)

    if (drawable is BitmapDrawable) {
        return drawable
    }

    val bitmap = Bitmap.createBitmap(
        drawable.intrinsicWidth,
        drawable.intrinsicHeight,
        Bitmap.Config.ARGB_8888
    )
    val canvas = android.graphics.Canvas(bitmap)
    drawable.setBounds(0, 0, canvas.width, canvas.height)
    drawable.draw(canvas)
    return BitmapDrawable(resources, bitmap)
}

private fun Context.createDrawable(resourceId: Int, tintColor: Int? = null): Drawable {
    val drawable = ResourcesCompat.getDrawableForDensity(
        resources,
        resourceId,
        resources.displayMetrics.densityDpi,
        theme
    )
    if (tintColor == null) {
        return drawable!!
    }
    val wrappedDrawable = DrawableCompat.wrap(
        drawable!!
    )
    DrawableCompat.setTint(wrappedDrawable, tintColor)
    return wrappedDrawable
}

